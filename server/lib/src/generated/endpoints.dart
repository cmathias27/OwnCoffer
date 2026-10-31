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
import 'dart:typed_data' as _idt;
import 'package:owncoffer_server/src/generated/account_kind.dart' as _ihbhvzqt;
import 'package:owncoffer_server/src/generated/account_visibility.dart'
    as _ioa13f9g;
import 'package:owncoffer_server/src/generated/budget_period.dart' as _imscipj7;
import 'package:owncoffer_server/src/generated/category_kind.dart' as _io27ugya;
import 'package:owncoffer_server/src/generated/category_source.dart'
    as _is85mlpa;
import 'package:owncoffer_server/src/generated/csv_columns.dart' as _iytxq8gu;
import 'package:owncoffer_server/src/generated/frequency.dart' as _iugtcrzz;
import 'package:owncoffer_server/src/generated/loan.dart' as _i2yv792g;
import 'package:owncoffer_server/src/generated/member_role.dart' as _is2flj8o;
import 'package:owncoffer_server/src/generated/rule_direction.dart'
    as _ini8nmtb;
import 'package:owncoffer_server/src/generated/rule_match_type.dart'
    as _ijwgwf7y;
import 'package:owncoffer_server/src/generated/transaction_split.dart'
    as _i84rsuuz;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/account_endpoint.dart' as _iaho7ul5;
