import 'dart:convert';

import 'package:owncoffer_server/src/security/secret_box.dart';
import 'package:owncoffer_server/src/security/totp.dart';
import 'package:test/test.dart';

void main() {
  group('RFC 6238 test vectors (SHA-1, 8 digits)', () {
    final secret = utf8.encode('12345678901234567890');
    final vectors = {
      59: '94287082',
      1111111109: '07081804',
      1111111111: '14050471',
      1234567890: '89005924',
      2000000000: '69279037',
      20000000000: '65353130',
    };
    vectors.forEach((seconds, code) {
      test('t=$seconds', () {
        final t = DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000,
          isUtc: true,
        );
        expect(Totp.codeAt(secret, t, length: 8), code);
      });
    });
  });

  test('base32 round trip and RFC 4648 example', () {
    expect(Totp.base32Encode(utf8.encode('foobar')), 'MZXW6YTBOI');
    expect(utf8.decode(Totp.base32Decode('mzxw 6ytb oi==')), 'foobar');
    final s = Totp.newSecret();
    expect(Totp.base32Decode(Totp.base32Encode(s)), s);
  });

  test('verify: ±1 step, once only, rejects garbage', () {
    final secret = Totp.newSecret();
    final now = DateTime.utc(2026, 10, 30, 12);
    final code = Totp.codeAt(secret, now);
    final step = Totp.verify(secret, code, now);
    expect(step, Totp.stepAt(now));
    expect(
      Totp.verify(secret, code, now.add(const Duration(seconds: 30))),
      step,
      reason: 'previous step still accepted',
    );
    expect(
      Totp.verify(secret, code, now.add(const Duration(seconds: 90))),
      isNull,
    );
    expect(Totp.verify(secret, code, now, lastUsedStep: step), isNull);
    expect(Totp.verify(secret, '12345', now), isNull);
    expect(Totp.verify(secret, 'abcdef', now), isNull);
  });

  test('otpauth URI', () {
    expect(
      Totp.otpauthUri('ABC', 'a@example.org'),
      'otpauth://totp/OwnCoffer%3Aa%40example.org?secret=ABC&issuer=OwnCoffer'
      '&algorithm=SHA1&digits=6&period=30',
    );
  });

  test('secret box: round trip, tamper detection, key separation', () {
    final box = SecretBox.derive('server-secret', 'purpose-a');
    final sealed = box.encrypt([1, 2, 3]);
    expect(box.decrypt(sealed), [1, 2, 3]);
    expect(box.encrypt([1, 2, 3]), isNot(sealed), reason: 'random nonce');
    final parts = sealed.split('.');
    final bytes = base64Decode(parts[2])..[0] ^= 1;
    expect(
      () => box.decrypt('${parts[0]}.${parts[1]}.${base64Encode(bytes)}'),
      throwsA(anything),
    );
    expect(
      () => SecretBox.derive('server-secret', 'purpose-b').decrypt(sealed),
      throwsA(anything),
    );
  });
}
