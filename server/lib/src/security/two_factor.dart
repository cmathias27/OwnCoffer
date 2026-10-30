import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'scopes.dart';
import 'secret_box.dart';
import 'totp.dart';

/// Two-factor authentication (TOTP + backup codes).
///
/// How it is enforced: data endpoints require [accessScope]. A user without
/// 2FA has this scope on their account, so the password sign-in grants it.
/// When 2FA is enabled, the scope is removed from the account: the password
/// sign-in then gives a partial token, exchanged for a full one only with a
/// valid code (TwoFactorEndpoint.verify).
abstract final class TwoFactor {
  static const backupCodeCount = 10;
  static const _codeAlphabet = 'abcdefghjkmnpqrstuvwxyz23456789';

  static String _serverSecret() =>
      Serverpod.instance.getPassword('serviceSecret') ??
      (throw StateError('serviceSecret missing: needed for 2FA'));

  static SecretBox get _box =>
      SecretBox.derive(_serverSecret(), 'owncoffer-totp-secret-v1');

  static String _hashBackup(String code) => Hmac(
    sha256,
    utf8.encode(_serverSecret()),
  ).convert(utf8.encode('backup:${normalizeBackup(code)}')).toString();

  static String normalizeBackup(String code) =>
      code.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  static Future<TotpSecret?> _secret(Session session, UuidValue user) =>
      TotpSecret.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(user),
      );

  static Future<bool> isEnabled(Session session, UuidValue user) async =>
      (await _secret(session, user))?.enabled ?? false;

  /// Starts enrolment: a new secret, not active until confirmed.
  static Future<TotpEnrollment> begin(
    Session session,
    UuidValue user,
    String accountLabel,
  ) async {
    final existing = await _secret(session, user);
    if (existing != null && existing.enabled) {
      throw InvalidInputException(code: 'two_factor_already_enabled');
    }
    final secret = Totp.newSecret();
    final row = TotpSecret(authUserId: user, secretBox: _box.encrypt(secret));
    if (existing == null) {
      await TotpSecret.db.insertRow(session, row);
    } else {
      await TotpSecret.db.updateRow(
        session,
        existing.copyWith(secretBox: row.secretBox, lastUsedStep: null),
      );
    }
    final b32 = Totp.base32Encode(secret);
    return TotpEnrollment(
      secret: b32,
      otpauthUri: Totp.otpauthUri(b32, accountLabel),
    );
  }

  /// Checks a TOTP code (or, if [allowBackup], a backup code) and consumes it.
  static Future<bool> check(
    Session session,
    UuidValue user,
    String code, {
    bool allowBackup = true,
    bool requireEnabled = true,
    DateTime? now,
  }) async {
    final row = await _secret(session, user);
    if (row == null || (requireEnabled && !row.enabled)) return false;
    final step = Totp.verify(
      _box.decrypt(row.secretBox),
      code,
      now ?? DateTime.now(),
      lastUsedStep: row.lastUsedStep,
    );
    if (step != null) {
      await TotpSecret.db.updateRow(session, row.copyWith(lastUsedStep: step));
      return true;
    }
    if (!allowBackup || !row.enabled) return false;
    final hash = _hashBackup(code);
    final backup = await BackupCode.db.findFirstRow(
      session,
      where: (b) =>
          b.authUserId.equals(user) &
          b.codeHash.equals(hash) &
          b.usedAt.equals(null),
    );
    if (backup == null) return false;
    await BackupCode.db.updateRow(
      session,
      backup.copyWith(usedAt: DateTime.now().toUtc()),
    );
    return true;
  }

  /// Confirms enrolment with a first code; returns the backup codes (shown
  /// once). The account loses [accessScope]: next sign-ins need a code.
  static Future<List<String>> confirm(
    Session session,
    UuidValue user,
    String code, {
    DateTime? now,
  }) async {
    final row = await _secret(session, user);
    if (row == null || row.enabled) {
      throw InvalidInputException(code: 'two_factor_not_started');
    }
    if (!await check(
      session,
      user,
      code,
      allowBackup: false,
      requireEnabled: false,
      now: now,
    )) {
      return const [];
    }
    final fresh = (await _secret(session, user))!;
    await TotpSecret.db.updateRow(
      session,
      fresh.copyWith(enabled: true, enabledAt: DateTime.now().toUtc()),
    );
    await _setAccessOnAccount(session, user, false);
    return newBackupCodes(session, user);
  }

  static Future<List<String>> newBackupCodes(
    Session session,
    UuidValue user,
  ) async {
    await BackupCode.db.deleteWhere(
      session,
      where: (b) => b.authUserId.equals(user),
    );
    final r = Random.secure();
    final codes = [
      for (var i = 0; i < backupCodeCount; i++)
        [
          for (var j = 0; j < 8; j++)
            _codeAlphabet[r.nextInt(_codeAlphabet.length)],
        ].join().replaceRange(4, 4, '-'),
    ];
    await BackupCode.db.insert(session, [
      for (final c in codes)
        BackupCode(authUserId: user, codeHash: _hashBackup(c)),
    ]);
    return codes;
  }

  static Future<int> backupCodesLeft(Session session, UuidValue user) =>
      BackupCode.db.count(
        session,
        where: (b) => b.authUserId.equals(user) & b.usedAt.equals(null),
      );

  /// Turns 2FA off and gives the account its full access back.
  static Future<void> disable(Session session, UuidValue user) async {
    await TotpSecret.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(user),
    );
    await BackupCode.db.deleteWhere(
      session,
      where: (b) => b.authUserId.equals(user),
    );
    await _setAccessOnAccount(session, user, true);
  }

  static Future<void> _setAccessOnAccount(
    Session session,
    UuidValue user,
    bool granted,
  ) async {
    final account = (await AuthUser.db.findById(session, user))!;
    final scopes = {...account.scopeNames};
    if (granted) {
      scopes.add(accessScope.name!);
    } else {
      scopes.remove(accessScope.name!);
    }
    await AuthUser.db.updateRow(session, account.copyWith(scopeNames: scopes));
  }

  /// Gives a new account its full access (no 2FA yet).
  static Future<void> grantAccessToNewAccount(
    Session session,
    UuidValue user, {
    Transaction? transaction,
  }) async {
    final account = (await AuthUser.db.findById(
      session,
      user,
      transaction: transaction,
    ))!;
    await AuthUser.db.updateRow(
      session,
      account.copyWith(scopeNames: {...account.scopeNames, accessScope.name!}),
      transaction: transaction,
    );
  }
}
