import 'package:serverpod/serverpod.dart';

import '../demo/demo_seed.dart';
import 'admin_endpoint.dart';
import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/ip_guard.dart';

/// First launch wizard (no login: no account exists yet).
class SetupEndpoint extends Endpoint {
  Future<SetupStatus> status(Session session) async => SetupStatus(
    needsSetup: await Onboarding.needsSetup(session),
    demo: DemoSeed.enabled,
    serverVersion: AdminEndpoint.serverVersion(),
  );

  /// Checks the setup code from the server log and allows [email] to
  /// register as server administrator (then: emailIdp.startRegistration).
  Future<void> start(Session session, String setupCode, String email) async {
    try {
      await Onboarding.startSetup(session, setupCode, email);
    } on InvalidInputException catch (e) {
      if (e.code == 'setup_code_invalid') {
        await IpGuard.instance.recordFailure(session, 'setup_code');
      }
      rethrow;
    }
  }
}
