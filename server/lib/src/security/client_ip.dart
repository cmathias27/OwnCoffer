import 'dart:io';
import 'dart:typed_data';

/// A CIDR range (`10.0.0.0/8`, `2400:cb00::/32`, or a single address).
class IpRange {
  final Uint8List _network;
  final int _prefix;

  IpRange._(this._network, this._prefix);

  static IpRange? tryParse(String text) {
    final parts = text.trim().split('/');
    final address = InternetAddress.tryParse(parts[0]);
    if (address == null) return null;
    final bits = address.rawAddress.length * 8;
    final prefix = parts.length > 1 ? int.tryParse(parts[1]) : bits;
    if (prefix == null || prefix < 0 || prefix > bits) return null;
    return IpRange._(address.rawAddress, prefix);
  }

  bool contains(InternetAddress address) {
    var raw = address.rawAddress;
    // IPv4-mapped IPv6 (::ffff:a.b.c.d) compares as IPv4.
    if (raw.length == 16 && _network.length == 4 && _isV4Mapped(raw)) {
      raw = Uint8List.sublistView(raw, 12);
    }
    if (raw.length != _network.length) return false;
    var bits = _prefix;
    for (var i = 0; i < raw.length && bits > 0; i++, bits -= 8) {
      final mask = bits >= 8 ? 0xFF : (0xFF << (8 - bits)) & 0xFF;
      if ((raw[i] & mask) != (_network[i] & mask)) return false;
    }
    return true;
  }

  static bool _isV4Mapped(Uint8List raw) {
    for (var i = 0; i < 10; i++) {
      if (raw[i] != 0) return false;
    }
    return raw[10] == 0xFF && raw[11] == 0xFF;
  }
}

List<IpRange> parseRanges(String? text) => [
  for (final part in (text ?? '').split(RegExp(r'[\s,]+')))
    if (part.isNotEmpty) ?IpRange.tryParse(part),
];

bool inRanges(List<IpRange> ranges, InternetAddress address) =>
    ranges.any((r) => r.contains(address));

/// Header set by the OwnCoffer proxy (Caddy) with the real client IP. Caddy
/// overwrites any value sent by the client.
const clientIpHeader = 'x-owncoffer-client-ip';

/// Resolves the real client IP (decisions 0012 and 0015).
///
/// The forwarded header is only trusted when the TCP peer is the OwnCoffer
/// proxy, i.e. an address in [trustedProxies] (by default the private Docker
/// network). Caddy itself only reads `CF-Connecting-IP` when the request comes
/// from Cloudflare or the local connector.
class ClientIpResolver {
  final List<IpRange> trustedProxies;

  ClientIpResolver(this.trustedProxies);

  factory ClientIpResolver.fromEnvironment(Map<String, String> env) =>
      ClientIpResolver(
        parseRanges(
          env['OWNCOFFER_TRUSTED_PROXIES'] ??
              '127.0.0.0/8 ::1/128 172.16.0.0/12 10.0.0.0/8 fd00::/8',
        ),
      );

  /// [peer]: TCP remote address; [forwarded]: value of [clientIpHeader].
  String? resolve(String? peer, String? forwarded) {
    final peerAddress = peer == null ? null : _parse(peer);
    if (peerAddress == null) return null;
    if (forwarded != null && inRanges(trustedProxies, peerAddress)) {
      final client = _parse(forwarded.split(',').first.trim());
      if (client != null) return _canonical(client);
    }
    return _canonical(peerAddress);
  }

  static InternetAddress? _parse(String text) {
    var t = text.trim();
    if (t.startsWith('[') && t.contains(']')) {
      t = t.substring(1, t.indexOf(']'));
    }
    return InternetAddress.tryParse(t);
  }

  static String _canonical(InternetAddress a) {
    final raw = a.rawAddress;
    if (raw.length == 16 && IpRange._isV4Mapped(raw)) {
      return raw.sublist(12).join('.');
    }
    return a.address;
  }
}
