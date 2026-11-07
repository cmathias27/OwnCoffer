import '../client.dart';
import '../util/device_auth.dart';
import '../util/standalone_backups.dart';
import 'app_lock.dart';
import 'getting_started.dart';
import 'pepite.dart';

/// What only this device knows (screen unlock, backup, reminder), for
/// « Bien démarrer » and Pépite's badges (decision 0028).
Future<StartDevice> startDevice() async {
  final kind = await appLock.deviceKind();
  return StartDevice(
    deviceUnlock: kind == DeviceAuthKind.none
        ? null
        : appLock.enabled && (appLock.deviceUnlock || isStandalone),
    backup: isStandalone ? await StandaloneBackups.enabled : null,
    reminder: pepite.reminders.supported
        ? pepite.enabled && pepite.reminderOn
        : null,
  );
}

/// Marks the server accepts from this device (`PepiteBadges.deviceMarks`).
List<String> deviceMarks(StartDevice device) => [
  if (device.deviceUnlock == true) 'device_unlock',
  if (device.backup == true) 'backup',
];
