import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

/// Keyed fingerprint of a bank account number: the number itself is never
/// stored. Keyed with the server secret, so a database dump alone cannot be
/// matched against guessed numbers.
String? bankAccountKey(String? accountNumber) {
  final n = accountNumber?.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  if (n == null || n.isEmpty || RegExp(r'^0+$').hasMatch(n)) return null;
  final secret =
      Serverpod.instance.getPassword('serviceSecret') ??
      (throw StateError('serviceSecret missing'));
  return Hmac(
    sha256,
    utf8.encode(secret),
  ).convert(utf8.encode('owncoffer-bank-account-v1:$n')).toString();
}
