import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// Backups of the standalone app (decision 0022): the whole SQLite file and
/// the server's secrets, encrypted with a passphrase chosen by the user, so
/// that a copy in a cloud folder (Nextcloud, OneDrive…) reveals nothing and
/// can be restored on another device.
///
/// File layout (all integers big-endian):
///   "OCBK" · version (1 byte) · PBKDF2 iterations (4) · salt (16) ·
///   nonce (12) · AES-256-GCM ciphertext and tag
/// The header is authenticated with the content. The plain content is:
///   length (4) · metadata JSON · length (4) · passwords.yaml · database
abstract final class DeviceBackup {
  static const _magic = [0x4F, 0x43, 0x42, 0x4B]; // OCBK
  static const _version = 1;

  /// PBKDF2-HMAC-SHA256: a second or two on a phone, once a day.
  static const iterations = 210000;

  /// Shortest passphrase accepted.
  static const minPassphrase = 12;

  /// File extension of a backup.
  static const extension = 'ocbackup';

  static Uint8List _key(String passphrase, Uint8List salt, int rounds) {
    final kdf = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, rounds, 32));
    return kdf.process(Uint8List.fromList(utf8.encode(passphrase)));
  }

  static Uint8List _random(int n) {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(n, (_) => r.nextInt(256)));
  }

  /// Encrypts [database] (a consistent copy of the SQLite file) and
  /// [passwords] (config/passwords.yaml).
  static Uint8List seal({
    required String passphrase,
    required Uint8List database,
    required String passwords,
    required Map<String, Object?> metadata,
  }) {
    if (passphrase.length < minPassphrase) {
      throw ArgumentError('passphrase too short');
    }
    final salt = _random(16);
    final nonce = _random(12);
    final header = BytesBuilder()
      ..add(_magic)
      ..addByte(_version)
      ..add(_u32(iterations))
      ..add(salt)
      ..add(nonce);
    final head = header.toBytes();
    final meta = utf8.encode(jsonEncode(metadata));
    final secrets = utf8.encode(passwords);
    final plain =
        (BytesBuilder(copy: false)
              ..add(_u32(meta.length))
              ..add(meta)
              ..add(_u32(secrets.length))
              ..add(secrets)
              ..add(database))
            .toBytes();
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(_key(passphrase, salt, iterations)),
          128,
          nonce,
          head,
        ),
      );
    return (BytesBuilder(copy: false)
          ..add(head)
          ..add(cipher.process(plain)))
        .toBytes();
  }

  /// Decrypts a backup. Throws [FormatException] if it is not one, and
  /// [BackupPassphraseException] if the passphrase is wrong or the file
  /// was changed.
  static ({
    Map<String, Object?> metadata,
    String passwords,
    Uint8List database,
  })
  open(Uint8List file, String passphrase) {
    const headLength = 4 + 1 + 4 + 16 + 12;
    if (file.length < headLength + 16 ||
        !_startsWith(file, _magic) ||
        file[4] != _version) {
      throw const FormatException('Not an OwnCoffer backup');
    }
    final view = ByteData.sublistView(file);
    final rounds = view.getUint32(5);
    if (rounds < 10000 || rounds > 10000000) {
      throw const FormatException('Not an OwnCoffer backup');
    }
    final salt = Uint8List.sublistView(file, 9, 25);
    final nonce = Uint8List.sublistView(file, 25, 37);
    final head = Uint8List.sublistView(file, 0, headLength);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(_key(passphrase, salt, rounds)),
          128,
          nonce,
          head,
        ),
      );
    final Uint8List plain;
    try {
      plain = cipher.process(Uint8List.sublistView(file, headLength));
    } on InvalidCipherTextException {
      throw const BackupPassphraseException();
    }
    final p = ByteData.sublistView(plain);
    final metaLength = p.getUint32(0);
    final meta = utf8.decode(Uint8List.sublistView(plain, 4, 4 + metaLength));
    final at = 4 + metaLength;
    final secretsLength = p.getUint32(at);
    final secrets = utf8.decode(
      Uint8List.sublistView(plain, at + 4, at + 4 + secretsLength),
    );
    return (
      metadata: (jsonDecode(meta) as Map).cast<String, Object?>(),
      passwords: secrets,
      database: Uint8List.sublistView(plain, at + 4 + secretsLength),
    );
  }

  /// Writes a restored backup into [dataDir], replacing the database and
  /// the secrets. The embedded server must be stopped.
  static Future<void> restoreInto(
    Directory dataDir,
    Uint8List file,
    String passphrase,
  ) async {
    // The key derivation takes a second or two: off the app's thread.
    final b = await Isolate.run(() => open(file, passphrase));
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final f = File('${dataDir.path}/owncoffer.db$suffix');
      if (f.existsSync()) await f.delete();
    }
    await File(
      '${dataDir.path}/owncoffer.db',
    ).writeAsBytes(b.database, flush: true);
    final config = Directory('${dataDir.path}/config');
    await config.create(recursive: true);
    await File(
      '${config.path}/passwords.yaml',
    ).writeAsString(b.passwords, flush: true);
  }

  static Uint8List _u32(int v) =>
      Uint8List(4)..buffer.asByteData().setUint32(0, v);

  static bool _startsWith(Uint8List data, List<int> prefix) {
    for (var i = 0; i < prefix.length; i++) {
      if (data[i] != prefix[i]) return false;
    }
    return true;
  }
}

/// Wrong passphrase, or a changed file.
class BackupPassphraseException implements Exception {
  const BackupPassphraseException();
}
