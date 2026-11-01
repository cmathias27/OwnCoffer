import 'endpoints/admin_endpoint.dart';
import 'endpoints/category_endpoint.dart';
import 'finance/alert_service.dart';
import 'generated/serverpod.dart';
import 'onboarding/onboarding.dart';
import 'security/ip_guard.dart';

/// What every OwnCoffer server does once started: the Docker one and the
/// one embedded in the standalone apps (decision 0022).
Future<void> afterStart(Serverpod pod, {required bool announceSetup}) async {
  AdminEndpoint.startedAt = DateTime.now().toUtc();

  // First launch: print the one-time setup code while no account exists.
  // Active IP bans are loaded so they survive a restart.
  final session = await pod.createSession(enableLogging: true);
  try {
    if (announceSetup) await Onboarding.announceSetupIfNeeded(session);
    await IpGuard.instance.load(session);
    // New standard categories reach the existing groups.
    await updateAllStandardCategories(session);
  } finally {
    await session.close();
  }

  // Overdraft alerts: hourly check of every account's forecast.
  AlertService.start(pod);
}
