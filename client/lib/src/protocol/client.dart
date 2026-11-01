/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:owncoffer_client/src/protocol/account.dart' as _i4motmly;
import 'package:owncoffer_client/src/protocol/account_kind.dart' as _ighjli9i;
import 'package:owncoffer_client/src/protocol/account_visibility.dart'
    as _i33sijhq;
import 'package:owncoffer_client/src/protocol/action_proposal.dart'
    as _ihgp0l1x;
import 'package:owncoffer_client/src/protocol/admin_audit_info.dart'
    as _icr6cafh;
import 'package:owncoffer_client/src/protocol/admin_group_info.dart'
    as _iq49mcaz;
import 'package:owncoffer_client/src/protocol/admin_health.dart' as _in646bd3;
import 'package:owncoffer_client/src/protocol/admin_invitation_info.dart'
    as _idjaxr3o;
import 'package:owncoffer_client/src/protocol/admin_stats.dart' as _ip1w2kia;
import 'package:owncoffer_client/src/protocol/admin_user_info.dart'
    as _i4kcqb5h;
import 'package:owncoffer_client/src/protocol/ai_conversation.dart'
    as _i3twyez0;
import 'package:owncoffer_client/src/protocol/ai_memory.dart' as _iofw4ha7;
import 'package:owncoffer_client/src/protocol/ai_message.dart' as _iarsdlqt;
import 'package:owncoffer_client/src/protocol/ai_provider.dart' as _iupqajx2;
import 'package:owncoffer_client/src/protocol/ai_reply.dart' as _i6gcixlb;
import 'package:owncoffer_client/src/protocol/ai_status.dart' as _if0b0k6p;
import 'package:owncoffer_client/src/protocol/backup_overview.dart'
    as _il220tje;
import 'package:owncoffer_client/src/protocol/balance_check.dart' as _ifxnt0qj;
import 'package:owncoffer_client/src/protocol/bank_transaction.dart'
    as _ivksw0b3;
import 'package:owncoffer_client/src/protocol/budget_period.dart' as _iff4p9sd;
import 'package:owncoffer_client/src/protocol/category.dart' as _i37qqsjr;
import 'package:owncoffer_client/src/protocol/category_kind.dart' as _ig2tt18e;
import 'package:owncoffer_client/src/protocol/category_source.dart'
    as _i8y5k73o;
import 'package:owncoffer_client/src/protocol/csv_columns.dart' as _irbioy6y;
import 'package:owncoffer_client/src/protocol/due_calendar.dart' as _i25nl2kq;
import 'package:owncoffer_client/src/protocol/early_repayment.dart'
    as _i0heeame;
import 'package:owncoffer_client/src/protocol/feedback_info.dart' as _i6glypql;
import 'package:owncoffer_client/src/protocol/finance_group.dart' as _izr9v441;
import 'package:owncoffer_client/src/protocol/forecast_result.dart'
    as _ip0wp7v2;
import 'package:owncoffer_client/src/protocol/frequency.dart' as _i1mv9fwy;
import 'package:owncoffer_client/src/protocol/goal.dart' as _ita8uvsc;
import 'package:owncoffer_client/src/protocol/group_member.dart' as _il25bams;
import 'package:owncoffer_client/src/protocol/group_membership.dart'
    as _itelwlzo;
import 'package:owncoffer_client/src/protocol/import_preview.dart' as _ikjuebnd;
import 'package:owncoffer_client/src/protocol/import_result.dart' as _i4a7ax0k;
import 'package:owncoffer_client/src/protocol/insights.dart' as _iocgvawp;
import 'package:owncoffer_client/src/protocol/instalment_candidate.dart'
    as _io211e4m;
import 'package:owncoffer_client/src/protocol/invitation_info.dart'
    as _i2judacm;
import 'package:owncoffer_client/src/protocol/invoice_info.dart' as _iej1c1us;
import 'package:owncoffer_client/src/protocol/invoice_match.dart' as _ikyjg3a9;
import 'package:owncoffer_client/src/protocol/ip_ban_info.dart' as _ivw6xhv3;
import 'package:owncoffer_client/src/protocol/left_to_live_report.dart'
    as _iqfjeddm;
import 'package:owncoffer_client/src/protocol/loan.dart' as _ig538h6x;
import 'package:owncoffer_client/src/protocol/loan_change_simulation.dart'
    as _in49arm1;
import 'package:owncoffer_client/src/protocol/loan_document.dart' as _ixzu9i3x;
import 'package:owncoffer_client/src/protocol/loan_event.dart' as _iz3v8osk;
import 'package:owncoffer_client/src/protocol/loan_from_operation.dart'
    as _i04nbqtd;
import 'package:owncoffer_client/src/protocol/loan_info.dart' as _iwrqx7d4;
import 'package:owncoffer_client/src/protocol/loan_installment.dart'
    as _i18weoko;
import 'package:owncoffer_client/src/protocol/loan_overview.dart' as _i1y07bmb;
import 'package:owncoffer_client/src/protocol/mcp_token.dart' as _ioxkfsho;
import 'package:owncoffer_client/src/protocol/mcp_token_created.dart'
    as _i9n2kr6t;
import 'package:owncoffer_client/src/protocol/member_info.dart' as _igteyn7f;
import 'package:owncoffer_client/src/protocol/member_role.dart' as _ibbiwcdo;
import 'package:owncoffer_client/src/protocol/month_review.dart' as _ilg6npsn;
import 'package:owncoffer_client/src/protocol/notification.dart' as _igwx4n0s;
import 'package:owncoffer_client/src/protocol/notification_settings.dart'
    as _inuj1ggb;
import 'package:owncoffer_client/src/protocol/provider_history.dart'
    as _i26z4phw;
import 'package:owncoffer_client/src/protocol/purchase_simulation.dart'
    as _is7p90bk;
import 'package:owncoffer_client/src/protocol/rule.dart' as _i0jtaw5e;
import 'package:owncoffer_client/src/protocol/rule_application.dart'
    as _i0d2e7ql;
import 'package:owncoffer_client/src/protocol/rule_direction.dart' as _idnlspx6;
import 'package:owncoffer_client/src/protocol/rule_match_type.dart'
    as _iko98d6o;
import 'package:owncoffer_client/src/protocol/rule_test_result.dart'
    as _ilhr3r4a;
import 'package:owncoffer_client/src/protocol/scheduled_transaction.dart'
    as _ibpr6881;
import 'package:owncoffer_client/src/protocol/setup_status.dart' as _iayy8tg9;
import 'package:owncoffer_client/src/protocol/spending_report.dart'
    as _isyymxi6;
import 'package:owncoffer_client/src/protocol/statement_import.dart'
    as _i5x9swls;
import 'package:owncoffer_client/src/protocol/subscription_overview.dart'
    as _i0jm8pub;
import 'package:owncoffer_client/src/protocol/totp_enrollment.dart'
    as _iy6m3xur;
import 'package:owncoffer_client/src/protocol/transaction_page.dart'
    as _ioa38wkb;
import 'package:owncoffer_client/src/protocol/transaction_split.dart'
    as _idy91hap;
import 'package:owncoffer_client/src/protocol/two_factor_status.dart'
    as _is1jzs1l;
import 'package:owncoffer_client/src/protocol/update_overview.dart'
    as _ighiaz9s;
import 'package:owncoffer_client/src/protocol/user_feedback.dart' as _i081ti63;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Email sign-in. Registration is closed except for emails with a pending
/// invitation (or the first launch setup). Every failed attempt counts
/// towards the automatic IP ban.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Serverpod reads the account scopes before our account-creation hook has
  /// granted full access (no 2FA yet), so the first token would be partial:
  /// it is replaced by a token with the account's final scopes.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Bank accounts of a group. Only the fields below can be set by the client;
/// group, ids and dates always come from the server.
/// {@category Endpoint}
class EndpointAccount extends _isc.EndpointRef {
  EndpointAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'account';

  _ida.Future<List<_i4motmly.Account>> list(int groupId) =>
      caller.callServerEndpoint<List<_i4motmly.Account>>(
        'account',
        'list',
        {'groupId': groupId},
      );

  _ida.Future<_i4motmly.Account> create(
    int groupId,
    String name,
    _ighjli9i.AccountKind kind, {
    String? bank,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _i33sijhq.AccountVisibility? visibility,
  }) => caller.callServerEndpoint<_i4motmly.Account>(
    'account',
    'create',
    {
      'groupId': groupId,
      'name': name,
      'kind': kind,
      'bank': bank,
      'initialBalanceCents': initialBalanceCents,
      'initialBalanceDate': initialBalanceDate,
      'alertThresholdCents': alertThresholdCents,
      'visibility': visibility,
    },
  );

  _ida.Future<_i4motmly.Account> update(
    int accountId, {
    String? name,
    String? bank,
    int? initialBalanceCents,
    DateTime? initialBalanceDate,
    int? alertThresholdCents,
    _i33sijhq.AccountVisibility? visibility,
    String? color,
  }) => caller.callServerEndpoint<_i4motmly.Account>(
    'account',
    'update',
    {
      'accountId': accountId,
      'name': name,
      'bank': bank,
      'initialBalanceCents': initialBalanceCents,
      'initialBalanceDate': initialBalanceDate,
      'alertThresholdCents': alertThresholdCents,
      'visibility': visibility,
      'color': color,
    },
  );

