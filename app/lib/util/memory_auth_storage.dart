import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// A session kept in memory only: the second server reached while moving
/// data (decision 0022), never stored on the device.
class MemoryAuthStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _value;

  @override
  Future<AuthSuccess?> get() async => _value;

  @override
  Future<void> set(AuthSuccess? data) async => _value = data;
}
