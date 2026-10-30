import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'client_ip.dart';

/// Automatic IP blocking (roadbook phase 2, cahier des charges « Blocage
/// automatique des adresses IP »).
///
/// - [maxFailures] failures within [window] ban the IP for [baseBan]; every
///   new ban of the same IP doubles the duration (capped at [maxBan]).
/// - Failures: wrong password, wrong verification or reset code, wrong setup
///   code, invalid invitation link.
/// - Allow-listed IPs (OWNCOFFER_IP_ALLOWLIST, e.g. the home network) are
///   never banned.
/// - Each failure is logged as `[auth-failure] ip=… kind=…` so fail2ban or
///   CrowdSec can also block at the firewall.
class IpGuard {
  final int maxFailures;
  final Duration window;
  final Duration baseBan;
  final Duration maxBan;
  final List<IpRange> allowlist;
  final ClientIpResolver resolver;

  /// Active bans, kept in memory so every request can be checked cheaply.
  final Map<String, DateTime> _banned = {};

  IpGuard({
    required this.resolver,
    this.allowlist = const [],
    this.maxFailures = 5,
    this.window = const Duration(minutes: 15),
    this.baseBan = const Duration(hours: 1),
    this.maxBan = const Duration(days: 30),
  });

  factory IpGuard.fromEnvironment(Map<String, String> env) => IpGuard(
    resolver: ClientIpResolver.fromEnvironment(env),
    allowlist: parseRanges(env['OWNCOFFER_IP_ALLOWLIST']),
    maxFailures: int.tryParse(env['OWNCOFFER_BAN_MAX_FAILURES'] ?? '') ?? 5,
    window: Duration(
      minutes: int.tryParse(env['OWNCOFFER_BAN_WINDOW_MINUTES'] ?? '') ?? 15,
    ),
    baseBan: Duration(
      minutes: int.tryParse(env['OWNCOFFER_BAN_MINUTES'] ?? '') ?? 60,
    ),
  );

  static IpGuard? _instance;
  static IpGuard get instance =>
      _instance ??= IpGuard.fromEnvironment(Platform.environment);
  static set instance(IpGuard guard) => _instance = guard;

  /// Real client IP of the call, or null for internal sessions.
  String? clientIp(Session session) {
    final request = session.request;
    if (request == null) return null;
    return resolver.resolve(
      request.connectionInfo.remote.address.toString(),
      request.headers[clientIpHeader]?.firstOrNull,
    );
  }

  bool _allowed(String ip) {
    final address = InternetAddress.tryParse(ip);
    return address != null && inRanges(allowlist, address);
  }

  /// Whether [ip] is currently banned.
  bool isBanned(String? ip, {DateTime? now}) {
    if (ip == null) return false;
    final until = _banned[ip];
    if (until == null) return false;
    if (until.isAfter(now ?? DateTime.now().toUtc())) return true;
    _banned.remove(ip);
    return false;
  }

  /// Loads active bans at start-up.
  Future<void> load(Session session) async {
    final now = DateTime.now().toUtc();
    for (final b in await IpBan.db.find(
      session,
      where: (b) => b.bannedUntil > now,
    )) {
      _banned[b.ip] = b.bannedUntil!;
    }
  }

  /// Records a failed attempt of the caller; bans it when the limit is hit.
  Future<void> recordFailure(Session session, String kind) async {
    final ip = clientIp(session);
    if (ip == null) return;
    await recordFailureFor(session, ip, kind);
  }

  Future<void> recordFailureFor(
    Session session,
    String ip,
    String kind, {
    DateTime? now,
  }) async {
    final t = now ?? DateTime.now().toUtc();
    session.log('[auth-failure] ip=$ip kind=$kind', level: LogLevel.warning);
    if (_allowed(ip)) return;
    await session.db.transaction((tx) async {
      var row = await IpBan.db.findFirstRow(
        session,
        where: (b) => b.ip.equals(ip),
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      row ??= await IpBan.db.insertRow(
        session,
        IpBan(ip: ip, windowStart: t, lastFailureAt: t, lastFailureKind: kind),
        transaction: tx,
      );
      if (row.bannedUntil != null && row.bannedUntil!.isAfter(t)) return;
      var failures = row.failures;
      var windowStart = row.windowStart;
      if (t.difference(windowStart) > window) {
        failures = 0;
        windowStart = t;
      }
      failures++;
      DateTime? bannedUntil = row.bannedUntil;
      var banCount = row.banCount;
      if (failures >= maxFailures) {
        banCount++;
        bannedUntil = t.add(banDuration(banCount));
        failures = 0;
        windowStart = t;
        _banned[ip] = bannedUntil;
        session.log(
          '[ip-banned] ip=$ip until=${bannedUntil.toIso8601String()} '
          'count=$banCount',
          level: LogLevel.warning,
        );
      }
      await IpBan.db.updateRow(
        session,
        row.copyWith(
          failures: failures,
          windowStart: windowStart,
          lastFailureAt: t,
          lastFailureKind: kind,
          bannedUntil: bannedUntil,
          banCount: banCount,
        ),
        transaction: tx,
      );
    });
  }

  /// Ban length for the n-th ban: base, then doubled each time.
  Duration banDuration(int banCount) {
    final factor = 1 << (banCount - 1).clamp(0, 20);
    final d = baseBan * factor;
    return d > maxBan ? maxBan : d;
  }

  /// Lifts a ban (server administrator). Past bans still count for the next
  /// duration.
  Future<void> unban(Session session, String ip) async {
    _banned.remove(ip);
    final row = await IpBan.db.findFirstRow(
      session,
      where: (b) => b.ip.equals(ip),
    );
    if (row != null) {
      await IpBan.db.updateRow(
        session,
        row.copyWith(bannedUntil: null, failures: 0),
      );
    }
  }

  Future<List<IpBanInfo>> activeBans(Session session) async {
    final now = DateTime.now().toUtc();
    final rows = await IpBan.db.find(
      session,
      where: (b) => b.bannedUntil > now,
      orderBy: (b) => b.bannedUntil,
    );
    return [
      for (final r in rows)
        IpBanInfo(
          ip: r.ip,
          bannedUntil: r.bannedUntil!,
          banCount: r.banCount,
          lastFailureKind: r.lastFailureKind,
        ),
    ];
  }

  /// For tests.
  void clearMemory() => _banned.clear();
}
