/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:owncoffer_server/src/generated/account.dart' as _iul9ey3g;
import 'package:owncoffer_server/src/generated/category.dart' as _iemw1gpx;
import 'package:owncoffer_server/src/generated/group_membership.dart'
    as _idq93byd;
import 'package:owncoffer_server/src/generated/invitation_info.dart'
    as _ip1vy3u6;
import 'package:owncoffer_server/src/generated/ip_ban_info.dart' as _itqry2jn;
import 'package:owncoffer_server/src/generated/member_info.dart' as _ipfe689d;
import 'package:owncoffer_server/src/generated/notification.dart' as _ieap9unx;
import 'package:owncoffer_server/src/generated/rule.dart' as _inhqt802;
import 'package:owncoffer_server/src/generated/scheduled_transaction.dart'
    as _inu9ydal;
import 'package:owncoffer_server/src/generated/statement_import.dart'
    as _igipv995;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'access_denied_exception.dart' as _i8te4v3o;
import 'account.dart' as _iulmo8pc;
import 'account_access.dart' as _idkoqesg;
import 'account_kind.dart' as _ifkquxga;
import 'account_visibility.dart' as _ioxxcdxl;
import 'audit_entry.dart' as _i1613bfs;
import 'backup_code.dart' as _i0b7vj86;
import 'bank_transaction.dart' as _i0mjlwv3;
import 'category.dart' as _issw2w8j;
import 'category_kind.dart' as _i7kso3nf;
import 'category_source.dart' as _idpjit5g;
import 'community_rule.dart' as _igloa2c5;
import 'csv_columns.dart' as _iq9wp9wq;
import 'finance_group.dart' as _iqh5irlt;
import 'forecast_day.dart' as _ids0ngao;
import 'forecast_event_info.dart' as _iuscnr1n;
import 'forecast_result.dart' as _idemr8ki;
import 'frequency.dart' as _ixycnzxw;
import 'group_member.dart' as _igiek2ee;
import 'group_membership.dart' as _i54nduyh;
import 'import_issue_info.dart' as _iso7nf03;
import 'import_preview.dart' as _im8lwq6n;
import 'import_preview_line.dart' as _i4e8elxc;
import 'invalid_input_exception.dart' as _ijc83d8f;
import 'invitation.dart' as _ix00wubs;
import 'invitation_info.dart' as _i9hwipt6;
import 'ip_ban.dart' as _i88cvd1d;
import 'ip_ban_info.dart' as _ijfl1fdm;
import 'member_info.dart' as _i2slp771;
import 'member_role.dart' as _insyygng;
import 'missed_occurrence_info.dart' as _ifjtpr6l;
import 'notification.dart' as _irt10kca;
import 'reconciliation_proposal.dart' as _i7qmkh8w;
import 'rule.dart' as _ivw87pdb;
import 'rule_application.dart' as _ie66uvh9;
import 'rule_direction.dart' as _i13yq1r7;
import 'rule_match_type.dart' as _ibgrh3pe;
import 'scheduled_transaction.dart' as _ifol8nrg;
import 'setup_status.dart' as _iw7q1xsb;
import 'statement_import.dart' as _ia7wudj2;
import 'totp_enrollment.dart' as _iul1v2p7;
import 'totp_secret.dart' as _iac9sbwj;
import 'transaction_page.dart' as _i4rkvxa2;
import 'two_factor_status.dart' as _igcslm1n;
export 'access_denied_exception.dart';
export 'account.dart';
export 'account_access.dart';
export 'account_kind.dart';
export 'account_visibility.dart';
export 'audit_entry.dart';
export 'backup_code.dart';
export 'bank_transaction.dart';
export 'category.dart';
export 'category_kind.dart';
export 'category_source.dart';
export 'community_rule.dart';
export 'csv_columns.dart';
export 'finance_group.dart';
export 'forecast_day.dart';
export 'forecast_event_info.dart';
export 'forecast_result.dart';
export 'frequency.dart';
export 'group_member.dart';
export 'group_membership.dart';
export 'import_issue_info.dart';
export 'import_preview.dart';
export 'import_preview_line.dart';
export 'invalid_input_exception.dart';
export 'invitation.dart';
export 'invitation_info.dart';
export 'ip_ban.dart';
export 'ip_ban_info.dart';
export 'member_info.dart';
export 'member_role.dart';
export 'missed_occurrence_info.dart';
export 'notification.dart';
export 'reconciliation_proposal.dart';
export 'rule.dart';
export 'rule_application.dart';
export 'rule_direction.dart';
export 'rule_match_type.dart';
export 'scheduled_transaction.dart';
export 'setup_status.dart';
export 'statement_import.dart';
export 'totp_enrollment.dart';
export 'totp_secret.dart';
export 'transaction_page.dart';
export 'two_factor_status.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'account_access',
      dartName: 'AccountAccess',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'accountId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'account_access_fk_0',
          columns: ['accountId'],
          referenceTable: 'accounts',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'account_access_fk_1',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'account_access_account_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'accounts',
      dartName: 'Account',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AccountKind',
        ),
        _isp.ColumnDefinition(
          name: 'bank',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'currency',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'EUR\'',
        ),
        _isp.ColumnDefinition(
          name: 'initialBalanceCents',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'initialBalanceDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'alertThresholdCents',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'visibility',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AccountVisibility',
          columnDefault: '\'shared\'',
        ),
        _isp.ColumnDefinition(
          name: 'color',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'accounts_fk_0',
          columns: ['groupId'],
          referenceTable: 'groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'accounts_group_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'audit_log',
      dartName: 'AuditEntry',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'entity',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'rowId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'before',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'after',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'audit_log_group_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'categories',
      dartName: 'Category',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'parentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CategoryKind',
        ),
        _isp.ColumnDefinition(
          name: 'standardCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'icon',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'color',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'categories_fk_0',
          columns: ['groupId'],
          referenceTable: 'groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'categories_fk_1',
          columns: ['parentId'],
          referenceTable: 'categories',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'categories_group_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'community_rules',
      dartName: 'CommunityRule',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'ruleKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'pattern',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'matchType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RuleMatchType',
        ),
        _isp.ColumnDefinition(
          name: 'direction',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RuleDirection',
          columnDefault: '\'any\'',
        ),
        _isp.ColumnDefinition(
          name: 'standardCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'country',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'FR\'',
        ),
        _isp.ColumnDefinition(
          name: 'confidence',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _isp.ColumnDefinition(
          name: 'baseVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'community_rules_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ruleKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'group_members',
      dartName: 'GroupMember',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MemberRole',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'group_members_fk_0',
          columns: ['groupId'],
          referenceTable: 'groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'group_members_fk_1',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'group_members_group_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'group_members_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'groups',
      dartName: 'FinanceGroup',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'aiEnabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'imports',
      dartName: 'StatementImport',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'accountId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'fileName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'fileHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'encoding',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'readCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'addedCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'duplicateCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'possibleDuplicateCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'errorCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'classifiedCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authorId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'cancelledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'imports_fk_0',
          columns: ['accountId'],
          referenceTable: 'accounts',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'imports_account_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'invitations',
      dartName: 'Invitation',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MemberRole',
        ),
        _isp.ColumnDefinition(
          name: 'serverAdmin',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'tokenHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'revokedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'invitations_fk_0',
          columns: ['groupId'],
          referenceTable: 'groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'invitations_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'invitations_token_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tokenHash',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ip_bans',
      dartName: 'IpBan',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'ip',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'failures',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'windowStart',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'lastFailureAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'lastFailureKind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'bannedUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'banCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ip_bans_ip_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ip',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'notifications',
      dartName: 'AppNotification',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'accountId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'data',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'dedupKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'readAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'emailedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'notifications_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'notifications_user_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'dedupKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'notifications_user_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'rules',
      dartName: 'Rule',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'categoryId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'matchType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RuleMatchType',
        ),
        _isp.ColumnDefinition(
          name: 'pattern',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'direction',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RuleDirection',
          columnDefault: '\'any\'',
        ),
        _isp.ColumnDefinition(
          name: 'minAbsCents',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'maxAbsCents',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'priority',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '100',
        ),
        _isp.ColumnDefinition(
          name: 'enabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'rules_fk_0',
          columns: ['groupId'],
          referenceTable: 'groups',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'rules_fk_1',
          columns: ['categoryId'],
          referenceTable: 'categories',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'rules_group_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'scheduled_transactions',
      dartName: 'ScheduledTransaction',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'accountId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'amountCents',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'categoryId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'frequency',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ScheduleFrequency',
        ),
        _isp.ColumnDefinition(
          name: 'interval',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'startDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'occurrenceCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'nextDue',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'matchPattern',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'dateToleranceDays',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '5',
        ),
        _isp.ColumnDefinition(
          name: 'amountTolerancePercent',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'scheduled_transactions_fk_0',
          columns: ['accountId'],
          referenceTable: 'accounts',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'scheduled_transactions_fk_1',
          columns: ['categoryId'],
          referenceTable: 'categories',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'scheduled_account_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'totp_backup_codes',
      dartName: 'BackupCode',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'codeHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'usedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'totp_backup_codes_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'totp_backup_codes_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'totp_secrets',
      dartName: 'TotpSecret',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'secretBox',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'enabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'lastUsedStep',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'enabledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'totp_secrets_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'totp_secrets_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'transactions',
      dartName: 'BankTransaction',
      schema: 'public',
      module: 'owncoffer',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'accountId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'date',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'amountCents',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'rawLabel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'memo',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'cleanLabel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'operationKind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'reference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'bankId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'fingerprint',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'trashedFingerprint',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'importId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'categoryId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'categorySource',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CategorySource',
          columnDefault: '\'none\'',
        ),
        _isp.ColumnDefinition(
          name: 'categoryRuleRef',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'cleared',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'scheduledId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'scheduledDueDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'transferPairId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'transactions_fk_0',
          columns: ['accountId'],
          referenceTable: 'accounts',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'transactions_fk_1',
          columns: ['importId'],
          referenceTable: 'imports',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'transactions_fk_2',
          columns: ['categoryId'],
          referenceTable: 'categories',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'transactions_fk_3',
          columns: ['scheduledId'],
          referenceTable: 'scheduled_transactions',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'transactions_account_date_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'date',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transactions_account_fingerprint_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'accountId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'fingerprint',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transactions_import_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'importId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'transactions_category_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'categoryId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i8te4v3o.AccessDeniedException) {
      return _i8te4v3o.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _iulmo8pc.Account) {
      return _iulmo8pc.Account.fromJson(data) as T;
    }
    if (t == _idkoqesg.AccountAccess) {
      return _idkoqesg.AccountAccess.fromJson(data) as T;
    }
    if (t == _ifkquxga.AccountKind) {
      return _ifkquxga.AccountKind.fromJson(data) as T;
    }
    if (t == _ioxxcdxl.AccountVisibility) {
      return _ioxxcdxl.AccountVisibility.fromJson(data) as T;
    }
    if (t == _i1613bfs.AuditEntry) {
      return _i1613bfs.AuditEntry.fromJson(data) as T;
    }
    if (t == _i0b7vj86.BackupCode) {
      return _i0b7vj86.BackupCode.fromJson(data) as T;
    }
    if (t == _i0mjlwv3.BankTransaction) {
      return _i0mjlwv3.BankTransaction.fromJson(data) as T;
    }
    if (t == _issw2w8j.Category) {
      return _issw2w8j.Category.fromJson(data) as T;
    }
    if (t == _i7kso3nf.CategoryKind) {
      return _i7kso3nf.CategoryKind.fromJson(data) as T;
    }
    if (t == _idpjit5g.CategorySource) {
      return _idpjit5g.CategorySource.fromJson(data) as T;
    }
    if (t == _igloa2c5.CommunityRule) {
      return _igloa2c5.CommunityRule.fromJson(data) as T;
    }
    if (t == _iq9wp9wq.CsvColumns) {
      return _iq9wp9wq.CsvColumns.fromJson(data) as T;
    }
    if (t == _iqh5irlt.FinanceGroup) {
      return _iqh5irlt.FinanceGroup.fromJson(data) as T;
    }
    if (t == _ids0ngao.ForecastDay) {
      return _ids0ngao.ForecastDay.fromJson(data) as T;
    }
    if (t == _iuscnr1n.ForecastEventInfo) {
      return _iuscnr1n.ForecastEventInfo.fromJson(data) as T;
    }
    if (t == _idemr8ki.ForecastResult) {
      return _idemr8ki.ForecastResult.fromJson(data) as T;
    }
    if (t == _ixycnzxw.ScheduleFrequency) {
      return _ixycnzxw.ScheduleFrequency.fromJson(data) as T;
    }
    if (t == _igiek2ee.GroupMember) {
      return _igiek2ee.GroupMember.fromJson(data) as T;
    }
    if (t == _i54nduyh.GroupMembership) {
      return _i54nduyh.GroupMembership.fromJson(data) as T;
    }
    if (t == _iso7nf03.ImportIssueInfo) {
      return _iso7nf03.ImportIssueInfo.fromJson(data) as T;
    }
    if (t == _im8lwq6n.ImportPreview) {
      return _im8lwq6n.ImportPreview.fromJson(data) as T;
    }
    if (t == _i4e8elxc.ImportPreviewLine) {
      return _i4e8elxc.ImportPreviewLine.fromJson(data) as T;
    }
    if (t == _ijc83d8f.InvalidInputException) {
      return _ijc83d8f.InvalidInputException.fromJson(data) as T;
    }
    if (t == _ix00wubs.Invitation) {
      return _ix00wubs.Invitation.fromJson(data) as T;
    }
    if (t == _i9hwipt6.InvitationInfo) {
      return _i9hwipt6.InvitationInfo.fromJson(data) as T;
    }
    if (t == _i88cvd1d.IpBan) {
      return _i88cvd1d.IpBan.fromJson(data) as T;
    }
    if (t == _ijfl1fdm.IpBanInfo) {
      return _ijfl1fdm.IpBanInfo.fromJson(data) as T;
    }
    if (t == _i2slp771.MemberInfo) {
      return _i2slp771.MemberInfo.fromJson(data) as T;
    }
    if (t == _insyygng.MemberRole) {
      return _insyygng.MemberRole.fromJson(data) as T;
    }
    if (t == _ifjtpr6l.MissedOccurrenceInfo) {
      return _ifjtpr6l.MissedOccurrenceInfo.fromJson(data) as T;
    }
    if (t == _irt10kca.AppNotification) {
      return _irt10kca.AppNotification.fromJson(data) as T;
    }
    if (t == _i7qmkh8w.ReconciliationProposal) {
      return _i7qmkh8w.ReconciliationProposal.fromJson(data) as T;
    }
    if (t == _ivw87pdb.Rule) {
      return _ivw87pdb.Rule.fromJson(data) as T;
    }
    if (t == _ie66uvh9.RuleApplication) {
      return _ie66uvh9.RuleApplication.fromJson(data) as T;
    }
    if (t == _i13yq1r7.RuleDirection) {
      return _i13yq1r7.RuleDirection.fromJson(data) as T;
    }
    if (t == _ibgrh3pe.RuleMatchType) {
      return _ibgrh3pe.RuleMatchType.fromJson(data) as T;
    }
    if (t == _ifol8nrg.ScheduledTransaction) {
      return _ifol8nrg.ScheduledTransaction.fromJson(data) as T;
    }
    if (t == _iw7q1xsb.SetupStatus) {
      return _iw7q1xsb.SetupStatus.fromJson(data) as T;
    }
    if (t == _ia7wudj2.StatementImport) {
      return _ia7wudj2.StatementImport.fromJson(data) as T;
    }
    if (t == _iul1v2p7.TotpEnrollment) {
      return _iul1v2p7.TotpEnrollment.fromJson(data) as T;
    }
    if (t == _iac9sbwj.TotpSecret) {
      return _iac9sbwj.TotpSecret.fromJson(data) as T;
    }
    if (t == _i4rkvxa2.TransactionPage) {
      return _i4rkvxa2.TransactionPage.fromJson(data) as T;
    }
    if (t == _igcslm1n.TwoFactorStatus) {
      return _igcslm1n.TwoFactorStatus.fromJson(data) as T;
    }
    if (t == _is.getType<_i8te4v3o.AccessDeniedException?>()) {
      return (data != null
              ? _i8te4v3o.AccessDeniedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iulmo8pc.Account?>()) {
      return (data != null ? _iulmo8pc.Account.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idkoqesg.AccountAccess?>()) {
      return (data != null ? _idkoqesg.AccountAccess.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifkquxga.AccountKind?>()) {
      return (data != null ? _ifkquxga.AccountKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioxxcdxl.AccountVisibility?>()) {
      return (data != null ? _ioxxcdxl.AccountVisibility.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1613bfs.AuditEntry?>()) {
      return (data != null ? _i1613bfs.AuditEntry.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0b7vj86.BackupCode?>()) {
      return (data != null ? _i0b7vj86.BackupCode.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0mjlwv3.BankTransaction?>()) {
      return (data != null ? _i0mjlwv3.BankTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_issw2w8j.Category?>()) {
      return (data != null ? _issw2w8j.Category.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7kso3nf.CategoryKind?>()) {
      return (data != null ? _i7kso3nf.CategoryKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idpjit5g.CategorySource?>()) {
      return (data != null ? _idpjit5g.CategorySource.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igloa2c5.CommunityRule?>()) {
      return (data != null ? _igloa2c5.CommunityRule.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iq9wp9wq.CsvColumns?>()) {
      return (data != null ? _iq9wp9wq.CsvColumns.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqh5irlt.FinanceGroup?>()) {
      return (data != null ? _iqh5irlt.FinanceGroup.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ids0ngao.ForecastDay?>()) {
      return (data != null ? _ids0ngao.ForecastDay.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iuscnr1n.ForecastEventInfo?>()) {
      return (data != null ? _iuscnr1n.ForecastEventInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idemr8ki.ForecastResult?>()) {
      return (data != null ? _idemr8ki.ForecastResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixycnzxw.ScheduleFrequency?>()) {
      return (data != null ? _ixycnzxw.ScheduleFrequency.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igiek2ee.GroupMember?>()) {
      return (data != null ? _igiek2ee.GroupMember.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i54nduyh.GroupMembership?>()) {
      return (data != null ? _i54nduyh.GroupMembership.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iso7nf03.ImportIssueInfo?>()) {
      return (data != null ? _iso7nf03.ImportIssueInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_im8lwq6n.ImportPreview?>()) {
      return (data != null ? _im8lwq6n.ImportPreview.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4e8elxc.ImportPreviewLine?>()) {
      return (data != null ? _i4e8elxc.ImportPreviewLine.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijc83d8f.InvalidInputException?>()) {
      return (data != null
              ? _ijc83d8f.InvalidInputException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ix00wubs.Invitation?>()) {
      return (data != null ? _ix00wubs.Invitation.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9hwipt6.InvitationInfo?>()) {
      return (data != null ? _i9hwipt6.InvitationInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i88cvd1d.IpBan?>()) {
      return (data != null ? _i88cvd1d.IpBan.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijfl1fdm.IpBanInfo?>()) {
      return (data != null ? _ijfl1fdm.IpBanInfo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2slp771.MemberInfo?>()) {
      return (data != null ? _i2slp771.MemberInfo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_insyygng.MemberRole?>()) {
      return (data != null ? _insyygng.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifjtpr6l.MissedOccurrenceInfo?>()) {
      return (data != null
              ? _ifjtpr6l.MissedOccurrenceInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_irt10kca.AppNotification?>()) {
      return (data != null ? _irt10kca.AppNotification.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7qmkh8w.ReconciliationProposal?>()) {
      return (data != null
              ? _i7qmkh8w.ReconciliationProposal.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivw87pdb.Rule?>()) {
      return (data != null ? _ivw87pdb.Rule.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie66uvh9.RuleApplication?>()) {
      return (data != null ? _ie66uvh9.RuleApplication.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i13yq1r7.RuleDirection?>()) {
      return (data != null ? _i13yq1r7.RuleDirection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibgrh3pe.RuleMatchType?>()) {
      return (data != null ? _ibgrh3pe.RuleMatchType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifol8nrg.ScheduledTransaction?>()) {
      return (data != null
              ? _ifol8nrg.ScheduledTransaction.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iw7q1xsb.SetupStatus?>()) {
      return (data != null ? _iw7q1xsb.SetupStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ia7wudj2.StatementImport?>()) {
      return (data != null ? _ia7wudj2.StatementImport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iul1v2p7.TotpEnrollment?>()) {
      return (data != null ? _iul1v2p7.TotpEnrollment.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iac9sbwj.TotpSecret?>()) {
      return (data != null ? _iac9sbwj.TotpSecret.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4rkvxa2.TransactionPage?>()) {
      return (data != null ? _i4rkvxa2.TransactionPage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igcslm1n.TwoFactorStatus?>()) {
      return (data != null ? _igcslm1n.TwoFactorStatus.fromJson(data) : null)
          as T;
    }
    if (t == List<_ids0ngao.ForecastDay>) {
      return (data as List)
              .map((e) => deserialize<_ids0ngao.ForecastDay>(e))
              .toList()
          as T;
    }
    if (t == List<_iuscnr1n.ForecastEventInfo>) {
      return (data as List)
              .map((e) => deserialize<_iuscnr1n.ForecastEventInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_ifjtpr6l.MissedOccurrenceInfo>) {
      return (data as List)
              .map((e) => deserialize<_ifjtpr6l.MissedOccurrenceInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i7qmkh8w.ReconciliationProposal>) {
      return (data as List)
              .map((e) => deserialize<_i7qmkh8w.ReconciliationProposal>(e))
              .toList()
          as T;
    }
    if (t == List<_iso7nf03.ImportIssueInfo>) {
      return (data as List)
              .map((e) => deserialize<_iso7nf03.ImportIssueInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i4e8elxc.ImportPreviewLine>) {
      return (data as List)
              .map((e) => deserialize<_i4e8elxc.ImportPreviewLine>(e))
              .toList()
          as T;
    }
    if (t == List<_i0mjlwv3.BankTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i0mjlwv3.BankTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_iul9ey3g.Account>) {
      return (data as List)
              .map((e) => deserialize<_iul9ey3g.Account>(e))
              .toList()
          as T;
    }
    if (t == List<_itqry2jn.IpBanInfo>) {
      return (data as List)
              .map((e) => deserialize<_itqry2jn.IpBanInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_iemw1gpx.Category>) {
      return (data as List)
              .map((e) => deserialize<_iemw1gpx.Category>(e))
              .toList()
          as T;
    }
    if (t == List<_idq93byd.GroupMembership>) {
      return (data as List)
              .map((e) => deserialize<_idq93byd.GroupMembership>(e))
              .toList()
          as T;
    }
    if (t == List<_ipfe689d.MemberInfo>) {
      return (data as List)
              .map((e) => deserialize<_ipfe689d.MemberInfo>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _is.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_igipv995.StatementImport>) {
      return (data as List)
              .map((e) => deserialize<_igipv995.StatementImport>(e))
              .toList()
          as T;
    }
    if (t == List<_ip1vy3u6.InvitationInfo>) {
      return (data as List)
              .map((e) => deserialize<_ip1vy3u6.InvitationInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_ieap9unx.AppNotification>) {
      return (data as List)
              .map((e) => deserialize<_ieap9unx.AppNotification>(e))
              .toList()
          as T;
    }
    if (t == List<_inhqt802.Rule>) {
      return (data as List).map((e) => deserialize<_inhqt802.Rule>(e)).toList()
          as T;
    }
    if (t == List<_inu9ydal.ScheduledTransaction>) {
      return (data as List)
              .map((e) => deserialize<_inu9ydal.ScheduledTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i8te4v3o.AccessDeniedException => 'AccessDeniedException',
      _iulmo8pc.Account => 'Account',
      _idkoqesg.AccountAccess => 'AccountAccess',
      _ifkquxga.AccountKind => 'AccountKind',
      _ioxxcdxl.AccountVisibility => 'AccountVisibility',
      _i1613bfs.AuditEntry => 'AuditEntry',
      _i0b7vj86.BackupCode => 'BackupCode',
      _i0mjlwv3.BankTransaction => 'BankTransaction',
      _issw2w8j.Category => 'Category',
      _i7kso3nf.CategoryKind => 'CategoryKind',
      _idpjit5g.CategorySource => 'CategorySource',
      _igloa2c5.CommunityRule => 'CommunityRule',
      _iq9wp9wq.CsvColumns => 'CsvColumns',
      _iqh5irlt.FinanceGroup => 'FinanceGroup',
      _ids0ngao.ForecastDay => 'ForecastDay',
      _iuscnr1n.ForecastEventInfo => 'ForecastEventInfo',
      _idemr8ki.ForecastResult => 'ForecastResult',
      _ixycnzxw.ScheduleFrequency => 'ScheduleFrequency',
      _igiek2ee.GroupMember => 'GroupMember',
      _i54nduyh.GroupMembership => 'GroupMembership',
      _iso7nf03.ImportIssueInfo => 'ImportIssueInfo',
      _im8lwq6n.ImportPreview => 'ImportPreview',
      _i4e8elxc.ImportPreviewLine => 'ImportPreviewLine',
      _ijc83d8f.InvalidInputException => 'InvalidInputException',
      _ix00wubs.Invitation => 'Invitation',
      _i9hwipt6.InvitationInfo => 'InvitationInfo',
      _i88cvd1d.IpBan => 'IpBan',
      _ijfl1fdm.IpBanInfo => 'IpBanInfo',
      _i2slp771.MemberInfo => 'MemberInfo',
      _insyygng.MemberRole => 'MemberRole',
      _ifjtpr6l.MissedOccurrenceInfo => 'MissedOccurrenceInfo',
      _irt10kca.AppNotification => 'AppNotification',
      _i7qmkh8w.ReconciliationProposal => 'ReconciliationProposal',
      _ivw87pdb.Rule => 'Rule',
      _ie66uvh9.RuleApplication => 'RuleApplication',
      _i13yq1r7.RuleDirection => 'RuleDirection',
      _ibgrh3pe.RuleMatchType => 'RuleMatchType',
      _ifol8nrg.ScheduledTransaction => 'ScheduledTransaction',
      _iw7q1xsb.SetupStatus => 'SetupStatus',
      _ia7wudj2.StatementImport => 'StatementImport',
      _iul1v2p7.TotpEnrollment => 'TotpEnrollment',
      _iac9sbwj.TotpSecret => 'TotpSecret',
      _i4rkvxa2.TransactionPage => 'TransactionPage',
      _igcslm1n.TwoFactorStatus => 'TwoFactorStatus',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('owncoffer.', '');
    }

    switch (data) {
      case _i8te4v3o.AccessDeniedException():
        return 'AccessDeniedException';
      case _iulmo8pc.Account():
        return 'Account';
      case _idkoqesg.AccountAccess():
        return 'AccountAccess';
      case _ifkquxga.AccountKind():
        return 'AccountKind';
      case _ioxxcdxl.AccountVisibility():
        return 'AccountVisibility';
      case _i1613bfs.AuditEntry():
        return 'AuditEntry';
      case _i0b7vj86.BackupCode():
        return 'BackupCode';
      case _i0mjlwv3.BankTransaction():
        return 'BankTransaction';
      case _issw2w8j.Category():
        return 'Category';
      case _i7kso3nf.CategoryKind():
        return 'CategoryKind';
      case _idpjit5g.CategorySource():
        return 'CategorySource';
      case _igloa2c5.CommunityRule():
        return 'CommunityRule';
      case _iq9wp9wq.CsvColumns():
        return 'CsvColumns';
      case _iqh5irlt.FinanceGroup():
        return 'FinanceGroup';
      case _ids0ngao.ForecastDay():
        return 'ForecastDay';
      case _iuscnr1n.ForecastEventInfo():
        return 'ForecastEventInfo';
      case _idemr8ki.ForecastResult():
        return 'ForecastResult';
      case _ixycnzxw.ScheduleFrequency():
        return 'ScheduleFrequency';
      case _igiek2ee.GroupMember():
        return 'GroupMember';
      case _i54nduyh.GroupMembership():
        return 'GroupMembership';
      case _iso7nf03.ImportIssueInfo():
        return 'ImportIssueInfo';
      case _im8lwq6n.ImportPreview():
        return 'ImportPreview';
      case _i4e8elxc.ImportPreviewLine():
        return 'ImportPreviewLine';
      case _ijc83d8f.InvalidInputException():
        return 'InvalidInputException';
      case _ix00wubs.Invitation():
        return 'Invitation';
      case _i9hwipt6.InvitationInfo():
        return 'InvitationInfo';
      case _i88cvd1d.IpBan():
        return 'IpBan';
      case _ijfl1fdm.IpBanInfo():
        return 'IpBanInfo';
      case _i2slp771.MemberInfo():
        return 'MemberInfo';
      case _insyygng.MemberRole():
        return 'MemberRole';
      case _ifjtpr6l.MissedOccurrenceInfo():
        return 'MissedOccurrenceInfo';
      case _irt10kca.AppNotification():
        return 'AppNotification';
      case _i7qmkh8w.ReconciliationProposal():
        return 'ReconciliationProposal';
      case _ivw87pdb.Rule():
        return 'Rule';
      case _ie66uvh9.RuleApplication():
        return 'RuleApplication';
      case _i13yq1r7.RuleDirection():
        return 'RuleDirection';
      case _ibgrh3pe.RuleMatchType():
        return 'RuleMatchType';
      case _ifol8nrg.ScheduledTransaction():
        return 'ScheduledTransaction';
      case _iw7q1xsb.SetupStatus():
        return 'SetupStatus';
      case _ia7wudj2.StatementImport():
        return 'StatementImport';
      case _iul1v2p7.TotpEnrollment():
        return 'TotpEnrollment';
      case _iac9sbwj.TotpSecret():
        return 'TotpSecret';
      case _i4rkvxa2.TransactionPage():
        return 'TransactionPage';
      case _igcslm1n.TwoFactorStatus():
        return 'TwoFactorStatus';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i8te4v3o.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'Account') {
      return deserialize<_iulmo8pc.Account>(data['data']);
    }
    if (dataClassName == 'AccountAccess') {
      return deserialize<_idkoqesg.AccountAccess>(data['data']);
    }
    if (dataClassName == 'AccountKind') {
      return deserialize<_ifkquxga.AccountKind>(data['data']);
    }
    if (dataClassName == 'AccountVisibility') {
      return deserialize<_ioxxcdxl.AccountVisibility>(data['data']);
    }
    if (dataClassName == 'AuditEntry') {
      return deserialize<_i1613bfs.AuditEntry>(data['data']);
    }
    if (dataClassName == 'BackupCode') {
      return deserialize<_i0b7vj86.BackupCode>(data['data']);
    }
    if (dataClassName == 'BankTransaction') {
      return deserialize<_i0mjlwv3.BankTransaction>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_issw2w8j.Category>(data['data']);
    }
    if (dataClassName == 'CategoryKind') {
      return deserialize<_i7kso3nf.CategoryKind>(data['data']);
    }
    if (dataClassName == 'CategorySource') {
      return deserialize<_idpjit5g.CategorySource>(data['data']);
    }
    if (dataClassName == 'CommunityRule') {
      return deserialize<_igloa2c5.CommunityRule>(data['data']);
    }
    if (dataClassName == 'CsvColumns') {
      return deserialize<_iq9wp9wq.CsvColumns>(data['data']);
    }
    if (dataClassName == 'FinanceGroup') {
      return deserialize<_iqh5irlt.FinanceGroup>(data['data']);
    }
    if (dataClassName == 'ForecastDay') {
      return deserialize<_ids0ngao.ForecastDay>(data['data']);
    }
    if (dataClassName == 'ForecastEventInfo') {
      return deserialize<_iuscnr1n.ForecastEventInfo>(data['data']);
    }
    if (dataClassName == 'ForecastResult') {
      return deserialize<_idemr8ki.ForecastResult>(data['data']);
    }
    if (dataClassName == 'ScheduleFrequency') {
      return deserialize<_ixycnzxw.ScheduleFrequency>(data['data']);
    }
    if (dataClassName == 'GroupMember') {
      return deserialize<_igiek2ee.GroupMember>(data['data']);
    }
    if (dataClassName == 'GroupMembership') {
      return deserialize<_i54nduyh.GroupMembership>(data['data']);
    }
    if (dataClassName == 'ImportIssueInfo') {
      return deserialize<_iso7nf03.ImportIssueInfo>(data['data']);
    }
    if (dataClassName == 'ImportPreview') {
      return deserialize<_im8lwq6n.ImportPreview>(data['data']);
    }
    if (dataClassName == 'ImportPreviewLine') {
      return deserialize<_i4e8elxc.ImportPreviewLine>(data['data']);
    }
    if (dataClassName == 'InvalidInputException') {
      return deserialize<_ijc83d8f.InvalidInputException>(data['data']);
    }
    if (dataClassName == 'Invitation') {
      return deserialize<_ix00wubs.Invitation>(data['data']);
    }
    if (dataClassName == 'InvitationInfo') {
      return deserialize<_i9hwipt6.InvitationInfo>(data['data']);
    }
    if (dataClassName == 'IpBan') {
      return deserialize<_i88cvd1d.IpBan>(data['data']);
    }
    if (dataClassName == 'IpBanInfo') {
      return deserialize<_ijfl1fdm.IpBanInfo>(data['data']);
    }
    if (dataClassName == 'MemberInfo') {
      return deserialize<_i2slp771.MemberInfo>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_insyygng.MemberRole>(data['data']);
    }
    if (dataClassName == 'MissedOccurrenceInfo') {
      return deserialize<_ifjtpr6l.MissedOccurrenceInfo>(data['data']);
    }
    if (dataClassName == 'AppNotification') {
      return deserialize<_irt10kca.AppNotification>(data['data']);
    }
    if (dataClassName == 'ReconciliationProposal') {
      return deserialize<_i7qmkh8w.ReconciliationProposal>(data['data']);
    }
    if (dataClassName == 'Rule') {
      return deserialize<_ivw87pdb.Rule>(data['data']);
    }
    if (dataClassName == 'RuleApplication') {
      return deserialize<_ie66uvh9.RuleApplication>(data['data']);
    }
    if (dataClassName == 'RuleDirection') {
      return deserialize<_i13yq1r7.RuleDirection>(data['data']);
    }
    if (dataClassName == 'RuleMatchType') {
      return deserialize<_ibgrh3pe.RuleMatchType>(data['data']);
    }
    if (dataClassName == 'ScheduledTransaction') {
      return deserialize<_ifol8nrg.ScheduledTransaction>(data['data']);
    }
    if (dataClassName == 'SetupStatus') {
      return deserialize<_iw7q1xsb.SetupStatus>(data['data']);
    }
    if (dataClassName == 'StatementImport') {
      return deserialize<_ia7wudj2.StatementImport>(data['data']);
    }
    if (dataClassName == 'TotpEnrollment') {
      return deserialize<_iul1v2p7.TotpEnrollment>(data['data']);
    }
    if (dataClassName == 'TotpSecret') {
      return deserialize<_iac9sbwj.TotpSecret>(data['data']);
    }
    if (dataClassName == 'TransactionPage') {
      return deserialize<_i4rkvxa2.TransactionPage>(data['data']);
    }
    if (dataClassName == 'TwoFactorStatus') {
      return deserialize<_igcslm1n.TwoFactorStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('owncoffer', this);
    _iacs.Protocol().registerHostProtocol('owncoffer', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iulmo8pc.Account:
        return _iulmo8pc.Account.t;
      case _idkoqesg.AccountAccess:
        return _idkoqesg.AccountAccess.t;
      case _i1613bfs.AuditEntry:
        return _i1613bfs.AuditEntry.t;
      case _i0b7vj86.BackupCode:
        return _i0b7vj86.BackupCode.t;
      case _i0mjlwv3.BankTransaction:
        return _i0mjlwv3.BankTransaction.t;
      case _issw2w8j.Category:
        return _issw2w8j.Category.t;
      case _igloa2c5.CommunityRule:
        return _igloa2c5.CommunityRule.t;
      case _iqh5irlt.FinanceGroup:
        return _iqh5irlt.FinanceGroup.t;
      case _igiek2ee.GroupMember:
        return _igiek2ee.GroupMember.t;
      case _ix00wubs.Invitation:
        return _ix00wubs.Invitation.t;
      case _i88cvd1d.IpBan:
        return _i88cvd1d.IpBan.t;
      case _irt10kca.AppNotification:
        return _irt10kca.AppNotification.t;
      case _ivw87pdb.Rule:
        return _ivw87pdb.Rule.t;
      case _ifol8nrg.ScheduledTransaction:
        return _ifol8nrg.ScheduledTransaction.t;
      case _ia7wudj2.StatementImport:
        return _ia7wudj2.StatementImport.t;
      case _iac9sbwj.TotpSecret:
        return _iac9sbwj.TotpSecret.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'owncoffer';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