  /// Moves the account to the trash (kept 30 days).
  _ida.Future<void> archive(int accountId) => caller.callServerEndpoint<void>(
    'account',
    'archive',
    {'accountId': accountId},
  );

  /// Gives or removes access to a restricted account (admins).
  _ida.Future<void> setAccess(
    int accountId,
    _isc.UuidValue userId,
    bool allowed,
  ) => caller.callServerEndpoint<void>(
    'account',
    'setAccess',
    {
      'accountId': accountId,
      'userId': userId,
      'allowed': allowed,
    },
  );

  /// Balance check: the balance the bank shows at the end of [date],
  /// compared with the one computed from the operations. Saved, so the last
  /// checks can be seen again.
  _ida.Future<_ifxnt0qj.BalanceCheck> checkBalance(
    int accountId,
    DateTime date,
    int bankBalanceCents,
  ) => caller.callServerEndpoint<_ifxnt0qj.BalanceCheck>(
    'account',
    'checkBalance',
    {
      'accountId': accountId,
      'date': date,
      'bankBalanceCents': bankBalanceCents,
    },
  );

  /// The last balance checks of the account, newest first.
  _ida.Future<List<_ifxnt0qj.BalanceCheck>> balanceChecks(int accountId) =>
      caller.callServerEndpoint<List<_ifxnt0qj.BalanceCheck>>(
        'account',
        'balanceChecks',
        {'accountId': accountId},
      );
}

