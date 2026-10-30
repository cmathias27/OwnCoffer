import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

/// Encrypts small secrets at rest (TOTP secrets) with AES-256-GCM. The key is
/// derived from a server secret of docker/.env, so a database dump alone does
/// not reveal them.
class SecretBox {
  final Uint8List _key;

  SecretBox._(this._key);

  /// [serverSecret]: e.g. the Serverpod service secret; [purpose] separates
  /// keys used for different things.
  factory SecretBox.derive(String serverSecret, String purpose) => SecretBox._(
    Uint8List.fromList(
      Hmac(
        sha256,
        utf8.encode(serverSecret),
      ).convert(utf8.encode(purpose)).bytes,
    ),
  );

  /// `v1.<base64 nonce>.<base64 ciphertext+tag>`
  String encrypt(List<int> plain) {
    final r = Random.secure();
    final nonce = Uint8List.fromList(List.generate(12, (_) => r.nextInt(256)));
    final cipher = GCMBlockCipher(
      AESEngine(),
    )..init(true, AEADParameters(KeyParameter(_key), 128, nonce, Uint8List(0)));
    final out = cipher.process(Uint8List.fromList(plain));
    return 'v1.${base64Encode(nonce)}.${base64Encode(out)}';
  }

  Uint8List decrypt(String box) {
    final parts = box.split('.');
    if (parts.length != 3 || parts[0] != 'v1') {
      throw const FormatException('Unknown secret box format');
    }
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(_key),
          128,
          base64Decode(parts[1]),
          Uint8List(0),
        ),
      );
    // Throws InvalidCipherTextException if the box was tampered with.
    return cipher.process(base64Decode(parts[2]));
  }
}
