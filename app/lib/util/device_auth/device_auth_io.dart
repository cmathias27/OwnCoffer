import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../device_auth.dart';

class _LocalAuth implements DeviceAuth {
  final _auth = LocalAuthentication();

  @override
  Future<DeviceAuthKind> kind() async {
    final DeviceAuthKind kind;
    if (Platform.isAndroid) {
      kind = DeviceAuthKind.android;
    } else if (Platform.isWindows) {
      kind = DeviceAuthKind.windowsHello;
    } else {
      return DeviceAuthKind.none;
    }
    try {
      return await _auth.isDeviceSupported() ? kind : DeviceAuthKind.none;
    } on Object catch (e) {
      debugPrint('Device unlock unavailable: $e');
      return DeviceAuthKind.none;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      // Not biometrics only: the phone's PIN or the Windows PIN also prove
      // it is the device's owner (decision 0025).
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on Object catch (e) {
      debugPrint('Device unlock failed: $e');
      return false;
    }
  }
}

DeviceAuth platformDeviceAuth() => _LocalAuth();

const _window = MethodChannel('org.owncoffer.app/window');

Future<void> setWindowSecure(bool secure) async {
  if (!Platform.isAndroid) return;
  try {
    await _window.invokeMethod<void>('setSecure', {'secure': secure});
  } on MissingPluginException {
    // Tests and older builds: nothing to do.
  }
}
