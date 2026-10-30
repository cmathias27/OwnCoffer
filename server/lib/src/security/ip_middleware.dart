import 'package:serverpod/serverpod.dart';

import 'client_ip.dart';
import 'ip_guard.dart';

/// Rejects requests from banned IPs (403) and limits the request rate per IP
/// (429) on the API server.
class IpRateLimiter {
  final int perMinute;
  final Map<String, ({int start, int count})> _windows = {};

  IpRateLimiter(this.perMinute);

  /// Fixed one-minute windows; [nowMs] for tests.
  bool allow(String ip, {int? nowMs}) {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final minute = now ~/ 60000;
    final w = _windows[ip];
    if (w == null || w.start != minute) {
      if (_windows.length > 50000) _windows.clear();
      _windows[ip] = (start: minute, count: 1);
      return true;
    }
    if (w.count >= perMinute) return false;
    _windows[ip] = (start: minute, count: w.count + 1);
    return true;
  }
}

Middleware ipProtection(IpGuard guard, IpRateLimiter limiter) {
  return (Handler next) {
    return (Request req) async {
      final ip = guard.resolver.resolve(
        req.connectionInfo.remote.address.toString(),
        req.headers[clientIpHeader]?.firstOrNull,
      );
      if (ip != null) {
        if (guard.isBanned(ip)) {
          return Response.forbidden(body: Body.fromString('ip_banned'));
        }
        if (!limiter.allow(ip)) {
          return Response(429, body: Body.fromString('rate_limited'));
        }
      }
      return next(req);
    };
  };
}