import '../endpoints/admin_endpoint.dart' as _i5t1w2d2;
import '../endpoints/analysis_endpoint.dart' as _i0sl0qub;
import '../endpoints/category_endpoint.dart' as _ioevag4g;
import '../endpoints/goal_endpoint.dart' as _i2k4izhk;
import '../endpoints/group_endpoint.dart' as _iknqvl2r;
import '../endpoints/import_endpoint.dart' as _i51ek8od;
import '../endpoints/invitation_endpoint.dart' as _iipval89;
import '../endpoints/loan_endpoint.dart' as _imitaxsf;
import '../endpoints/notification_endpoint.dart' as _ihb11yhk;
import '../endpoints/rule_endpoint.dart' as _i1yhvvjn;
import '../endpoints/scheduled_endpoint.dart' as _ip6habnq;
import '../endpoints/setup_endpoint.dart' as _i5xhv8r1;
import '../endpoints/transaction_endpoint.dart' as _iyokctnp;
import '../endpoints/two_factor_endpoint.dart' as _ivxdn6q3;

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
      'analysis': _i0sl0qub.AnalysisEndpoint()
        ..initialize(
          server,
          'analysis',
          null,
        ),
      'category': _ioevag4g.CategoryEndpoint()
        ..initialize(
          server,
          'category',
          null,
        ),
      'goal': _i2k4izhk.GoalEndpoint()
        ..initialize(
          server,
          'goal',
          null,
        ),
      'group': _iknqvl2r.GroupEndpoint()
        ..initialize(
          server,
          'group',
          null,
        ),
      'import': _i51ek8od.ImportEndpoint()
        ..initialize(
          server,
          'import',
          null,
        ),
      'invitation': _iipval89.InvitationEndpoint()
        ..initialize(
          server,
          'invitation',
          null,
        ),
      'loan': _imitaxsf.LoanEndpoint()
        ..initialize(
          server,
          'loan',
          null,
        ),
      'notification': _ihb11yhk.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'rule': _i1yhvvjn.RuleEndpoint()
        ..initialize(
          server,
          'rule',
          null,
        ),
      'scheduled': _ip6habnq.ScheduledEndpoint()
        ..initialize(
          server,
          'scheduled',
          null,
        ),
      'setup': _i5xhv8r1.SetupEndpoint()
        ..initialize(
          server,
          'setup',
          null,
        ),
      'transaction': _iyokctnp.TransactionEndpoint()
        ..initialize(
          server,
          'transaction',
          null,
        ),
      'twoFactor': _ivxdn6q3.TwoFactorEndpoint()
        ..initialize(
          server,
          'twoFactor',
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
        'checkBalance': _is.MethodConnector(
          name: 'checkBalance',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'bankBalanceCents': _is.ParameterDescription(
              name: 'bankBalanceCents',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _iaho7ul5.AccountEndpoint)
                  .checkBalance(
                    session,
                    params['accountId'],
                    params['date'],
                    params['bankBalanceCents'],
                  ),
        ),
        'balanceChecks': _is.MethodConnector(
          name: 'balanceChecks',
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
              ) async => (endpoints['account'] as _iaho7ul5.AccountEndpoint)
                  .balanceChecks(
                    session,
                    params['accountId'],
                  ),
        ),
      },
    );
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'isServerAdmin': _is.MethodConnector(
          name: 'isServerAdmin',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .isServerAdmin(session),
        ),
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
        'users': _is.MethodConnector(
          name: 'users',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).users(
                session,
              ),
        ),
        'setBlocked': _is.MethodConnector(
          name: 'setBlocked',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'blocked': _is.ParameterDescription(
              name: 'blocked',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).setBlocked(
                    session,
                    params['authUserId'],
                    params['blocked'],
                  ),
        ),
        'health': _is.MethodConnector(
          name: 'health',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).health(
                session,
              ),
        ),
        'stats': _is.MethodConnector(
          name: 'stats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).stats(
                session,
              ),
        ),
        'audit': _is.MethodConnector(
          name: 'audit',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).audit(
                session,
                limit: params['limit'],
                offset: params['offset'],
              ),
        ),
        'sendTestEmail': _is.MethodConnector(
          name: 'sendTestEmail',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .sendTestEmail(session),
        ),
      },
    );
    connectors['analysis'] = _is.EndpointConnector(
      name: 'analysis',
      endpoint: endpoints['analysis']!,
      methodConnectors: {
        'report': _is.MethodConnector(
          name: 'report',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'period': _is.ParameterDescription(
              name: 'period',
              type: _is.getType<_imscipj7.BudgetPeriod>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['analysis'] as _i0sl0qub.AnalysisEndpoint).report(
                    session,
                    params['groupId'],
                    params['period'],
                    params['date'],
                    accountId: params['accountId'],
                  ),
        ),
        'operations': _is.MethodConnector(
          name: 'operations',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'period': _is.ParameterDescription(
              name: 'period',
              type: _is.getType<_imscipj7.BudgetPeriod>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'unclassified': _is.ParameterDescription(
              name: 'unclassified',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analysis'] as _i0sl0qub.AnalysisEndpoint)
                  .operations(
                    session,
                    params['groupId'],
                    params['period'],
                    params['date'],
                    categoryId: params['categoryId'],
                    unclassified: params['unclassified'],
                    accountId: params['accountId'],
                  ),
        ),
        'leftToLive': _is.MethodConnector(
          name: 'leftToLive',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analysis'] as _i0sl0qub.AnalysisEndpoint)
                  .leftToLive(
                    session,
                    params['groupId'],
                    accountId: params['accountId'],
                  ),
        ),
        'review': _is.MethodConnector(
          name: 'review',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['analysis'] as _i0sl0qub.AnalysisEndpoint).review(
                    session,
                    params['groupId'],
                    params['date'],
                    accountId: params['accountId'],
                  ),
        ),
      },
    );
    connectors['category'] = _is.EndpointConnector(
      name: 'category',
      endpoint: endpoints['category']!,
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
                  (endpoints['category'] as _ioevag4g.CategoryEndpoint).list(
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
              type: _is.getType<_io27ugya.CategoryKind>(),
              nullable: false,
            ),
            'parentId': _is.ParameterDescription(
              name: 'parentId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'standardCode': _is.ParameterDescription(
              name: 'standardCode',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['category'] as _ioevag4g.CategoryEndpoint).create(
                    session,
                    params['groupId'],
                    params['name'],
                    params['kind'],
                    parentId: params['parentId'],
                    standardCode: params['standardCode'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'resetName': _is.ParameterDescription(
              name: 'resetName',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'standardCode': _is.ParameterDescription(
              name: 'standardCode',
              type: _is.getType<String?>(),
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
                  (endpoints['category'] as _ioevag4g.CategoryEndpoint).update(
                    session,
                    params['categoryId'],
                    name: params['name'],
                    resetName: params['resetName'],
                    standardCode: params['standardCode'],
                    color: params['color'],
                  ),
        ),
        'archive': _is.MethodConnector(
          name: 'archive',
          params: {
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['category'] as _ioevag4g.CategoryEndpoint).archive(
                    session,
                    params['categoryId'],
                  ),
        ),
      },
    );
    connectors['goal'] = _is.EndpointConnector(
      name: 'goal',
      endpoint: endpoints['goal']!,
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
              ) async => (endpoints['goal'] as _i2k4izhk.GoalEndpoint).list(
                session,
                params['groupId'],
              ),
        ),
        'set': _is.MethodConnector(
          name: 'set',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i2k4izhk.GoalEndpoint).set(
                session,
                params['groupId'],
                params['categoryId'],
                params['amountCents'],
              ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['goal'] as _i2k4izhk.GoalEndpoint).remove(
                session,
                params['groupId'],
                params['categoryId'],
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
        'setMonthStartDay': _is.MethodConnector(
          name: 'setMonthStartDay',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'day': _is.ParameterDescription(
              name: 'day',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['group'] as _iknqvl2r.GroupEndpoint)
                  .setMonthStartDay(
                    session,
                    params['groupId'],
                    params['day'],
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
    connectors['import'] = _is.EndpointConnector(
      name: 'import',
      endpoint: endpoints['import']!,
      methodConnectors: {
        'preview': _is.MethodConnector(
          name: 'preview',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'file': _is.ParameterDescription(
              name: 'file',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
            'columns': _is.ParameterDescription(
              name: 'columns',
              type: _is.getType<_iytxq8gu.CsvColumns?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['import'] as _i51ek8od.ImportEndpoint).preview(
                    session,
                    params['accountId'],
                    params['file'],
                    columns: params['columns'],
                  ),
        ),
        'commit': _is.MethodConnector(
          name: 'commit',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'file': _is.ParameterDescription(
              name: 'file',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
            'columns': _is.ParameterDescription(
              name: 'columns',
              type: _is.getType<_iytxq8gu.CsvColumns?>(),
              nullable: true,
            ),
            'acceptedPossibleDuplicates': _is.ParameterDescription(
              name: 'acceptedPossibleDuplicates',
              type: _is.getType<List<int>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['import'] as _i51ek8od.ImportEndpoint).commit(
                    session,
                    params['accountId'],
                    params['fileName'],
                    params['file'],
                    columns: params['columns'],
                    acceptedPossibleDuplicates:
                        params['acceptedPossibleDuplicates'],
                  ),
        ),
        'history': _is.MethodConnector(
          name: 'history',
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
                  (endpoints['import'] as _i51ek8od.ImportEndpoint).history(
                    session,
                    params['accountId'],
                  ),
        ),
        'cancel': _is.MethodConnector(
          name: 'cancel',
          params: {
            'importId': _is.ParameterDescription(
              name: 'importId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['import'] as _i51ek8od.ImportEndpoint).cancel(
                    session,
                    params['importId'],
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
    connectors['loan'] = _is.EndpointConnector(
      name: 'loan',
      endpoint: endpoints['loan']!,
      methodConnectors: {
        'overview': _is.MethodConnector(
          name: 'overview',
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
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint).overview(
                session,
                params['groupId'],
              ),
        ),
        'schedule': _is.MethodConnector(
          name: 'schedule',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint).schedule(
                session,
                params['loanId'],
              ),
        ),
        'operations': _is.MethodConnector(
          name: 'operations',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loan'] as _imitaxsf.LoanEndpoint).operations(
                    session,
                    params['loanId'],
                  ),
        ),
        'documents': _is.MethodConnector(
          name: 'documents',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loan'] as _imitaxsf.LoanEndpoint).documents(
                    session,
                    params['loanId'],
                  ),
        ),
        'uploadDocument': _is.MethodConnector(
          name: 'uploadDocument',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'file': _is.ParameterDescription(
              name: 'file',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loan'] as _imitaxsf.LoanEndpoint).uploadDocument(
                    session,
                    params['loanId'],
                    params['fileName'],
                    params['file'],
                  ),
        ),
        'downloadDocument': _is.MethodConnector(
          name: 'downloadDocument',
          params: {
            'documentId': _is.ParameterDescription(
              name: 'documentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint)
                  .downloadDocument(
                    session,
                    params['documentId'],
                  ),
        ),
        'deleteDocument': _is.MethodConnector(
          name: 'deleteDocument',
          params: {
            'documentId': _is.ParameterDescription(
              name: 'documentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loan'] as _imitaxsf.LoanEndpoint).deleteDocument(
                    session,
                    params['documentId'],
                  ),
        ),
        'simulate': _is.MethodConnector(
          name: 'simulate',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint).simulate(
                session,
                params['loanId'],
                params['amountCents'],
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
            'loan': _is.ParameterDescription(
              name: 'loan',
              type: _is.getType<_i2yv792g.Loan>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint).create(
                session,
                params['groupId'],
                params['loan'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'loan': _is.ParameterDescription(
              name: 'loan',
              type: _is.getType<_i2yv792g.Loan>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint).update(
                session,
                params['loan'],
              ),
        ),
        'createFromTransaction': _is.MethodConnector(
          name: 'createFromTransaction',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'loan': _is.ParameterDescription(
              name: 'loan',
              type: _is.getType<_i2yv792g.Loan>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint)
                  .createFromTransaction(
                    session,
                    params['transactionId'],
                    params['loan'],
                  ),
        ),
        'attachTransaction': _is.MethodConnector(
          name: 'attachTransaction',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint)
                  .attachTransaction(
                    session,
                    params['loanId'],
                    params['transactionId'],
                  ),
        ),
        'undoAttach': _is.MethodConnector(
          name: 'undoAttach',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'ruleId': _is.ParameterDescription(
              name: 'ruleId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loan'] as _imitaxsf.LoanEndpoint).undoAttach(
                    session,
                    params['loanId'],
                    params['transactionId'],
                    ruleId: params['ruleId'],
                  ),
        ),
        'undoCreate': _is.MethodConnector(
          name: 'undoCreate',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['loan'] as _imitaxsf.LoanEndpoint).undoCreate(
                    session,
                    params['loanId'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'loanId': _is.ParameterDescription(
              name: 'loanId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['loan'] as _imitaxsf.LoanEndpoint).delete(
                session,
                params['loanId'],
              ),
        ),
      },
    );
    connectors['notification'] = _is.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'unreadOnly': _is.ParameterDescription(
              name: 'unreadOnly',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .list(
                        session,
                        unreadOnly: params['unreadOnly'],
                      ),
        ),
        'unreadCount': _is.MethodConnector(
          name: 'unreadCount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .unreadCount(session),
        ),
        'markRead': _is.MethodConnector(
          name: 'markRead',
          params: {
            'notificationId': _is.ParameterDescription(
              name: 'notificationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .markRead(
                        session,
                        params['notificationId'],
                      ),
        ),
        'markAllRead': _is.MethodConnector(
          name: 'markAllRead',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .markAllRead(session),
        ),
      },
    );
    connectors['rule'] = _is.EndpointConnector(
      name: 'rule',
      endpoint: endpoints['rule']!,
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
              ) async => (endpoints['rule'] as _i1yhvvjn.RuleEndpoint).list(
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
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pattern': _is.ParameterDescription(
              name: 'pattern',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'matchType': _is.ParameterDescription(
              name: 'matchType',
              type: _is.getType<_ijwgwf7y.RuleMatchType>(),
              nullable: false,
            ),
            'direction': _is.ParameterDescription(
              name: 'direction',
              type: _is.getType<_ini8nmtb.RuleDirection?>(),
              nullable: true,
            ),
            'minAbsCents': _is.ParameterDescription(
              name: 'minAbsCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'maxAbsCents': _is.ParameterDescription(
              name: 'maxAbsCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'priority': _is.ParameterDescription(
              name: 'priority',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rule'] as _i1yhvvjn.RuleEndpoint).create(
                session,
                params['groupId'],
                params['categoryId'],
                params['pattern'],
                params['matchType'],
                direction: params['direction'],
                minAbsCents: params['minAbsCents'],
                maxAbsCents: params['maxAbsCents'],
                priority: params['priority'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'ruleId': _is.ParameterDescription(
              name: 'ruleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'pattern': _is.ParameterDescription(
              name: 'pattern',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'matchType': _is.ParameterDescription(
              name: 'matchType',
              type: _is.getType<_ijwgwf7y.RuleMatchType?>(),
              nullable: true,
            ),
            'direction': _is.ParameterDescription(
              name: 'direction',
              type: _is.getType<_ini8nmtb.RuleDirection?>(),
              nullable: true,
            ),
            'minAbsCents': _is.ParameterDescription(
              name: 'minAbsCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'maxAbsCents': _is.ParameterDescription(
              name: 'maxAbsCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'clearAmounts': _is.ParameterDescription(
              name: 'clearAmounts',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'priority': _is.ParameterDescription(
              name: 'priority',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'enabled': _is.ParameterDescription(
              name: 'enabled',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rule'] as _i1yhvvjn.RuleEndpoint).update(
                session,
                params['ruleId'],
                categoryId: params['categoryId'],
                pattern: params['pattern'],
                matchType: params['matchType'],
                direction: params['direction'],
                minAbsCents: params['minAbsCents'],
                maxAbsCents: params['maxAbsCents'],
                clearAmounts: params['clearAmounts'],
                priority: params['priority'],
                enabled: params['enabled'],
              ),
        ),
        'undoCreate': _is.MethodConnector(
          name: 'undoCreate',
          params: {
            'ruleId': _is.ParameterDescription(
              name: 'ruleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rule'] as _i1yhvvjn.RuleEndpoint).undoCreate(
                    session,
                    params['ruleId'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'ruleId': _is.ParameterDescription(
              name: 'ruleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rule'] as _i1yhvvjn.RuleEndpoint).delete(
                session,
                params['ruleId'],
              ),
        ),
        'tryLabel': _is.MethodConnector(
          name: 'tryLabel',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'label': _is.ParameterDescription(
              name: 'label',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rule'] as _i1yhvvjn.RuleEndpoint).tryLabel(
                session,
                params['groupId'],
                params['label'],
                params['amountCents'],
              ),
        ),
      },
    );
    connectors['scheduled'] = _is.EndpointConnector(
      name: 'scheduled',
      endpoint: endpoints['scheduled']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
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
                  (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint).list(
                    session,
                    params['accountId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'label': _is.ParameterDescription(
              name: 'label',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'frequency': _is.ParameterDescription(
              name: 'frequency',
              type: _is.getType<_iugtcrzz.ScheduleFrequency>(),
              nullable: false,
            ),
            'startDate': _is.ParameterDescription(
              name: 'startDate',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'interval': _is.ParameterDescription(
              name: 'interval',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'endDate': _is.ParameterDescription(
              name: 'endDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'occurrenceCount': _is.ParameterDescription(
              name: 'occurrenceCount',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'matchPattern': _is.ParameterDescription(
              name: 'matchPattern',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'dateToleranceDays': _is.ParameterDescription(
              name: 'dateToleranceDays',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'amountTolerancePercent': _is.ParameterDescription(
              name: 'amountTolerancePercent',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'subscription': _is.ParameterDescription(
              name: 'subscription',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .create(
                    session,
                    params['accountId'],
                    params['amountCents'],
                    params['label'],
                    params['frequency'],
                    params['startDate'],
                    interval: params['interval'],
                    endDate: params['endDate'],
                    occurrenceCount: params['occurrenceCount'],
                    categoryId: params['categoryId'],
                    matchPattern: params['matchPattern'],
                    dateToleranceDays: params['dateToleranceDays'],
                    amountTolerancePercent: params['amountTolerancePercent'],
                    subscription: params['subscription'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'scheduledId': _is.ParameterDescription(
              name: 'scheduledId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'label': _is.ParameterDescription(
              name: 'label',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'endDate': _is.ParameterDescription(
              name: 'endDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'matchPattern': _is.ParameterDescription(
              name: 'matchPattern',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'dateToleranceDays': _is.ParameterDescription(
              name: 'dateToleranceDays',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'amountTolerancePercent': _is.ParameterDescription(
              name: 'amountTolerancePercent',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'subscription': _is.ParameterDescription(
              name: 'subscription',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .update(
                    session,
                    params['scheduledId'],
                    amountCents: params['amountCents'],
                    label: params['label'],
                    categoryId: params['categoryId'],
                    endDate: params['endDate'],
                    matchPattern: params['matchPattern'],
                    dateToleranceDays: params['dateToleranceDays'],
                    amountTolerancePercent: params['amountTolerancePercent'],
                    subscription: params['subscription'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'scheduledId': _is.ParameterDescription(
              name: 'scheduledId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .delete(
                    session,
                    params['scheduledId'],
                  ),
        ),
        'subscriptions': _is.MethodConnector(
          name: 'subscriptions',
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
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .subscriptions(
                    session,
                    params['groupId'],
                  ),
        ),
        'subscribeFrom': _is.MethodConnector(
          name: 'subscribeFrom',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'frequency': _is.ParameterDescription(
              name: 'frequency',
              type: _is.getType<_iugtcrzz.ScheduleFrequency?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .subscribeFrom(
                    session,
                    params['transactionId'],
                    frequency: params['frequency'],
                  ),
        ),
        'calendar': _is.MethodConnector(
          name: 'calendar',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .calendar(
                    session,
                    params['groupId'],
                    params['date'],
                    accountId: params['accountId'],
                  ),
        ),
        'skipNext': _is.MethodConnector(
          name: 'skipNext',
          params: {
            'scheduledId': _is.ParameterDescription(
              name: 'scheduledId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .skipNext(
                    session,
                    params['scheduledId'],
                  ),
        ),
        'forecast': _is.MethodConnector(
          name: 'forecast',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'today': _is.ParameterDescription(
              name: 'today',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'horizonDays': _is.ParameterDescription(
              name: 'horizonDays',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'includeVariable': _is.ParameterDescription(
              name: 'includeVariable',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .forecast(
                    session,
                    params['accountId'],
                    params['today'],
                    horizonDays: params['horizonDays'],
                    includeVariable: params['includeVariable'],
                  ),
        ),
        'simulatePurchase': _is.MethodConnector(
          name: 'simulatePurchase',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'today': _is.ParameterDescription(
              name: 'today',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'target': _is.ParameterDescription(
              name: 'target',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'includeVariable': _is.ParameterDescription(
              name: 'includeVariable',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .simulatePurchase(
                    session,
                    params['accountId'],
                    params['today'],
                    params['amountCents'],
                    params['date'],
                    params['target'],
                    categoryId: params['categoryId'],
                    includeVariable: params['includeVariable'],
                  ),
        ),
        'confirmMatch': _is.MethodConnector(
          name: 'confirmMatch',
          params: {
            'scheduledId': _is.ParameterDescription(
              name: 'scheduledId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'dueDate': _is.ParameterDescription(
              name: 'dueDate',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['scheduled'] as _ip6habnq.ScheduledEndpoint)
                  .confirmMatch(
                    session,
                    params['scheduledId'],
                    params['dueDate'],
                    params['transactionId'],
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
    connectors['transaction'] = _is.EndpointConnector(
      name: 'transaction',
      endpoint: endpoints['transaction']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'search': _is.ParameterDescription(
              name: 'search',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'sameLabel': _is.ParameterDescription(
              name: 'sameLabel',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'includeSubcategories': _is.ParameterDescription(
              name: 'includeSubcategories',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'toClassify': _is.ParameterDescription(
              name: 'toClassify',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'uncleared': _is.ParameterDescription(
              name: 'uncleared',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'subscriptions': _is.ParameterDescription(
              name: 'subscriptions',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .list(
                        session,
                        params['accountId'],
                        from: params['from'],
                        to: params['to'],
                        search: params['search'],
                        sameLabel: params['sameLabel'],
                        categoryId: params['categoryId'],
                        includeSubcategories: params['includeSubcategories'],
                        toClassify: params['toClassify'],
                        uncleared: params['uncleared'],
                        subscriptions: params['subscriptions'],
                        limit: params['limit'],
                        offset: params['offset'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'accountId': _is.ParameterDescription(
              name: 'accountId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'label': _is.ParameterDescription(
              name: 'label',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .create(
                        session,
                        params['accountId'],
                        params['date'],
                        params['amountCents'],
                        params['label'],
                        note: params['note'],
                        categoryId: params['categoryId'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'date': _is.ParameterDescription(
              name: 'date',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'amountCents': _is.ParameterDescription(
              name: 'amountCents',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'label': _is.ParameterDescription(
              name: 'label',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .update(
                        session,
                        params['transactionId'],
                        date: params['date'],
                        amountCents: params['amountCents'],
                        label: params['label'],
                        note: params['note'],
                      ),
        ),
        'setCategory': _is.MethodConnector(
          name: 'setCategory',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .setCategory(
                        session,
                        params['transactionId'],
                        params['categoryId'],
                      ),
        ),
        'restoreClassification': _is.MethodConnector(
          name: 'restoreClassification',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<_is85mlpa.CategorySource>(),
              nullable: false,
            ),
            'ruleRef': _is.ParameterDescription(
              name: 'ruleRef',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'splits': _is.ParameterDescription(
              name: 'splits',
              type: _is.getType<List<_i84rsuuz.TransactionSplit>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .restoreClassification(
                        session,
                        params['transactionId'],
                        params['categoryId'],
                        params['source'],
                        params['ruleRef'],
                        params['splits'],
                      ),
        ),
        'splits': _is.MethodConnector(
          name: 'splits',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .splits(
                        session,
                        params['transactionId'],
                      ),
        ),
        'setSplits': _is.MethodConnector(
          name: 'setSplits',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'parts': _is.ParameterDescription(
              name: 'parts',
              type: _is.getType<List<_i84rsuuz.TransactionSplit>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .setSplits(
                        session,
                        params['transactionId'],
                        params['parts'],
                      ),
        ),
        'setCleared': _is.MethodConnector(
          name: 'setCleared',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'cleared': _is.ParameterDescription(
              name: 'cleared',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .setCleared(
                        session,
                        params['transactionId'],
                        params['cleared'],
                      ),
        ),
        'trash': _is.MethodConnector(
          name: 'trash',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .trash(
                        session,
                        params['transactionId'],
                      ),
        ),
        'restore': _is.MethodConnector(
          name: 'restore',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .restore(
                        session,
                        params['transactionId'],
                      ),
        ),
        'createRuleFrom': _is.MethodConnector(
          name: 'createRuleFrom',
          params: {
            'transactionId': _is.ParameterDescription(
              name: 'transactionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'categoryId': _is.ParameterDescription(
              name: 'categoryId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'matchType': _is.ParameterDescription(
              name: 'matchType',
              type: _is.getType<_ijwgwf7y.RuleMatchType?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _iyokctnp.TransactionEndpoint)
                      .createRuleFrom(
                        session,
                        params['transactionId'],
                        params['categoryId'],
                        matchType: params['matchType'],
                      ),
        ),
      },
    );
    connectors['twoFactor'] = _is.EndpointConnector(
      name: 'twoFactor',
      endpoint: endpoints['twoFactor']!,
      methodConnectors: {
        'status': _is.MethodConnector(
          name: 'status',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _ivxdn6q3.TwoFactorEndpoint)
                  .status(session),
        ),
        'begin': _is.MethodConnector(
          name: 'begin',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _ivxdn6q3.TwoFactorEndpoint)
                  .begin(session),
        ),
        'confirm': _is.MethodConnector(
          name: 'confirm',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _ivxdn6q3.TwoFactorEndpoint)
                  .confirm(
                    session,
                    params['code'],
                  ),
        ),
        'verify': _is.MethodConnector(
          name: 'verify',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _ivxdn6q3.TwoFactorEndpoint)
                  .verify(
                    session,
                    params['code'],
                  ),
        ),
        'renewBackupCodes': _is.MethodConnector(
          name: 'renewBackupCodes',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _ivxdn6q3.TwoFactorEndpoint)
                  .renewBackupCodes(
                    session,
                    params['code'],
                  ),
        ),
        'disable': _is.MethodConnector(
          name: 'disable',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['twoFactor'] as _ivxdn6q3.TwoFactorEndpoint)
                  .disable(
                    session,
                    params['code'],
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
