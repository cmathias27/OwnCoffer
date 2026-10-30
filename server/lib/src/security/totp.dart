import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Time-based one-time passwords (RFC 6238, HMAC-SHA1, 30 s, 6 digits) —
/// what authenticator apps (Aegis, FreeOTP, Google Authenticator…) use.
abstract final class Totp {
  static const period = 30;
  static const digits = 6;

  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  static Uint8List newSecret() {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(20, (_) => r.nextInt(256)));
  }

  static String base32Encode(List<int> bytes) {
    final out = StringBuffer();
    var buffer = 0, bits = 0;
    for (final b in bytes) {
      buffer = (buffer << 8) | b;
      bits += 8;
      while (bits >= 5) {
        out.write(_alphabet[(buffer >> (bits - 5)) & 31]);
        bits -= 5;
      }
    }
    if (bits > 0) out.write(_alphabet[(buffer << (5 - bits)) & 31]);
    return out.toString();
  }

  static Uint8List base32Decode(String text) {
    final clean = text.toUpperCase().replaceAll(RegExp(r'[\s=-]'), '');
    final out = <int>[];
    var buffer = 0, bits = 0;
    for (final ch in clean.split('')) {
      final v = _alphabet.indexOf(ch);
      if (v < 0) throw FormatException('Invalid base32', text);
      buffer = (buffer << 5) | v;
      bits += 5;
      if (bits >= 8) {
        out.add((buffer >> (bits - 8)) & 0xFF);
        bits -= 8;
      }
    }
    return Uint8List.fromList(out);
  }

  /// HOTP value (RFC 4226) for [counter], with [length] digits.
  static String hotp(List<int> secret, int counter, {int length = digits}) {
    final msg = ByteData(8)
      ..setUint32(0, counter ~/ 0x100000000)
      ..setUint32(4, counter % 0x100000000);
    final h = Hmac(sha1, secret).convert(msg.buffer.asUint8List()).bytes;
    final offset = h[h.length - 1] & 0x0F;
    final binary =
        ((h[offset] & 0x7F) << 24) |
        (h[offset + 1] << 16) |
        (h[offset + 2] << 8) |
        h[offset + 3];
    var mod = 1;
    for (var i = 0; i < length; i++) {
      mod *= 10;
    }
    return (binary % mod).toString().padLeft(length, '0');
  }

  static int stepAt(DateTime time) =>
      time.millisecondsSinceEpoch ~/ 1000 ~/ period;

  static String codeAt(
    List<int> secret,
    DateTime time, {
    int length = digits,
  }) => hotp(secret, stepAt(time), length: length);

  /// The time step matched by [code] (current step ± [window]), or null.
  /// Steps at or before [lastUsedStep] are refused: a code works only once.
  static int? verify(
    List<int> secret,
    String code,
    DateTime now, {
    int window = 1,
    int? lastUsedStep,
  }) {
    final c = code.replaceAll(RegExp(r'\s'), '');
    if (c.length != digits || int.tryParse(c) == null) return null;
    final step = stepAt(now);
    for (var s = step - window; s <= step + window; s++) {
      if (lastUsedStep != null && s <= lastUsedStep) continue;
      if (_equals(hotp(secret, s), c)) return s;
    }
    return null;
  }

  static bool _equals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }

  /// URI read by authenticator apps (shown as a QR code).
  static String otpauthUri(String secretBase32, String account) {
    final label = Uri.encodeComponent('OwnCoffer:$account');
    return 'otpauth://totp/$label?secret=$secretBase32&issuer=OwnCoffer'
        '&algorithm=SHA1&digits=$digits&period=$period';
  }
}
