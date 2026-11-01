import 'package:flutter/foundation.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';

enum SessionStage { loading, setup, signedOut, needsTwoFactor, ready, error }

/// What the app shows: first launch, sign-in, two-factor code, or the app.
class SessionController extends ChangeNotifier {
  SessionStage stage = SessionStage.loading;
  List<GroupMembership> groups = [];
  int? currentGroupId;
  Object? lastError;

  /// A demonstration instance: fictitious data, said on every page.
  var demo = false;

  /// The server's version (1.0.3), compared with this app's.
  String? serverVersion;

  /// Token from an invitation link (`?invitation=…`), kept until accepted.
  String? pendingInvitation = Uri.base.queryParameters['invitation'];

  /// Shown once after an invitation was accepted.
  String? joinedGroupName;

  GroupMembership? get currentGroup =>
      groups.where((g) => g.group.id == currentGroupId).firstOrNull;

  SessionController() {
    client.auth.authInfoListenable.addListener(refresh);
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(refresh);
    super.dispose();
  }

  Future<void> refresh() async {
    try {
      final setup = await client.setup.status();
      demo = setup.demo ?? false;
      serverVersion = setup.serverVersion;
      if (setup.needsSetup) {
        _set(SessionStage.setup);
        return;
      }
      if (!client.auth.isAuthenticated) {
        _set(SessionStage.signedOut);
        return;
      }
      final status = await client.twoFactor.status();
      if (!status.fullAccess) {
        _set(SessionStage.needsTwoFactor);
        return;
      }
      await _acceptPendingInvitation();
      await reloadGroups();
      _set(SessionStage.ready);
    } on ServerpodClientUnauthorized {
      await client.auth.signOutDevice();
      _set(SessionStage.signedOut);
    } on Object catch (e) {
      lastError = e;
      _set(SessionStage.error);
    }
  }

  Future<void> reloadGroups() async {
    groups = await client.group.myGroups();
    if (currentGroup == null) currentGroupId = groups.firstOrNull?.group.id;
    notifyListeners();
  }

  Future<void> _acceptPendingInvitation() async {
    final token = pendingInvitation;
    if (token == null) return;
    pendingInvitation = null;
    try {
      final m = await client.invitation.accept(token);
      joinedGroupName = m.group.name;
      currentGroupId = m.group.id;
    } on InvalidInputException {
      // Already used when the account was created with it: nothing to do.
    }
  }

  void selectGroup(int id) {
    currentGroupId = id;
    notifyListeners();
  }

  Future<void> signedIn(AuthSuccess success) async {
    await client.auth.updateSignedInUser(success);
    await refresh();
  }

  Future<void> signOut() async {
    await client.auth.signOutDevice();
    groups = [];
    currentGroupId = null;
    _set(SessionStage.signedOut);
  }

  void _set(SessionStage s) {
    stage = s;
    notifyListeners();
  }
}
