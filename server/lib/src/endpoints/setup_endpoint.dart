import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';

/// First launch wizard (no login: no account exists yet).
class SetupEndpoint extends Endpoint {
  Future<SetupStatus> status(Session session) async =>
      SetupStatus(needsSetup: await Onboarding.needsSetup(session));

  /// Checks the setup code from the server log and allows [email] to
  /// register as server administrator (then: emailIdp.startRegistration).
  Future<void> start(Session session, String setupCode, String email) =>
      Onboarding.startSetup(session, setupCode, email);
}
