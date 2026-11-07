import 'package:owncoffer_client/owncoffer_client.dart';

/// A step of « Bien démarrer » (decision 0028, point 12).
class StartStep {
  final String code;
  final bool done;

  const StartStep(this.code, this.done);

  @override
  bool operator ==(Object other) =>
      other is StartStep && other.code == code && other.done == done;

  @override
  int get hashCode => Object.hash(code, done);

  @override
  String toString() => '$code${done ? '✓' : ''}';
}

/// What only the device knows; null: the step does not apply here.
class StartDevice {
  /// Fingerprint, face or Windows Hello unlock (apps with a screen lock).
  final bool? deviceUnlock;

  /// The encrypted backup of the standalone app.
  final bool? backup;

  /// The ritual reminder (apps that can notify).
  final bool? reminder;

  const StartDevice({this.deviceUnlock, this.backup, this.reminder});
}

/// The steps in the order of the decision; the server's that do not apply
/// (no second factor in the standalone app, no invitation for a member) are
/// not in [server].steps.
List<StartStep> startSteps(PepiteStart server, StartDevice device) {
  final done = server.done.toSet();
  StartStep? fromServer(String code) =>
      server.steps.contains(code) ? StartStep(code, done.contains(code)) : null;
  StartStep? fromDevice(String code, bool? value) =>
      value == null ? null : StartStep(code, value);
  return [
    ?fromServer('account'),
    ?fromServer('rules'),
    ?fromServer('scheduled'),
    ?fromServer('goal'),
    ?fromServer('two_factor'),
    ?fromDevice('device_unlock', device.deviceUnlock),
    ?fromDevice('backup', device.backup),
    ?fromServer('app'),
    ?fromDevice('reminder', device.reminder),
    ?fromServer('members'),
  ];
}

/// The server's list, for its administrator only.
List<StartStep> adminSteps(PepiteStart server) => [
  for (final code in server.adminSteps)
    StartStep(code, server.adminDone.contains(code)),
];
