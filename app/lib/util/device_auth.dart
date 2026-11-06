import 'device_auth/device_auth_stub.dart'
    if (dart.library.js_interop) 'device_auth/device_auth_web.dart'
    if (dart.library.io) 'device_auth/device_auth_io.dart'
    as impl;

/// How the device proves its owner is there (decision 0025).
enum DeviceAuthKind {
  /// None (web, Linux, or a device without a screen lock).
  none,

  /// Android: fingerprint, face, or the phone's PIN/pattern.
  android,

  /// Windows Hello: face, fingerprint or Windows PIN.
  windowsHello,
}

/// The device's own unlock (fingerprint, Windows Hello), used to unlock the
/// app. Only a yes or no: no key or password is kept for it.
abstract class DeviceAuth {
  /// What this device offers; [DeviceAuthKind.none] when nothing is set up.
  Future<DeviceAuthKind> kind();

  /// Asks the owner; true when they proved it is them.
  Future<bool> authenticate(String reason);

  static DeviceAuth platform() => impl.platformDeviceAuth();
}

/// Android only: keeps the app out of screenshots and blanks it in the list
/// of recent apps (FLAG_SECURE). Does nothing elsewhere.
Future<void> setWindowSecure(bool secure) => impl.setWindowSecure(secure);
