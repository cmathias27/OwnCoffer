import '../app_update.dart';

/// The web app is served by its server, always at its version.
AppUpdater platformUpdater() => const _NoUpdater();

class _NoUpdater implements AppUpdater {
  const _NoUpdater();

  @override
  bool get supported => false;

  @override
  String? get platform => null;

  @override
  bool get restarts => false;

  @override
  Future<String?> latest() async => null;

  @override
  Future<AppUpdateReady> prepare(
    String version, {
    AppUpdateProgress? progress,
  }) async => throw const AppUpdateException('unsupported');

  @override
  Future<void> install(AppUpdateReady ready) async =>
      throw const AppUpdateException('unsupported');

  @override
  Future<void> cleanup() async {}
}
