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
import 'package:http/http.dart' as _i85jenna;
import 'package:owncoffer_client/src/protocol/account.dart' as _i4motmly;
import 'package:owncoffer_client/src/protocol/account_kind.dart' as _ighjli9i;
import 'package:owncoffer_client/src/protocol/account_visibility.dart'
    as _i33sijhq;
import 'package:owncoffer_client/src/protocol/finance_group.dart' as _izr9v441;
import 'package:owncoffer_client/src/protocol/group_member.dart' as _il25bams;
import 'package:owncoffer_client/src/protocol/group_membership.dart'
    as _itelwlzo;
import 'package:owncoffer_client/src/protocol/invitation_info.dart'
    as _i2judacm;
import 'package:owncoffer_client/src/protocol/ip_ban_info.dart' as _ivw6xhv3;
import 'package:owncoffer_client/src/protocol/member_role.dart' as _ibbiwcdo;
import 'package:owncoffer_client/src/protocol/setup_status.dart' as _iayy8tg9;
import 'package:owncoffer_client/src/protocol/totp_enrollment.dart'
    as _iy6m3xur;
import 'package:owncoffer_client/src/protocol/two_factor_status.dart'
    as _is1jzs1l;
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
}

/// Server administration (server administrator only).
/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

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

  /// Members of the group (any member may see who else is in it).
  _ida.Future<List<_il25bams.GroupMember>> members(int groupId) =>
      caller.callServerEndpoint<List<_il25bams.GroupMember>>(
        'group',
        'members',
        {'groupId': groupId},
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
    group = EndpointGroup(this);
    invitation = EndpointInvitation(this);
    setup = EndpointSetup(this);
    twoFactor = EndpointTwoFactor(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAccount account;

  late final EndpointAdmin admin;

  late final EndpointGroup group;

  late final EndpointInvitation invitation;

  late final EndpointSetup setup;

  late final EndpointTwoFactor twoFactor;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'account': account,
    'admin': admin,
    'group': group,
    'invitation': invitation,
    'setup': setup,
    'twoFactor': twoFactor,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
