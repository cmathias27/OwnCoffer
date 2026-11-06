import '../device_auth.dart';

class _None implements DeviceAuth {
  @override
  Future<DeviceAuthKind> kind() async => DeviceAuthKind.none;

  @override
  Future<bool> authenticate(String reason) async => false;
}

DeviceAuth platformDeviceAuth() => _None();

Future<void> setWindowSecure(bool secure) async {}