/// Server administration (server administrator only): accounts, health,
/// figures, audit log, banned IPs. Nothing here shows a group's financial
/// data: figures are counts, never amounts.
/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// Whether the signed-in user may open the administration page.
  _ida.Future<bool> isServerAdmin() => caller.callServerEndpoint<bool>(
    'admin',
    'isServerAdmin',
    {},
  );

  _ida.Future<List<_ivw6xhv3.IpBanInfo>> bannedIps() =>
      caller.callServerEndpoint<List<_ivw6xhv3.IpBanInfo>>(
        'admin',
        'bannedIps',
        {},
      );

  _ida.Future<void> unbanIp(String ip) => caller.callServerEndpoint<void>(
    'admin',
    'unbanIp',
    {'ip': ip},
  );

  /// Every account of the server, oldest first.
  _ida.Future<List<_i4kcqb5h.AdminUserInfo>> users() =>
      caller.callServerEndpoint<List<_i4kcqb5h.AdminUserInfo>>(
        'admin',
        'users',
        {},
      );

  /// Blocks (or unblocks) an account. A blocked account is signed out
  /// everywhere and cannot sign in. The administrator cannot block himself.
  _ida.Future<void> setBlocked(
    _isc.UuidValue authUserId,
    bool blocked,
  ) => caller.callServerEndpoint<void>(
    'admin',
    'setBlocked',
    {
      'authUserId': authUserId,
      'blocked': blocked,
    },
  );

  _ida.Future<_in646bd3.AdminHealth> health() =>
      caller.callServerEndpoint<_in646bd3.AdminHealth>(
        'admin',
        'health',
        {},
      );

  _ida.Future<_ip1w2kia.AdminStats> stats() =>
      caller.callServerEndpoint<_ip1w2kia.AdminStats>(
        'admin',
        'stats',
        {},
      );

  /// The audit log, newest first: who did what and when, without the data.
  _ida.Future<List<_icr6cafh.AdminAuditInfo>> audit({
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_icr6cafh.AdminAuditInfo>>(
    'admin',
    'audit',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Groups of the server, by name, with their size.
  _ida.Future<List<_iq49mcaz.AdminGroupInfo>> groups() =>
      caller.callServerEndpoint<List<_iq49mcaz.AdminGroupInfo>>(
        'admin',
        'groups',
        {},
      );

  /// Pending invitations of every group, oldest first.
  _ida.Future<List<_idjaxr3o.AdminInvitationInfo>> invitations() =>
      caller.callServerEndpoint<List<_idjaxr3o.AdminInvitationInfo>>(
        'admin',
        'invitations',
        {},
      );

  /// Invites [email] into any group of the server (the link is emailed).
  _ida.Future<_idjaxr3o.AdminInvitationInfo> invite(
    int groupId,
    String email,
    _ibbiwcdo.MemberRole role,
  ) => caller.callServerEndpoint<_idjaxr3o.AdminInvitationInfo>(
    'admin',
    'invite',
    {
      'groupId': groupId,
      'email': email,
      'role': role,
    },
  );

  /// Revokes a pending invitation of any group: its link stops working.
  _ida.Future<void> revokeInvitation(int invitationId) =>
      caller.callServerEndpoint<void>(
        'admin',
        'revokeInvitation',
        {'invitationId': invitationId},
      );

  /// Backups kept on the host, as reported by its scripts.
  _ida.Future<_il220tje.BackupOverview> backups() =>
      caller.callServerEndpoint<_il220tje.BackupOverview>(
        'admin',
        'backups',
        {},
      );

  /// Asks the host for a backup now (carried out within seconds by
  /// docker/handle-requests.sh; at most one every 10 minutes).
  _ida.Future<void> requestBackup() => caller.callServerEndpoint<void>(
    'admin',
    'requestBackup',
    {},
  );

  /// Asks the host to check now that the newest backup restores into a
  /// throw-away database (docker/restore-test.sh; at most one every 10
  /// minutes). The live database is never touched.
  _ida.Future<void> requestRestoreTest() => caller.callServerEndpoint<void>(
    'admin',
    'requestRestoreTest',
    {},
  );

  /// Versions, automatic updates, history and release notes.
  _ida.Future<_ighiaz9s.UpdateOverview> updates() =>
      caller.callServerEndpoint<_ighiaz9s.UpdateOverview>(
        'admin',
        'updates',
        {},
      );

  /// Turns automatic updates on or off (read by the host at each run).
  _ida.Future<void> setAutoUpdate(bool on) => caller.callServerEndpoint<void>(
    'admin',
    'setAutoUpdate',
    {'on': on},
  );

  /// Asks the host to look for a new version now.
  _ida.Future<void> requestUpdateCheck() => caller.callServerEndpoint<void>(
    'admin',
    'requestUpdateCheck',
    {},
  );

  /// Asks the host to install [version] (a published vX.Y.Z newer than the
  /// installed one; the host checks it again, backs up first and rolls back
  /// if the new version does not start).
  _ida.Future<void> requestInstall(String version) =>
      caller.callServerEndpoint<void>(
        'admin',
        'requestInstall',
        {'version': version},
      );

  /// Demonstration instance only: fills the empty group [groupId] with the
  /// fictitious household (DemoSeed).
  _ida.Future<void> fillDemo(int groupId) => caller.callServerEndpoint<void>(
    'admin',
    'fillDemo',
    {'groupId': groupId},
  );

  /// Sends a test email to the administrator; returns the address. Without
  /// SMTP configuration it is written to the server log.
  _ida.Future<String> sendTestEmail() => caller.callServerEndpoint<String>(
    'admin',
    'sendTestEmail',
    {},
  );
}

/// "Mon conseiller" without AI (décision 0007): proposals computed by the
/// engine for the user, from the accounts they may see, applied only when
/// they accept them (décision 0009).
/// {@category Endpoint}
class EndpointAdvisor extends _isc.EndpointRef {
  EndpointAdvisor(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'advisor';

  /// The user's open proposals, refreshed first, then those decided in the
  /// last 30 days; newest first.
  _ida.Future<List<_ihgp0l1x.ActionProposal>> proposals(int groupId) =>
      caller.callServerEndpoint<List<_ihgp0l1x.ActionProposal>>(
        'advisor',
        'proposals',
        {'groupId': groupId},
      );

  _ida.Future<_ihgp0l1x.ActionProposal> accept(int proposalId) =>
      caller.callServerEndpoint<_ihgp0l1x.ActionProposal>(
        'advisor',
        'accept',
        {'proposalId': proposalId},
      );

  _ida.Future<_ihgp0l1x.ActionProposal> refuse(int proposalId) =>
      caller.callServerEndpoint<_ihgp0l1x.ActionProposal>(
        'advisor',
        'refuse',
        {'proposalId': proposalId},
      );

  _ida.Future<_ihgp0l1x.ActionProposal> undo(int proposalId) =>
      caller.callServerEndpoint<_ihgp0l1x.ActionProposal>(
        'advisor',
        'undo',
        {'proposalId': proposalId},
      );
}

/// The AI, optional (décision 0006): providers set up by the server
/// administrator (décision 0017), each user's choice, and the assistant.
/// {@category Endpoint}
class EndpointAi extends _isc.EndpointRef {
  EndpointAi(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ai';

  _ida.Future<_if0b0k6p.AiStatus> status() =>
      caller.callServerEndpoint<_if0b0k6p.AiStatus>(
        'ai',
        'status',
        {},
      );

  /// Creates or changes a provider. [apiKey]: null keeps the current key,
  /// empty removes it.
  _ida.Future<_iupqajx2.AiProvider> saveProvider(
    _iupqajx2.AiProvider provider,
    String? apiKey,
  ) => caller.callServerEndpoint<_iupqajx2.AiProvider>(
    'ai',
    'saveProvider',
    {
      'provider': provider,
      'apiKey': apiKey,
    },
  );

  _ida.Future<void> deleteProvider(int providerId) =>
      caller.callServerEndpoint<void>(
        'ai',
        'deleteProvider',
        {'providerId': providerId},
      );

  /// Asks the provider for its models: checks the address and the key.
  _ida.Future<List<String>> testProvider(int providerId) =>
      caller.callServerEndpoint<List<String>>(
        'ai',
        'testProvider',
        {'providerId': providerId},
      );

  /// Reads a receipt or invoice with the user's AI: a split (joined to an
  /// operation) or its amount, date and merchant (waiting) are proposed in
  /// "Mon conseiller". Nothing is changed here.
  _ida.Future<_i6gcixlb.AiReply> readInvoice(int invoiceId) =>
      caller.callServerEndpoint<_i6gcixlb.AiReply>(
        'ai',
        'readInvoice',
        {'invoiceId': invoiceId},
      );

  /// Reads a loan document with the user's AI: the terms it states are
  /// proposed for the loan in "Mon conseiller".
  _ida.Future<_i6gcixlb.AiReply> readLoanDocument(int documentId) =>
      caller.callServerEndpoint<_i6gcixlb.AiReply>(
        'ai',
        'readLoanDocument',
        {'documentId': documentId},
      );

  /// What the user asked the assistant to keep in mind, oldest first.
  _ida.Future<List<_iofw4ha7.AiMemory>> memories(int groupId) =>
      caller.callServerEndpoint<List<_iofw4ha7.AiMemory>>(
        'ai',
        'memories',
        {'groupId': groupId},
      );

  _ida.Future<_iofw4ha7.AiMemory> addMemory(
    int groupId,
    String text,
  ) => caller.callServerEndpoint<_iofw4ha7.AiMemory>(
    'ai',
    'addMemory',
    {
      'groupId': groupId,
      'text': text,
    },
  );

  _ida.Future<void> deleteMemory(int memoryId) =>
      caller.callServerEndpoint<void>(
        'ai',
        'deleteMemory',
        {'memoryId': memoryId},
      );

  /// The user's past conversations in this household, newest first.
  _ida.Future<List<_i3twyez0.AiConversation>> conversations(int groupId) =>
      caller.callServerEndpoint<List<_i3twyez0.AiConversation>>(
        'ai',
        'conversations',
        {'groupId': groupId},
      );

  /// Keeps a conversation (text only); [conversationId] goes on with one.
  /// Only the latest 30 are kept.
  _ida.Future<_i3twyez0.AiConversation> saveConversation(
    int groupId,
    int? conversationId,
    List<_iarsdlqt.AiMessage> messages,
  ) => caller.callServerEndpoint<_i3twyez0.AiConversation>(
    'ai',
    'saveConversation',
    {
      'groupId': groupId,
      'conversationId': conversationId,
      'messages': messages,
    },
  );

  _ida.Future<void> deleteConversation(int conversationId) =>
      caller.callServerEndpoint<void>(
        'ai',
        'deleteConversation',
        {'conversationId': conversationId},
      );

  /// The user's choice: a provider set up by the administrator and one of
  /// its models, on or off.
  _ida.Future<_if0b0k6p.AiStatus> setPreference(
    int? providerId,
    String? model,
    bool enabled,
  ) => caller.callServerEndpoint<_if0b0k6p.AiStatus>(
    'ai',
    'setPreference',
    {
      'providerId': providerId,
      'model': model,
      'enabled': enabled,
    },
  );

  /// One turn with the assistant, on the accounts of [groupId] the user may
  /// see. A provider that does not answer is said so: never another one.
  _ida.Future<_i6gcixlb.AiReply> chat(
    int groupId,
    List<_iarsdlqt.AiMessage> history,
    _iarsdlqt.AiMessage message,
  ) => caller.callServerEndpoint<_i6gcixlb.AiReply>(
    'ai',
    'chat',
    {
      'groupId': groupId,
      'history': history,
      'message': message,
    },
  );
}

/// Income and expenses by category over a week, a month, a quarter or a
/// year, computed
/// by the shared engine on the accounts the user may see.
/// {@category Endpoint}
class EndpointAnalysis extends _isc.EndpointRef {
  EndpointAnalysis(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analysis';

  /// [periods]: how many periods the history holds, the current one
  /// included (4 to 24, 6 by default).
  _ida.Future<_isyymxi6.SpendingReport> report(
    int groupId,
    _iff4p9sd.BudgetPeriod period,
    DateTime date, {
    int? accountId,
    int? periods,
  }) => caller.callServerEndpoint<_isyymxi6.SpendingReport>(
    'analysis',
    'report',
    {
      'groupId': groupId,
      'period': period,
      'date': date,
      'accountId': accountId,
      'periods': periods,
    },
  );

  /// The operations behind a figure of the report: one category (its
  /// sub-categories included) or the unclassified ones, largest first.
  _ida.Future<List<_ivksw0b3.BankTransaction>> operations(
    int groupId,
    _iff4p9sd.BudgetPeriod period,
    DateTime date, {
    int? categoryId,
    bool? unclassified,
    int? accountId,
  }) => caller.callServerEndpoint<List<_ivksw0b3.BankTransaction>>(
    'analysis',
    'operations',
    {
      'groupId': groupId,
      'period': period,
      'date': date,
      'categoryId': categoryId,
      'unclassified': unclassified,
      'accountId': accountId,
    },
  );

  /// What is left to spend until the end of the budget month (the next pay
  /// day), planned operations counted: checking accounts the user may see,
  /// or the one asked for.
  _ida.Future<_iqfjeddm.LeftToLiveReport> leftToLive(
    int groupId, {
    int? accountId,
  }) => caller.callServerEndpoint<_iqfjeddm.LeftToLiveReport>(
    'analysis',
    'leftToLive',
    {
      'groupId': groupId,
      'accountId': accountId,
    },
  );

  /// Bank fees, unusual debits and how reliable the forecasts were, on the
  /// accounts the user may see (computed without AI).
  _ida.Future<_iocgvawp.Insights> insights(int groupId) =>
      caller.callServerEndpoint<_iocgvawp.Insights>(
        'analysis',
        'insights',
        {'groupId': groupId},
      );

  /// Month-end review of the budget month containing [date]: rises and drops
  /// against the three previous months, goals exceeded, bank fees, biggest
  /// expenses, subscriptions charged another amount or new.
  _ida.Future<_ilg6npsn.MonthReview> review(
    int groupId,
    DateTime date, {
    int? accountId,
  }) => caller.callServerEndpoint<_ilg6npsn.MonthReview>(
    'analysis',
    'review',
    {
      'groupId': groupId,
      'date': date,
      'accountId': accountId,
    },
  );
}

/// Categories of a group, linked to the standard catalogue.
/// {@category Endpoint}
class EndpointCategory extends _isc.EndpointRef {
  EndpointCategory(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'category';

  _ida.Future<List<_i37qqsjr.Category>> list(int groupId) =>
      caller.callServerEndpoint<List<_i37qqsjr.Category>>(
        'category',
        'list',
        {'groupId': groupId},
      );

  _ida.Future<_i37qqsjr.Category> create(
    int groupId,
    String name,
    _ig2tt18e.CategoryKind kind, {
    int? parentId,
    String? standardCode,
  }) => caller.callServerEndpoint<_i37qqsjr.Category>(
    'category',
    'create',
    {
      'groupId': groupId,
      'name': name,
      'kind': kind,
      'parentId': parentId,
      'standardCode': standardCode,
    },
  );

  /// Renames (empty name = back to the standard name) and relinks to the
  /// standard catalogue.
  _ida.Future<_i37qqsjr.Category> update(
    int categoryId, {
    String? name,
    bool? resetName,
    String? standardCode,
    String? color,
  }) => caller.callServerEndpoint<_i37qqsjr.Category>(
    'category',
    'update',
    {
      'categoryId': categoryId,
      'name': name,
      'resetName': resetName,
      'standardCode': standardCode,
      'color': color,
    },
  );

  /// Moves the category to the trash; its operations become "to classify"
  /// only if the user chooses so (they keep the link until purge).
  _ida.Future<void> archive(int categoryId) => caller.callServerEndpoint<void>(
    'category',
    'archive',
    {'categoryId': categoryId},
  );
}

/// Export of the member's data in a group: complete JSON, or the
/// operations as CSV. Only what the member may see; every export is logged.
/// {@category Endpoint}
class EndpointExport extends _isc.EndpointRef {
  EndpointExport(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'export';

  /// Everything visible in [groupId], as one JSON document (amounts in
  /// cents, see docs/UTILISATION.md for the layout).
  _ida.Future<String> groupJson(int groupId) =>
      caller.callServerEndpoint<String>(
        'export',
        'groupJson',
        {'groupId': groupId},
      );

  /// The operations of the visible accounts, for a spreadsheet.
  /// [language]: `fr` (default: `;`, decimal comma) or `en`.
  _ida.Future<String> transactionsCsv(
    int groupId,
    String? language,
  ) => caller.callServerEndpoint<String>(
    'export',
    'transactionsCsv',
    {
      'groupId': groupId,
      'language': language,
    },
  );
}

/// Remarks sent from the app to the server administrator. They stay on the
/// server: nothing goes to the project or anywhere else.
/// {@category Endpoint}
class EndpointFeedback extends _isc.EndpointRef {
  EndpointFeedback(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'feedback';

  _ida.Future<_i081ti63.UserFeedback> send(
    String kind,
    String text,
    String? page,
    String? appVersion,
  ) => caller.callServerEndpoint<_i081ti63.UserFeedback>(
    'feedback',
    'send',
    {
      'kind': kind,
      'text': text,
      'page': page,
      'appVersion': appVersion,
    },
  );

  /// The user's own remarks, newest first.
  _ida.Future<List<_i081ti63.UserFeedback>> mine() =>
      caller.callServerEndpoint<List<_i081ti63.UserFeedback>>(
        'feedback',
        'mine',
        {},
      );

  /// Server administrator: every remark, newest first, with who sent it.
  _ida.Future<List<_i6glypql.FeedbackInfo>> all() =>
      caller.callServerEndpoint<List<_i6glypql.FeedbackInfo>>(
        'feedback',
        'all',
        {},
      );

  _ida.Future<_i081ti63.UserFeedback> setDone(
    int feedbackId,
    bool done,
  ) => caller.callServerEndpoint<_i081ti63.UserFeedback>(
    'feedback',
    'setDone',
    {
      'feedbackId': feedbackId,
      'done': done,
    },
  );
}

/// Monthly spending goals per category.
/// {@category Endpoint}
class EndpointGoal extends _isc.EndpointRef {
  EndpointGoal(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'goal';

  _ida.Future<List<_ita8uvsc.Goal>> list(int groupId) =>
      caller.callServerEndpoint<List<_ita8uvsc.Goal>>(
        'goal',
        'list',
        {'groupId': groupId},
      );

  /// Creates or changes the goal of an expense category.
  _ida.Future<_ita8uvsc.Goal> set(
    int groupId,
    int categoryId,
    int amountCents,
  ) => caller.callServerEndpoint<_ita8uvsc.Goal>(
    'goal',
    'set',
    {
      'groupId': groupId,
      'categoryId': categoryId,
      'amountCents': amountCents,
    },
  );

  _ida.Future<void> remove(
    int groupId,
    int categoryId,
  ) => caller.callServerEndpoint<void>(
    'goal',
    'remove',
    {
      'groupId': groupId,
      'categoryId': categoryId,
    },
  );
}

/// Groups of the current user and their members.
/// {@category Endpoint}
class EndpointGroup extends _isc.EndpointRef {
  EndpointGroup(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'group';

  _ida.Future<List<_itelwlzo.GroupMembership>> myGroups() =>
      caller.callServerEndpoint<List<_itelwlzo.GroupMembership>>(
        'group',
        'myGroups',
        {},
      );

  /// Creates a group whose administrator is the current user. Only the
  /// server administrator creates groups; others join by invitation.
  _ida.Future<_itelwlzo.GroupMembership> create(String name) =>
      caller.callServerEndpoint<_itelwlzo.GroupMembership>(
        'group',
        'create',
        {'name': name},
      );

  _ida.Future<_izr9v441.FinanceGroup> rename(
    int groupId,
    String name,
  ) => caller.callServerEndpoint<_izr9v441.FinanceGroup>(
    'group',
    'rename',
    {
      'groupId': groupId,
      'name': name,
    },
  );

  /// Day the budget month starts (1 to 28; 1 = calendar months).
  _ida.Future<_izr9v441.FinanceGroup> setMonthStartDay(
    int groupId,
    int day,
  ) => caller.callServerEndpoint<_izr9v441.FinanceGroup>(
    'group',
    'setMonthStartDay',
    {
      'groupId': groupId,
      'day': day,
    },
  );

  /// Members of the group (any member may see who else is in it).
  _ida.Future<List<_igteyn7f.MemberInfo>> members(int groupId) =>
      caller.callServerEndpoint<List<_igteyn7f.MemberInfo>>(
        'group',
        'members',
        {'groupId': groupId},
      );

  /// The group's log, for its administrators (#37): who did what and when
  /// in this group, newest first, without the data. Somebody who is no
  /// longer a member shows without their address.
  _ida.Future<List<_icr6cafh.AdminAuditInfo>> audit(
    int groupId, {
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_icr6cafh.AdminAuditInfo>>(
    'group',
    'audit',
    {
      'groupId': groupId,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Changes a member's role. The group always keeps at least one admin.
  _ida.Future<_il25bams.GroupMember> setRole(
    int groupId,
    _isc.UuidValue memberUserId,
    _ibbiwcdo.MemberRole role,
  ) => caller.callServerEndpoint<_il25bams.GroupMember>(
    'group',
    'setRole',
    {
      'groupId': groupId,
      'memberUserId': memberUserId,
      'role': role,
    },
  );

  /// Removes a member (admins), or leaves the group (any member, oneself).
  _ida.Future<void> removeMember(
    int groupId,
    _isc.UuidValue memberUserId,
  ) => caller.callServerEndpoint<void>(
    'group',
    'removeMember',
    {
      'groupId': groupId,
      'memberUserId': memberUserId,
    },
  );
}

/// Bank statement import: preview, import, history, cancel.
/// {@category Endpoint}
class EndpointImport extends _isc.EndpointRef {
  EndpointImport(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'import';

  /// What the import would do. Writes nothing.
  _ida.Future<_ikjuebnd.ImportPreview> preview(
    int accountId,
    _idt.ByteData file, {
    _irbioy6y.CsvColumns? columns,
  }) => caller.callServerEndpoint<_ikjuebnd.ImportPreview>(
    'import',
    'preview',
    {
      'accountId': accountId,
      'file': file,
      'columns': columns,
    },
  );

  _ida.Future<_i5x9swls.StatementImport> commit(
    int accountId,
    String fileName,
    _idt.ByteData file, {
    _irbioy6y.CsvColumns? columns,
    List<int>? acceptedPossibleDuplicates,
  }) => caller.callServerEndpoint<_i5x9swls.StatementImport>(
    'import',
    'commit',
    {
      'accountId': accountId,
      'fileName': fileName,
      'file': file,
      'columns': columns,
      'acceptedPossibleDuplicates': acceptedPossibleDuplicates,
    },
  );

  _ida.Future<List<_i5x9swls.StatementImport>> history(int accountId) =>
      caller.callServerEndpoint<List<_i5x9swls.StatementImport>>(
        'import',
        'history',
        {'accountId': accountId},
      );

  _ida.Future<_i5x9swls.StatementImport> cancel(int importId) =>
      caller.callServerEndpoint<_i5x9swls.StatementImport>(
        'import',
        'cancel',
        {'importId': importId},
      );
}

/// Invitations to join a group (group admins), and acceptance by users who
/// already have an account.
/// {@category Endpoint}
class EndpointInvitation extends _isc.EndpointRef {
  EndpointInvitation(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'invitation';

  _ida.Future<_i2judacm.InvitationInfo> create(
    int groupId,
    String email,
    _ibbiwcdo.MemberRole role,
  ) => caller.callServerEndpoint<_i2judacm.InvitationInfo>(
    'invitation',
    'create',
    {
      'groupId': groupId,
      'email': email,
      'role': role,
    },
  );

  /// Pending invitations of the group.
  _ida.Future<List<_i2judacm.InvitationInfo>> list(int groupId) =>
      caller.callServerEndpoint<List<_i2judacm.InvitationInfo>>(
        'invitation',
        'list',
        {'groupId': groupId},
      );

  _ida.Future<void> revoke(int invitationId) => caller.callServerEndpoint<void>(
    'invitation',
    'revoke',
    {'invitationId': invitationId},
  );

  /// Accepts an invitation link while signed in. The invitation must have
  /// been sent to the email of the signed-in account.
  _ida.Future<_itelwlzo.GroupMembership> accept(String token) =>
      caller.callServerEndpoint<_itelwlzo.GroupMembership>(
        'invitation',
        'accept',
        {'token': token},
      );
}

/// Invoices and receipts (PDF or photo) attached to operations: kept,
/// listed under a name built from their operation, opened, emailed, with
/// an optional end of warranty (reminder a month before).
///
/// An invoice of an operation is seen by those who see its account; one
/// without operation by every member of the group.
/// {@category Endpoint}
class EndpointInvoice extends _isc.EndpointRef {
  EndpointInvoice(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'invoice';

  /// Invoices the user may see, newest operation first. [year] filters on
  /// the operation's date (without operation: the invoice's date, else the
  /// day it was saved); [search] on names and labels; [warranty]: only
  /// those with a running warranty; [unattached]: only those waiting for
  /// their operation.
  _ida.Future<List<_iej1c1us.InvoiceInfo>> list(
    int groupId, {
    int? year,
    String? search,
    bool? warranty,
    bool? unattached,
  }) => caller.callServerEndpoint<List<_iej1c1us.InvoiceInfo>>(
    'invoice',
    'list',
    {
      'groupId': groupId,
      'year': year,
      'search': search,
      'warranty': warranty,
      'unattached': unattached,
    },
  );

  /// Invoices of one operation, in the order they were added.
  _ida.Future<List<_iej1c1us.InvoiceInfo>> forTransaction(int transactionId) =>
      caller.callServerEndpoint<List<_iej1c1us.InvoiceInfo>>(
        'invoice',
        'forTransaction',
        {'transactionId': transactionId},
      );

  /// Keeps an invoice of the operation (PDF or image, 10 MB at most).
  _ida.Future<_iej1c1us.InvoiceInfo> upload(
    int transactionId,
    String fileName,
    _idt.ByteData file,
  ) => caller.callServerEndpoint<_iej1c1us.InvoiceInfo>(
    'invoice',
    'upload',
    {
      'transactionId': transactionId,
      'fileName': fileName,
      'file': file,
    },
  );

  /// Keeps an invoice whose operation is not there yet (not on the
  /// statement, or not imported). Until attached, every member of the
  /// group sees it. [amountCents] (total paid, positive), [date] and
  /// [merchant] help propose its operation.
  _ida.Future<_iej1c1us.InvoiceInfo> uploadUnattached(
    int groupId,
    String fileName,
    _idt.ByteData file, {
    int? amountCents,
    DateTime? date,
    String? merchant,
  }) => caller.callServerEndpoint<_iej1c1us.InvoiceInfo>(
    'invoice',
    'uploadUnattached',
    {
      'groupId': groupId,
      'fileName': fileName,
      'file': file,
      'amountCents': amountCents,
      'date': date,
      'merchant': merchant,
    },
  );

  /// Amount, date and merchant of an invoice waiting for its operation
  /// (null clears them).
  _ida.Future<_iej1c1us.InvoiceInfo> setHints(
    int invoiceId,
    int? amountCents,
    DateTime? date,
    String? merchant,
  ) => caller.callServerEndpoint<_iej1c1us.InvoiceInfo>(
    'invoice',
    'setHints',
    {
      'invoiceId': invoiceId,
      'amountCents': amountCents,
      'date': date,
      'merchant': merchant,
    },
  );

  /// Operations that could be this waiting invoice's, best first, among
  /// the accounts the user sees. With [search], operations whose label
  /// contains it, whatever the hints.
  _ida.Future<List<_ikyjg3a9.InvoiceMatch>> proposals(
    int invoiceId, {
    String? search,
  }) => caller.callServerEndpoint<List<_ikyjg3a9.InvoiceMatch>>(
    'invoice',
    'proposals',
    {
      'invoiceId': invoiceId,
      'search': search,
    },
  );

  /// Invoices waiting for their operation that could be this operation's,
  /// best first.
  _ida.Future<List<_ikyjg3a9.InvoiceMatch>> candidatesFor(int transactionId) =>
      caller.callServerEndpoint<List<_ikyjg3a9.InvoiceMatch>>(
        'invoice',
        'candidatesFor',
        {'transactionId': transactionId},
      );

  /// Attaches the invoice to the operation (or moves it to another one).
  /// Needs to be allowed to change both.
  _ida.Future<_iej1c1us.InvoiceInfo> attach(
    int invoiceId,
    int transactionId,
  ) => caller.callServerEndpoint<_iej1c1us.InvoiceInfo>(
    'invoice',
    'attach',
    {
      'invoiceId': invoiceId,
      'transactionId': transactionId,
    },
  );

  /// The content, for the user to open or save it.
  _ida.Future<_idt.ByteData> download(int invoiceId) =>
      caller.callServerEndpoint<_idt.ByteData>(
        'invoice',
        'download',
        {'invoiceId': invoiceId},
      );

  /// What it is for and the end of its warranty (null clears them).
  _ida.Future<_iej1c1us.InvoiceInfo> update(
    int invoiceId,
    String? label,
    DateTime? warrantyUntil,
  ) => caller.callServerEndpoint<_iej1c1us.InvoiceInfo>(
    'invoice',
    'update',
    {
      'invoiceId': invoiceId,
      'label': label,
      'warrantyUntil': warrantyUntil,
    },
  );

  _ida.Future<void> delete(int invoiceId) => caller.callServerEndpoint<void>(
    'invoice',
    'delete',
    {'invoiceId': invoiceId},
  );

  /// Emails the invoice to [to] (an accountant, a shop's after-sales
  /// service…), with an optional [message]. Needs the server's SMTP
  /// settings; at most [maxSentPerDay] per member and 24 hours.
  _ida.Future<void> send(
    int invoiceId,
    String to,
    String? message,
  ) => caller.callServerEndpoint<void>(
    'invoice',
    'send',
    {
      'invoiceId': invoiceId,
      'to': to,
      'message': message,
    },
  );
}

/// Loans: entry, amortisation schedule, where they stand, early repayment
/// simulation. With an account, the instalments become a planned operation
/// (forecast and reconciliation with the real debits).
/// {@category Endpoint}
class EndpointLoan extends _isc.EndpointRef {
  EndpointLoan(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'loan';

  _ida.Future<_i1y07bmb.LoanOverview> overview(int groupId) =>
      caller.callServerEndpoint<_i1y07bmb.LoanOverview>(
        'loan',
        'overview',
        {'groupId': groupId},
      );

  /// Payments in instalments and small consumer loans still running that
  /// are not in the loans yet: debits of the visible accounts classified in
  /// those categories over the last 13 months, grouped by label (see
  /// core.detectInstalmentPlans). Those of a loan already entered, linked
  /// to it or recognised by its label, are left out.
  _ida.Future<List<_io211e4m.InstalmentCandidate>> detectedInstalments(
    int groupId,
  ) => caller.callServerEndpoint<List<_io211e4m.InstalmentCandidate>>(
    'loan',
    'detectedInstalments',
    {'groupId': groupId},
  );

  _ida.Future<List<_i18weoko.LoanInstallment>> schedule(int loanId) =>
      caller.callServerEndpoint<List<_i18weoko.LoanInstallment>>(
        'loan',
        'schedule',
        {'loanId': loanId},
      );

  /// The loan's operations on the accounts the user may see: debits linked
  /// to its instalments or classified by its rule, newest first.
  _ida.Future<List<_ivksw0b3.BankTransaction>> operations(int loanId) =>
      caller.callServerEndpoint<List<_ivksw0b3.BankTransaction>>(
        'loan',
        'operations',
        {'loanId': loanId},
      );

  /// Documents of the loan (amortisation table, offer, screenshots…),
  /// newest first, without their content.
  _ida.Future<List<_ixzu9i3x.LoanDocument>> documents(int loanId) =>
      caller.callServerEndpoint<List<_ixzu9i3x.LoanDocument>>(
        'loan',
        'documents',
        {'loanId': loanId},
      );

  /// Keeps a document of the loan on the server (10 MB at most).
  _ida.Future<_ixzu9i3x.LoanDocument> uploadDocument(
    int loanId,
    String fileName,
    _idt.ByteData file,
  ) => caller.callServerEndpoint<_ixzu9i3x.LoanDocument>(
    'loan',
    'uploadDocument',
    {
      'loanId': loanId,
      'fileName': fileName,
      'file': file,
    },
  );

  /// The content of a document, for the user to open or save it.
  _ida.Future<_idt.ByteData> downloadDocument(int documentId) =>
      caller.callServerEndpoint<_idt.ByteData>(
        'loan',
        'downloadDocument',
        {'documentId': documentId},
      );

  _ida.Future<void> deleteDocument(int documentId) =>
      caller.callServerEndpoint<void>(
        'loan',
        'deleteDocument',
        {'documentId': documentId},
      );

  _ida.Future<_i0heeame.EarlyRepayment> simulate(
    int loanId,
    int amountCents,
  ) => caller.callServerEndpoint<_i0heeame.EarlyRepayment>(
    'loan',
    'simulate',
    {
      'loanId': loanId,
      'amountCents': amountCents,
    },
  );

  /// What a change would do (renegotiation, new rate, new duration), with
  /// its fees: before and after, the saving and when it pays off. Nothing
  /// is saved; addEvent records it once chosen.
  _ida.Future<_in49arm1.LoanChangeSimulation> simulateChange(
    int loanId,
    _iz3v8osk.LoanEvent event, {
    int? feesCents,
  }) => caller.callServerEndpoint<_in49arm1.LoanChangeSimulation>(
    'loan',
    'simulateChange',
    {
      'loanId': loanId,
      'event': event,
      'feesCents': feesCents,
    },
  );

  /// Adds a change to the loan (new rate, renegotiation, money drawn or
  /// repaid): the schedule, the planned instalments and the forecast follow.
  /// Refused when the loan would no longer be repaid, or when a revolving
  /// credit would go over its limit.
  _ida.Future<_iwrqx7d4.LoanInfo> addEvent(
    int loanId,
    _iz3v8osk.LoanEvent event,
  ) => caller.callServerEndpoint<_iwrqx7d4.LoanInfo>(
    'loan',
    'addEvent',
    {
      'loanId': loanId,
      'event': event,
    },
  );

  /// Removes the change at [index] (as listed in the loan, oldest first).
  _ida.Future<_iwrqx7d4.LoanInfo> removeEvent(
    int loanId,
    int index,
  ) => caller.callServerEndpoint<_iwrqx7d4.LoanInfo>(
    'loan',
    'removeEvent',
    {
      'loanId': loanId,
      'index': index,
    },
  );

  _ida.Future<_iwrqx7d4.LoanInfo> create(
    int groupId,
    _ig538h6x.Loan loan,
  ) => caller.callServerEndpoint<_iwrqx7d4.LoanInfo>(
    'loan',
    'create',
    {
      'groupId': groupId,
      'loan': loan,
    },
  );

  _ida.Future<_iwrqx7d4.LoanInfo> update(_ig538h6x.Loan loan) =>
      caller.callServerEndpoint<_iwrqx7d4.LoanInfo>(
        'loan',
        'update',
        {'loan': loan},
      );

  /// "This is a loan instalment": declares a loan from one of its debits.
  /// The loan is debited from the operation's account; its instalments are
  /// recognised by the operation's label (planned operation and a group
  /// rule classifying them in the loan's category, by default the standard
  /// category of its kind). Past debits that match an instalment are linked
  /// to it; the operation itself is classified as chosen by the user.
  _ida.Future<_i04nbqtd.LoanFromOperation> createFromTransaction(
    int transactionId,
    _ig538h6x.Loan loan,
  ) => caller.callServerEndpoint<_i04nbqtd.LoanFromOperation>(
    'loan',
    'createFromTransaction',
    {
      'transactionId': transactionId,
      'loan': loan,
    },
  );

  /// "This is an instalment of that loan": attaches a past debit to a loan
  /// already entered. The debit is linked to the nearest instalment and
  /// classified in the loan's category; a loan without an account takes the
  /// debit's, one without a recognised label takes the debit's (and a rule
  /// classifying the next ones). Other past instalments found are linked too.
  _ida.Future<_i04nbqtd.LoanFromOperation> attachTransaction(
    int loanId,
    int transactionId,
  ) => caller.callServerEndpoint<_i04nbqtd.LoanFromOperation>(
    'loan',
    'attachTransaction',
    {
      'loanId': loanId,
      'transactionId': transactionId,
    },
  );

  /// Undo of [attachTransaction]: unlinks the debit from the loan and, when
  /// the attachment created the loan's rule ([ruleId]), removes it and
  /// classifies again what it had classified (the app restores the debit's
  /// own classification).
  _ida.Future<int> undoAttach(
    int loanId,
    int transactionId, {
    int? ruleId,
  }) => caller.callServerEndpoint<int>(
    'loan',
    'undoAttach',
    {
      'loanId': loanId,
      'transactionId': transactionId,
      'ruleId': ruleId,
    },
  );

  /// Undo of "this is a loan instalment": removes the loan, its planned
  /// instalments and its rule, unlinks its instalments and classifies again
  /// the operations the rule had classified (the app restores the declared
  /// operation itself). Returns how many were classified again.
  _ida.Future<int> undoCreate(int loanId) => caller.callServerEndpoint<int>(
    'loan',
    'undoCreate',
    {'loanId': loanId},
  );

  /// Moves the loan to the trash and stops its planned instalments.
  _ida.Future<void> delete(int loanId) => caller.callServerEndpoint<void>(
    'loan',
    'delete',
    {'loanId': loanId},
  );
}

/// The user's MCP tokens (décision 0018): listed, created (the secret is
/// shown once), revoked.
/// {@category Endpoint}
class EndpointMcp extends _isc.EndpointRef {
  EndpointMcp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mcp';

  _ida.Future<List<_ioxkfsho.McpToken>> tokens() =>
      caller.callServerEndpoint<List<_ioxkfsho.McpToken>>(
        'mcp',
        'tokens',
        {},
      );

  _ida.Future<_i9n2kr6t.McpTokenCreated> create(
    int groupId,
    String name,
  ) => caller.callServerEndpoint<_i9n2kr6t.McpTokenCreated>(
    'mcp',
    'create',
    {
      'groupId': groupId,
      'name': name,
    },
  );

  _ida.Future<void> revoke(int tokenId) => caller.callServerEndpoint<void>(
    'mcp',
    'revoke',
    {'tokenId': tokenId},
  );
}

/// The current user's notifications.
/// {@category Endpoint}
class EndpointNotification extends _isc.EndpointRef {
  EndpointNotification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  _ida.Future<List<_igwx4n0s.AppNotification>> list({bool? unreadOnly}) =>
      caller.callServerEndpoint<List<_igwx4n0s.AppNotification>>(
        'notification',
        'list',
        {'unreadOnly': unreadOnly},
      );

  _ida.Future<int> unreadCount() => caller.callServerEndpoint<int>(
    'notification',
    'unreadCount',
    {},
  );

  _ida.Future<void> markRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'notification',
        'markRead',
        {'notificationId': notificationId},
      );

  _ida.Future<void> markAllRead() => caller.callServerEndpoint<void>(
    'notification',
    'markAllRead',
    {},
  );

  /// The user's own choices (everything on by default).
  _ida.Future<_inuj1ggb.NotificationSettings> settings() =>
      caller.callServerEndpoint<_inuj1ggb.NotificationSettings>(
        'notification',
        'settings',
        {},
      );

  /// Saves the user's choices; always for the user signed in, whatever
  /// [settings] says. An email needs its alert in the app.
  _ida.Future<_inuj1ggb.NotificationSettings> saveSettings(
    _inuj1ggb.NotificationSettings settings,
  ) => caller.callServerEndpoint<_inuj1ggb.NotificationSettings>(
    'notification',
    'saveSettings',
    {'settings': settings},
  );
}

/// Classification rules of a group (cahier des charges, Classement).
/// {@category Endpoint}
class EndpointRule extends _isc.EndpointRef {
  EndpointRule(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rule';

  _ida.Future<List<_i0jtaw5e.Rule>> list(int groupId) =>
      caller.callServerEndpoint<List<_i0jtaw5e.Rule>>(
        'rule',
        'list',
        {'groupId': groupId},
      );

  _ida.Future<_i0jtaw5e.Rule> create(
    int groupId,
    int categoryId,
    String pattern,
    _iko98d6o.RuleMatchType matchType, {
    _idnlspx6.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    int? priority,
  }) => caller.callServerEndpoint<_i0jtaw5e.Rule>(
    'rule',
    'create',
    {
      'groupId': groupId,
      'categoryId': categoryId,
      'pattern': pattern,
      'matchType': matchType,
      'direction': direction,
      'minAbsCents': minAbsCents,
      'maxAbsCents': maxAbsCents,
      'priority': priority,
    },
  );

  _ida.Future<_i0jtaw5e.Rule> update(
    int ruleId, {
    int? categoryId,
    String? pattern,
    _iko98d6o.RuleMatchType? matchType,
    _idnlspx6.RuleDirection? direction,
    int? minAbsCents,
    int? maxAbsCents,
    bool? clearAmounts,
    int? priority,
    bool? enabled,
  }) => caller.callServerEndpoint<_i0jtaw5e.Rule>(
    'rule',
    'update',
    {
      'ruleId': ruleId,
      'categoryId': categoryId,
      'pattern': pattern,
      'matchType': matchType,
      'direction': direction,
      'minAbsCents': minAbsCents,
      'maxAbsCents': maxAbsCents,
      'clearAmounts': clearAmounts,
      'priority': priority,
      'enabled': enabled,
    },
  );

  /// Undo of "always classify like this": deletes the rule and classifies
  /// again the operations it had classified. Returns how many.
  _ida.Future<int> undoCreate(int ruleId) => caller.callServerEndpoint<int>(
    'rule',
    'undoCreate',
    {'ruleId': ruleId},
  );

  _ida.Future<void> delete(int ruleId) => caller.callServerEndpoint<void>(
    'rule',
    'delete',
    {'ruleId': ruleId},
  );

  /// Rule tester: how a bank label would be cleaned and classified now
  /// (group rules → community rules → history). Writes nothing.
  _ida.Future<_ilhr3r4a.RuleTestResult> tryLabel(
    int groupId,
    String label,
    int amountCents,
  ) => caller.callServerEndpoint<_ilhr3r4a.RuleTestResult>(
    'rule',
    'tryLabel',
    {
      'groupId': groupId,
      'label': label,
      'amountCents': amountCents,
    },
  );
}

/// Planned operations (rent, salary, subscriptions…) and the forecast.
/// {@category Endpoint}
class EndpointScheduled extends _isc.EndpointRef {
  EndpointScheduled(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scheduled';

  _ida.Future<List<_ibpr6881.ScheduledTransaction>> list(int accountId) =>
      caller.callServerEndpoint<List<_ibpr6881.ScheduledTransaction>>(
        'scheduled',
        'list',
        {'accountId': accountId},
      );

  _ida.Future<_ibpr6881.ScheduledTransaction> create(
    int accountId,
    int amountCents,
    String label,
    _i1mv9fwy.ScheduleFrequency frequency,
    DateTime startDate, {
    int? interval,
    DateTime? endDate,
    int? occurrenceCount,
    int? categoryId,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    bool? subscription,
  }) => caller.callServerEndpoint<_ibpr6881.ScheduledTransaction>(
    'scheduled',
    'create',
    {
      'accountId': accountId,
      'amountCents': amountCents,
      'label': label,
      'frequency': frequency,
      'startDate': startDate,
      'interval': interval,
      'endDate': endDate,
      'occurrenceCount': occurrenceCount,
      'categoryId': categoryId,
      'matchPattern': matchPattern,
      'dateToleranceDays': dateToleranceDays,
      'amountTolerancePercent': amountTolerancePercent,
      'subscription': subscription,
    },
  );

  _ida.Future<_ibpr6881.ScheduledTransaction> update(
    int scheduledId, {
    int? amountCents,
    String? label,
    int? categoryId,
    DateTime? endDate,
    String? matchPattern,
    int? dateToleranceDays,
    int? amountTolerancePercent,
    bool? subscription,
  }) => caller.callServerEndpoint<_ibpr6881.ScheduledTransaction>(
    'scheduled',
    'update',
    {
      'scheduledId': scheduledId,
      'amountCents': amountCents,
      'label': label,
      'categoryId': categoryId,
      'endDate': endDate,
      'matchPattern': matchPattern,
      'dateToleranceDays': dateToleranceDays,
      'amountTolerancePercent': amountTolerancePercent,
      'subscription': subscription,
    },
  );

  _ida.Future<void> delete(int scheduledId) => caller.callServerEndpoint<void>(
    'scheduled',
    'delete',
    {'scheduledId': scheduledId},
  );

  /// Subscriptions of the accounts the user may see, with their monthly
  /// cost. Ended ones (last occurrence passed) are left out.
  _ida.Future<_i0jm8pub.SubscriptionOverview> subscriptions(int groupId) =>
      caller.callServerEndpoint<_i0jm8pub.SubscriptionOverview>(
        'scheduled',
        'subscriptions',
        {'groupId': groupId},
      );

  /// "This is a subscription": a planned operation repeating [transactionId]
  /// (same amount, label and category) from its date, the operation itself
  /// being its first occurrence. Later debits are matched on the label, with
  /// a 10 % amount tolerance for price changes.
  _ida.Future<_ibpr6881.ScheduledTransaction> subscribeFrom(
    int transactionId, {
    _i1mv9fwy.ScheduleFrequency? frequency,
  }) => caller.callServerEndpoint<_ibpr6881.ScheduledTransaction>(
    'scheduled',
    'subscribeFrom',
    {
      'transactionId': transactionId,
      'frequency': frequency,
    },
  );

  /// Due dates of the budget month containing [date], on the accounts the
  /// user may see (or the one asked for): each occurrence of the planned
  /// operations, paid, late, skipped or to come.
  _ida.Future<_i25nl2kq.DueCalendar> calendar(
    int groupId,
    DateTime date, {
    int? accountId,
  }) => caller.callServerEndpoint<_i25nl2kq.DueCalendar>(
    'scheduled',
    'calendar',
    {
      'groupId': groupId,
      'date': date,
      'accountId': accountId,
    },
  );

  /// The next occurrence will not happen (or was paid otherwise): skip it.
  _ida.Future<_ibpr6881.ScheduledTransaction> skipNext(int scheduledId) =>
      caller.callServerEndpoint<_ibpr6881.ScheduledTransaction>(
        'scheduled',
        'skipNext',
        {'scheduledId': scheduledId},
      );

  /// Forecast of the account from the user's [today] (calendar date of the
  /// device; must be within a day of the server's date). [includeVariable]
  /// (default true) adds the estimated variable spending.
  _ida.Future<_ip0wp7v2.ForecastResult> forecast(
    int accountId,
    DateTime today, {
    int? horizonDays,
    bool? includeVariable,
  }) => caller.callServerEndpoint<_ip0wp7v2.ForecastResult>(
    'scheduled',
    'forecast',
    {
      'accountId': accountId,
      'today': today,
      'horizonDays': horizonDays,
      'includeVariable': includeVariable,
    },
  );

  /// Purchase simulator: the balance on [target], the low point and the
  /// overdraft risk if [amountCents] is spent on [date] in cash, in 3 or 4
  /// instalments, or a month later, next to not buying. [categoryId] adds
  /// the category's monthly goal. Nothing is saved.
  _ida.Future<_is7p90bk.PurchaseSimulation> simulatePurchase(
    int accountId,
    DateTime today,
    int amountCents,
    DateTime date,
    DateTime target, {
    int? categoryId,
    bool? includeVariable,
  }) => caller.callServerEndpoint<_is7p90bk.PurchaseSimulation>(
    'scheduled',
    'simulatePurchase',
    {
      'accountId': accountId,
      'today': today,
      'amountCents': amountCents,
      'date': date,
      'target': target,
      'categoryId': categoryId,
      'includeVariable': includeVariable,
    },
  );

  /// Confirms a reconciliation proposal.
  _ida.Future<void> confirmMatch(
    int scheduledId,
    DateTime dueDate,
    int transactionId,
  ) => caller.callServerEndpoint<void>(
    'scheduled',
    'confirmMatch',
    {
      'scheduledId': scheduledId,
      'dueDate': dueDate,
      'transactionId': transactionId,
    },
  );
}

/// First launch wizard (no login: no account exists yet).
/// {@category Endpoint}
class EndpointSetup extends _isc.EndpointRef {
  EndpointSetup(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'setup';

  _ida.Future<_iayy8tg9.SetupStatus> status() =>
      caller.callServerEndpoint<_iayy8tg9.SetupStatus>(
        'setup',
        'status',
        {},
      );

  /// Checks the setup code from the server log and allows [email] to
  /// register as server administrator (then: emailIdp.startRegistration).
  _ida.Future<void> start(
    String setupCode,
    String email,
  ) => caller.callServerEndpoint<void>(
    'setup',
    'start',
    {
      'setupCode': setupCode,
      'email': email,
    },
  );
}

/// Operations of an account: list, manual entry, corrections, checking,
/// trash, and rules created from a correction.
/// {@category Endpoint}
class EndpointTransaction extends _isc.EndpointRef {
  EndpointTransaction(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transaction';

  _ida.Future<_ioa38wkb.TransactionPage> list(
    int accountId, {
    DateTime? from,
    DateTime? to,
    String? search,
    String? sameLabel,
    int? categoryId,
    bool? includeSubcategories,
    bool? toClassify,
    bool? uncleared,
    bool? subscriptions,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<_ioa38wkb.TransactionPage>(
    'transaction',
    'list',
    {
      'accountId': accountId,
      'from': from,
      'to': to,
      'search': search,
      'sameLabel': sameLabel,
      'categoryId': categoryId,
      'includeSubcategories': includeSubcategories,
      'toClassify': toClassify,
      'uncleared': uncleared,
      'subscriptions': subscriptions,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Manual entry (cash, a cheque not yet on the statement…). Classified by
  /// the rules unless a category is given.
  _ida.Future<_ivksw0b3.BankTransaction> create(
    int accountId,
    DateTime date,
    int amountCents,
    String label, {
    String? note,
    int? categoryId,
  }) => caller.callServerEndpoint<_ivksw0b3.BankTransaction>(
    'transaction',
    'create',
    {
      'accountId': accountId,
      'date': date,
      'amountCents': amountCents,
      'label': label,
      'note': note,
      'categoryId': categoryId,
    },
  );

  /// Date, amount and label can only be changed on manual entries: imported
  /// operations keep what the bank wrote. The note can always be changed.
  _ida.Future<_ivksw0b3.BankTransaction> update(
    int transactionId, {
    DateTime? date,
    int? amountCents,
    String? label,
    String? note,
  }) => caller.callServerEndpoint<_ivksw0b3.BankTransaction>(
    'transaction',
    'update',
    {
      'transactionId': transactionId,
      'date': date,
      'amountCents': amountCents,
      'label': label,
      'note': note,
    },
  );

  /// The user's choice; `null` puts the operation back to "to classify".
  _ida.Future<_ivksw0b3.BankTransaction> setCategory(
    int transactionId,
    int? categoryId,
  ) => caller.callServerEndpoint<_ivksw0b3.BankTransaction>(
    'transaction',
    'setCategory',
    {
      'transactionId': transactionId,
      'categoryId': categoryId,
    },
  );

  /// Undo of a classification change: puts back the category, its source
  /// and the split the operation had before (as the app saw it).
  _ida.Future<_ivksw0b3.BankTransaction> restoreClassification(
    int transactionId,
    int? categoryId,
    _i8y5k73o.CategorySource source,
    String? ruleRef,
    List<_idy91hap.TransactionSplit> splits,
  ) => caller.callServerEndpoint<_ivksw0b3.BankTransaction>(
    'transaction',
    'restoreClassification',
    {
      'transactionId': transactionId,
      'categoryId': categoryId,
      'source': source,
      'ruleRef': ruleRef,
      'splits': splits,
    },
  );

  /// Parts of a split operation (empty when not split).
  _ida.Future<List<_idy91hap.TransactionSplit>> splits(int transactionId) =>
      caller.callServerEndpoint<List<_idy91hap.TransactionSplit>>(
        'transaction',
        'splits',
        {'transactionId': transactionId},
      );

  /// The other operations of the same provider (same cleaned label) on the
  /// accounts of the group the user may see: the [limit] most recent (10
  /// by default, at most 50), and how many there are in all, with their
  /// total and average.
  _ida.Future<_i26z4phw.ProviderHistory> sameProvider(
    int transactionId, {
    int? limit,
  }) => caller.callServerEndpoint<_i26z4phw.ProviderHistory>(
    'transaction',
    'sameProvider',
    {
      'transactionId': transactionId,
      'limit': limit,
    },
  );

  /// Splits the operation between categories (a receipt: groceries,
  /// household…): at least two parts of its sign adding up to its amount.
  /// The operation shows the category of its largest part and counts as
  /// classified by hand. An empty list removes the split.
  _ida.Future<_ivksw0b3.BankTransaction> setSplits(
    int transactionId,
    List<_idy91hap.TransactionSplit> parts,
  ) => caller.callServerEndpoint<_ivksw0b3.BankTransaction>(
    'transaction',
    'setSplits',
    {
      'transactionId': transactionId,
      'parts': parts,
    },
  );

  _ida.Future<_ivksw0b3.BankTransaction> setCleared(
    int transactionId,
    bool cleared,
  ) => caller.callServerEndpoint<_ivksw0b3.BankTransaction>(
    'transaction',
    'setCleared',
    {
      'transactionId': transactionId,
      'cleared': cleared,
    },
  );

  /// Checks or unchecks several operations at once (up to 500), all or
  /// none: each must exist and be writable by the user. Returns the
  /// operations as they were before, so that the change can be undone.
  _ida.Future<List<_ivksw0b3.BankTransaction>> setClearedMany(
    List<int> transactionIds,
    bool cleared,
  ) => caller.callServerEndpoint<List<_ivksw0b3.BankTransaction>>(
    'transaction',
    'setClearedMany',
    {
      'transactionIds': transactionIds,
      'cleared': cleared,
    },
  );

  /// The trash: operations moved there, on the accounts the user may see,
  /// most recently trashed first.
  _ida.Future<List<_ivksw0b3.BankTransaction>> trashed(int groupId) =>
      caller.callServerEndpoint<List<_ivksw0b3.BankTransaction>>(
        'transaction',
        'trashed',
        {'groupId': groupId},
      );

  /// Deletes an operation of the trash for good (its split and invoices
  /// with it). Only from the trash.
  _ida.Future<void> purge(int transactionId) => caller.callServerEndpoint<void>(
    'transaction',
    'purge',
    {'transactionId': transactionId},
  );

  /// Empties the trash of the accounts the user may change. Returns how
  /// many operations were deleted.
  _ida.Future<int> emptyTrash(int groupId) => caller.callServerEndpoint<int>(
    'transaction',
    'emptyTrash',
    {'groupId': groupId},
  );

  /// Moves the operation to the trash (kept 30 days).
  _ida.Future<void> trash(int transactionId) => caller.callServerEndpoint<void>(
    'transaction',
    'trash',
    {'transactionId': transactionId},
  );

  _ida.Future<_ivksw0b3.BankTransaction> restore(int transactionId) =>
      caller.callServerEndpoint<_ivksw0b3.BankTransaction>(
        'transaction',
        'restore',
        {'transactionId': transactionId},
      );

  /// "Always classify like this": a group rule on the cleaned label, in the
  /// direction of the operation, applied at once to the operations of the
  /// group not classified by hand.
  _ida.Future<_i0d2e7ql.RuleApplication> createRuleFrom(
    int transactionId,
    int categoryId, {
    _iko98d6o.RuleMatchType? matchType,
  }) => caller.callServerEndpoint<_i0d2e7ql.RuleApplication>(
    'transaction',
    'createRuleFrom',
    {
      'transactionId': transactionId,
      'categoryId': categoryId,
      'matchType': matchType,
    },
  );
}

/// Import of an export into a new group (decision 0022): moving from the
/// standalone app to a server, back, or between servers. Only the server
/// administrator, who alone creates groups; the export is sent in parts
/// (an export of 100 000 operations is about 40 MB).
/// {@category Endpoint}
class EndpointTransfer extends _isc.EndpointRef {
  EndpointTransfer(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transfer';

  /// Starts an upload; returns its token.
  _ida.Future<String> begin() => caller.callServerEndpoint<String>(
    'transfer',
    'begin',
    {},
  );

  /// One part of the export, in order.
  _ida.Future<void> part(
    String token,
    String text,
  ) => caller.callServerEndpoint<void>(
    'transfer',
    'part',
    {
      'token': token,
      'text': text,
    },
  );

  /// Creates the group from the parts sent. [name]: another name for it.
  _ida.Future<_i4a7ax0k.ImportResult> finish(
    String token,
    String? name,
  ) => caller.callServerEndpoint<_i4a7ax0k.ImportResult>(
    'transfer',
    'finish',
    {
      'token': token,
      'name': name,
    },
  );

  /// The file of one imported document ([ImportResult.documents]).
  _ida.Future<void> document(
    int groupId,
    String kind,
    int id,
    _idt.ByteData content,
  ) => caller.callServerEndpoint<void>(
    'transfer',
    'document',
    {
      'groupId': groupId,
      'kind': kind,
      'id': id,
      'content': content,
    },
  );
}

/// Two-factor authentication. Needs a signed-in user, but not [accessScope]:
/// [verify] is how a password-only session gets full access.
/// {@category Endpoint}
class EndpointTwoFactor extends _isc.EndpointRef {
  EndpointTwoFactor(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'twoFactor';

  _ida.Future<_is1jzs1l.TwoFactorStatus> status() =>
      caller.callServerEndpoint<_is1jzs1l.TwoFactorStatus>(
        'twoFactor',
        'status',
        {},
      );

  /// Step 1: secret and QR code URI for the authenticator app.
  _ida.Future<_iy6m3xur.TotpEnrollment> begin() =>
      caller.callServerEndpoint<_iy6m3xur.TotpEnrollment>(
        'twoFactor',
        'begin',
        {},
      );

  /// Step 2: first code from the app. Returns the 10 backup codes, shown
  /// only once.
  _ida.Future<List<String>> confirm(String code) =>
      caller.callServerEndpoint<List<String>>(
        'twoFactor',
        'confirm',
        {'code': code},
      );

  /// After the password sign-in: exchanges the partial session for a full
  /// one when [code] (TOTP or backup code) is valid.
  _ida.Future<_iacc.AuthSuccess> verify(String code) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'twoFactor',
        'verify',
        {'code': code},
      );

  /// New backup codes (the old ones stop working).
  _ida.Future<List<String>> renewBackupCodes(String code) =>
      caller.callServerEndpoint<List<String>>(
        'twoFactor',
        'renewBackupCodes',
        {'code': code},
      );

  _ida.Future<void> disable(String code) => caller.callServerEndpoint<void>(
    'twoFactor',
    'disable',
    {'code': code},
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    account = EndpointAccount(this);
    admin = EndpointAdmin(this);
    advisor = EndpointAdvisor(this);
    ai = EndpointAi(this);
    analysis = EndpointAnalysis(this);
    category = EndpointCategory(this);
    export = EndpointExport(this);
    feedback = EndpointFeedback(this);
    goal = EndpointGoal(this);
    group = EndpointGroup(this);
    import = EndpointImport(this);
    invitation = EndpointInvitation(this);
    invoice = EndpointInvoice(this);
    loan = EndpointLoan(this);
    mcp = EndpointMcp(this);
    notification = EndpointNotification(this);
    rule = EndpointRule(this);
    scheduled = EndpointScheduled(this);
    setup = EndpointSetup(this);
    transaction = EndpointTransaction(this);
    transfer = EndpointTransfer(this);
    twoFactor = EndpointTwoFactor(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAccount account;

  late final EndpointAdmin admin;

  late final EndpointAdvisor advisor;

  late final EndpointAi ai;

  late final EndpointAnalysis analysis;

  late final EndpointCategory category;

  late final EndpointExport export;

  late final EndpointFeedback feedback;

  late final EndpointGoal goal;

  late final EndpointGroup group;

  late final EndpointImport import;

  late final EndpointInvitation invitation;

  late final EndpointInvoice invoice;

  late final EndpointLoan loan;

  late final EndpointMcp mcp;

  late final EndpointNotification notification;

  late final EndpointRule rule;

  late final EndpointScheduled scheduled;

  late final EndpointSetup setup;

  late final EndpointTransaction transaction;

  late final EndpointTransfer transfer;

  late final EndpointTwoFactor twoFactor;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'account': account,
    'admin': admin,
    'advisor': advisor,
    'ai': ai,
    'analysis': analysis,
    'category': category,
    'export': export,
    'feedback': feedback,
    'goal': goal,
    'group': group,
    'import': import,
    'invitation': invitation,
    'invoice': invoice,
    'loan': loan,
    'mcp': mcp,
    'notification': notification,
    'rule': rule,
    'scheduled': scheduled,
    'setup': setup,
    'transaction': transaction,
    'transfer': transfer,
    'twoFactor': twoFactor,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
