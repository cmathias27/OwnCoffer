import 'dart:io';

import 'package:owncoffer_server/src/security/client_ip.dart';
import 'package:owncoffer_server/src/security/ip_middleware.dart';
import 'package:test/test.dart';

void main() {
  group('IpRange', () {
    bool inRange(String range, String ip) =>
        IpRange.tryParse(range)!.contains(InternetAddress(ip));

    test('IPv4 CIDR', () {
      expect(inRange('172.16.0.0/12', '172.18.0.5'), isTrue);
      expect(inRange('172.16.0.0/12', '172.32.0.1'), isFalse);
      expect(inRange('173.245.48.0/20', '173.245.63.255'), isTrue);
      expect(inRange('173.245.48.0/20', '173.245.64.0'), isFalse);
      expect(inRange('10.0.0.1', '10.0.0.1'), isTrue);
      expect(inRange('10.0.0.1', '10.0.0.2'), isFalse);
      expect(inRange('0.0.0.0/0', '8.8.8.8'), isTrue);
    });

    test('IPv6 CIDR and IPv4-mapped addresses', () {
      expect(inRange('2400:cb00::/32', '2400:cb00:1::1'), isTrue);
      expect(inRange('2400:cb00::/32', '2400:cb01::1'), isFalse);
      expect(inRange('172.16.0.0/12', '::ffff:172.18.0.5'), isTrue);
      expect(inRange('2400:cb00::/32', '172.18.0.5'), isFalse);
    });

    test('invalid ranges are ignored', () {
      expect(IpRange.tryParse('nope'), isNull);
      expect(IpRange.tryParse('10.0.0.0/33'), isNull);
      expect(parseRanges(' 10.0.0.0/8, bad  ::1/128 '), hasLength(2));
    });
  });

  group('ClientIpResolver', () {
    final resolver = ClientIpResolver.fromEnvironment(const {});

    test('trusts the forwarded IP only from the private proxy network', () {
      expect(resolver.resolve('172.18.0.3', '203.0.113.7'), '203.0.113.7');
      expect(
        resolver.resolve('::ffff:172.18.0.3', '2001:db8::7'),
        '2001:db8::7',
      );
    });

    test('ignores the header sent by anyone else (spoofing)', () {
      expect(resolver.resolve('198.51.100.9', '203.0.113.7'), '198.51.100.9');
    });

    test('falls back to the peer when the header is absent or invalid', () {
      expect(resolver.resolve('172.18.0.3', null), '172.18.0.3');
      expect(resolver.resolve('172.18.0.3', 'garbage'), '172.18.0.3');
      expect(resolver.resolve(null, '203.0.113.7'), isNull);
    });

    test('custom trusted proxies', () {
      final r = ClientIpResolver.fromEnvironment(const {
        'OWNCOFFER_TRUSTED_PROXIES': '192.0.2.10',
      });
      expect(r.resolve('172.18.0.3', '203.0.113.7'), '172.18.0.3');
      expect(r.resolve('192.0.2.10', '203.0.113.7'), '203.0.113.7');
    });
  });

  test('rate limiter: per IP, per minute', () {
    final limiter = IpRateLimiter(3);
    const t = 1000 * 60 * 1000;
    expect(
      [for (var i = 0; i < 4; i++) limiter.allow('a', nowMs: t)],
      [
        true,
        true,
        true,
        false,
      ],
    );
    expect(limiter.allow('b', nowMs: t), isTrue);
    expect(limiter.allow('a', nowMs: t + 60000), isTrue);
  });
}
