import 'package:serverpod/serverpod.dart';

/// Full access to group data. Granted at sign-in to users without two-factor
/// authentication, and only after a valid code to the others.
const accessScope = Scope('owncoffer.access');
