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
import 'package:owncoffer_server/src/generated/account_kind.dart' as _ihbhvzqt;
import 'package:owncoffer_server/src/generated/account_visibility.dart'
    as _ioa13f9g;
import 'package:owncoffer_server/src/generated/member_role.dart' as _is2flj8o;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/account_endpoint.dart' as _iaho7ul5;
import '../endpoints/admin_endpoint.dart' as _i5t1w2d2;
import '../endpoints/group_endpoint.dart' as _iknqvl2r;
import '../endpoints/invitation_endpoint.dart' as _iipval89;
import '../endpoints/setup_endpoint.dart' as _i5xhv8r1;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'account': _iaho7ul5.AccountEndpoint()
        ..initialize(
          server,
          'account',
          null,
        ),
      'admin': _i5t1w2d2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'group': _iknqvl2r.GroupEndpoint()
        ..initialize(
          server,
          'group',
          null,
        ),
      'invitation': _iipval89.InvitationEndpoint()
        ..initialize(
          server,
          'invitation',
          null,
        ),
      'setup': _i5xhv8r1.SetupEndpoint()
        ..initialize(
          server,
          'setup',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['account'] = _is.EndpointConnector(
      name: 'account',
      endpoint: endpoints['account']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _iaho7ul5.AccountEndpoint).list(
                    session,
                    params['groupId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'kind': _is.ParameterDescription(
              name: 'kind',
              type: _is.getType<_ihbhvzqt.AccountKind>(),
              nullable: false,
            ),
            'bank': _is.ParameterDescription(
              name: 'bank',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'initialBalanceCents': _is.ParameterDescription(
              name: 'initialBalanceCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'initialBalanceDate': _is.ParameterDescription(
              name: 'initialBalanceDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'alertThresholdCents': _is.ParameterDescription(
              name: 'alertThresholdCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'visibility': _is.ParameterDescription(
              name: 'visibility',
              type: _is.getType<_ioa13f9g.AccountVisibility?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _iaho7ul5.AccountEndpoint).create(
                    session,
                    params['groupId'],
                    params['name'],
                    params['kind'],
                    bank: params['bank'],
                    initialBalanceCents: params['initialBalanceCents'],
                    initialBalanceDate: params['initialBalanceDate'],
                    alertThresholdCents: params['alertThresholdCents'],
                    visibility: params['visibility'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'bank': _is.ParameterDescription(
              name: 'bank',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'initialBalanceCents': _is.ParameterDescription(
              name: 'initialBalanceCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'initialBalanceDate': _is.ParameterDescription(
              name: 'initialBalanceDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'alertThresholdCents': _is.ParameterDescription(
              name: 'alertThresholdCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'visibility': _is.ParameterDescription(
              name: 'visibility',
              type: _is.getType<_ioa13f9g.AccountVisibility?>(),
              nullable: true,
            ),
            'color': _is.ParameterDescription(
              name: 'color',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _iaho7ul5.AccountEndpoint).update(
                    session,
                    params['accountId'],
                    name: params['name'],
                    bank: params['bank'],
                    initialBalanceCents: params['initialBalanceCents'],
                    initialBalanceDate: params['initialBalanceDate'],
                    alertThresholdCents: params['alertThresholdCents'],
                    visibility: params['visibility'],
                    color: params['color'],
                  ),
        ),
        'archive': _is.MethodConnector(
          name: 'archive',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _iaho7ul5.AccountEndpoint).archive(
                    session,
                    params['accountId'],
                  ),
        ),
        'setAccess': _is.MethodConnector(
          name: 'setAccess',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'allowed': _is.ParameterDescription(
              name: 'allowed',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['account'] as _iaho7ul5.AccountEndpoint).setAccess(
                    session,
                    params['accountId'],
                    params['userId'],
                    params['allowed'],
                  ),
        ),
      },
    );
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'bannedIps': _is.MethodConnector(
          name: 'bannedIps',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .bannedIps(session),
        ),
        'unbanIp': _is.MethodConnector(
          name: 'unbanIp',
          params: {
            'ip': _is.ParameterDescription(
              name: 'ip',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).unbanIp(
                    session,
                    params['ip'],
                  ),
        ),
      },
    );
    connectors['group'] = _is.EndpointConnector(
      name: 'group',
      endpoint: endpoints['group']!,
      methodConnectors: {
        'myGroups': _is.MethodConnector(
          name: 'myGroups',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['group'] as _iknqvl2r.GroupEndpoint)
                  .myGroups(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['group'] as _iknqvl2r.GroupEndpoint).create(
                session,
                params['name'],
              ),
        ),
        'rename': _is.MethodConnector(
          name: 'rename',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['group'] as _iknqvl2r.GroupEndpoint).rename(
                session,
                params['groupId'],
                params['name'],
              ),
        ),
        'members': _is.MethodConnector(
          name: 'members',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['group'] as _iknqvl2r.GroupEndpoint).members(
                    session,
                    params['groupId'],
                  ),
        ),
        'setRole': _is.MethodConnector(
          name: 'setRole',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'memberUserId': _is.ParameterDescription(
              name: 'memberUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_is2flj8o.MemberRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['group'] as _iknqvl2r.GroupEndpoint).setRole(
                    session,
                    params['groupId'],
                    params['memberUserId'],
                    params['role'],
                  ),
        ),
        'removeMember': _is.MethodConnector(
          name: 'removeMember',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'memberUserId': _is.ParameterDescription(
              name: 'memberUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['group'] as _iknqvl2r.GroupEndpoint).removeMember(
                    session,
                    params['groupId'],
                    params['memberUserId'],
                  ),
        ),
      },
    );
    connectors['invitation'] = _is.EndpointConnector(
      name: 'invitation',
      endpoint: endpoints['invitation']!,
      methodConnectors: {
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_is2flj8o.MemberRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invitation'] as _iipval89.InvitationEndpoint)
                      .create(
                        session,
                        params['groupId'],
                        params['email'],
                        params['role'],
                      ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invitation'] as _iipval89.InvitationEndpoint)
                      .list(
                        session,
                        params['groupId'],
                      ),
        ),
        'revoke': _is.MethodConnector(
          name: 'revoke',
          params: {
            'invitationId': _is.ParameterDescription(
              name: 'invitationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invitation'] as _iipval89.InvitationEndpoint)
                      .revoke(
                        session,
                        params['invitationId'],
                      ),
        ),
        'accept': _is.MethodConnector(
          name: 'accept',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['invitation'] as _iipval89.InvitationEndpoint)
                      .accept(
                        session,
                        params['token'],
                      ),
        ),
      },
    );
    connectors['setup'] = _is.EndpointConnector(
      name: 'setup',
      endpoint: endpoints['setup']!,
      methodConnectors: {
        'status': _is.MethodConnector(
          name: 'status',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['setup'] as _i5xhv8r1.SetupEndpoint).status(
                session,
              ),
        ),
        'start': _is.MethodConnector(
          name: 'start',
          params: {
            'setupCode': _is.ParameterDescription(
              name: 'setupCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['setup'] as _i5xhv8r1.SetupEndpoint).start(
                session,
                params['setupCode'],
                params['email'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
