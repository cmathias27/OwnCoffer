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
import 'package:owncoffer_server/src/generated/group_member.dart' as _iep4djhw;
import 'package:owncoffer_server/src/generated/group_membership.dart'
    as _idq93byd;
import 'package:owncoffer_server/src/generated/invitation_info.dart'
    as _ip1vy3u6;
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
import 'bank_transaction.dart' as _i0mjlwv3;
import 'category.dart' as _issw2w8j;
import 'category_kind.dart' as _i7kso3nf;
import 'category_source.dart' as _idpjit5g;
import 'community_rule.dart' as _igloa2c5;
import 'finance_group.dart' as _iqh5irlt;
import 'frequency.dart' as _ixycnzxw;
import 'group_member.dart' as _igiek2ee;
import 'group_membership.dart' as _i54nduyh;
import 'invalid_input_exception.dart' as _ijc83d8f;
import 'invitation.dart' as _ix00wubs;
import 'invitation_info.dart' as _i9hwipt6;
import 'member_role.dart' as _insyygng;
import 'rule.dart' as _ivw87pdb;
import 'rule_direction.dart' as _i13yq1r7;
import 'rule_match_type.dart' as _ibgrh3pe;
import 'scheduled_transaction.dart' as _ifol8nrg;
import 'setup_status.dart' as _iw7q1xsb;
import 'standard_category.dart' as _iwj8dr64;
import 'statement_import.dart' as _ia7wudj2;
export 'access_denied_exception.dart';
export 'account.dart';
export 'account_access.dart';
export 'account_kind.dart';
export 'account_visibility.dart';
export 'audit_entry.dart';
export 'bank_transaction.dart';
export 'category.dart';
export 'category_kind.dart';
export 'category_source.dart';
export 'community_rule.dart';
export 'finance_group.dart';
export 'frequency.dart';
export 'group_member.dart';
export 'group_membership.dart';
export 'invalid_input_exception.dart';
export 'invitation.dart';
export 'invitation_info.dart';
export 'member_role.dart';
export 'rule.dart';
export 'rule_direction.dart';
export 'rule_match_type.dart';
export 'scheduled_transaction.dart';
export 'setup_status.dart';
export 'standard_category.dart';
export 'statement_import.dart';

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
          isNullable: false,
          dartType: 'String',
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
      name: 'standard_categories',
      dartName: 'StandardCategory',
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
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'parentCode',
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
          name: 'nameFr',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nameEn',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'icon',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deprecated',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'catalogVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'standard_categories_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
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
    if (t == _iqh5irlt.FinanceGroup) {
      return _iqh5irlt.FinanceGroup.fromJson(data) as T;
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
    if (t == _ijc83d8f.InvalidInputException) {
      return _ijc83d8f.InvalidInputException.fromJson(data) as T;
    }
    if (t == _ix00wubs.Invitation) {
      return _ix00wubs.Invitation.fromJson(data) as T;
    }
    if (t == _i9hwipt6.InvitationInfo) {
      return _i9hwipt6.InvitationInfo.fromJson(data) as T;
    }
    if (t == _insyygng.MemberRole) {
      return _insyygng.MemberRole.fromJson(data) as T;
    }
    if (t == _ivw87pdb.Rule) {
      return _ivw87pdb.Rule.fromJson(data) as T;
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
    if (t == _iwj8dr64.StandardCategory) {
      return _iwj8dr64.StandardCategory.fromJson(data) as T;
    }
    if (t == _ia7wudj2.StatementImport) {
      return _ia7wudj2.StatementImport.fromJson(data) as T;
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
    if (t == _is.getType<_iqh5irlt.FinanceGroup?>()) {
      return (data != null ? _iqh5irlt.FinanceGroup.fromJson(data) : null) as T;
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
    if (t == _is.getType<_insyygng.MemberRole?>()) {
      return (data != null ? _insyygng.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivw87pdb.Rule?>()) {
      return (data != null ? _ivw87pdb.Rule.fromJson(data) : null) as T;
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
    if (t == _is.getType<_iwj8dr64.StandardCategory?>()) {
      return (data != null ? _iwj8dr64.StandardCategory.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ia7wudj2.StatementImport?>()) {
      return (data != null ? _ia7wudj2.StatementImport.fromJson(data) : null)
          as T;
    }
    if (t == List<_iul9ey3g.Account>) {
      return (data as List)
              .map((e) => deserialize<_iul9ey3g.Account>(e))
              .toList()
          as T;
    }
    if (t == List<_idq93byd.GroupMembership>) {
      return (data as List)
              .map((e) => deserialize<_idq93byd.GroupMembership>(e))
              .toList()
          as T;
    }
    if (t == List<_iep4djhw.GroupMember>) {
      return (data as List)
              .map((e) => deserialize<_iep4djhw.GroupMember>(e))
              .toList()
          as T;
    }
    if (t == List<_ip1vy3u6.InvitationInfo>) {
      return (data as List)
              .map((e) => deserialize<_ip1vy3u6.InvitationInfo>(e))
              .toList()
          as T;
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
      _i0mjlwv3.BankTransaction => 'BankTransaction',
      _issw2w8j.Category => 'Category',
      _i7kso3nf.CategoryKind => 'CategoryKind',
      _idpjit5g.CategorySource => 'CategorySource',
      _igloa2c5.CommunityRule => 'CommunityRule',
      _iqh5irlt.FinanceGroup => 'FinanceGroup',
      _ixycnzxw.ScheduleFrequency => 'ScheduleFrequency',
      _igiek2ee.GroupMember => 'GroupMember',
      _i54nduyh.GroupMembership => 'GroupMembership',
      _ijc83d8f.InvalidInputException => 'InvalidInputException',
      _ix00wubs.Invitation => 'Invitation',
      _i9hwipt6.InvitationInfo => 'InvitationInfo',
      _insyygng.MemberRole => 'MemberRole',
      _ivw87pdb.Rule => 'Rule',
      _i13yq1r7.RuleDirection => 'RuleDirection',
      _ibgrh3pe.RuleMatchType => 'RuleMatchType',
      _ifol8nrg.ScheduledTransaction => 'ScheduledTransaction',
      _iw7q1xsb.SetupStatus => 'SetupStatus',
      _iwj8dr64.StandardCategory => 'StandardCategory',
      _ia7wudj2.StatementImport => 'StatementImport',
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
      case _iqh5irlt.FinanceGroup():
        return 'FinanceGroup';
      case _ixycnzxw.ScheduleFrequency():
        return 'ScheduleFrequency';
      case _igiek2ee.GroupMember():
        return 'GroupMember';
      case _i54nduyh.GroupMembership():
        return 'GroupMembership';
      case _ijc83d8f.InvalidInputException():
        return 'InvalidInputException';
      case _ix00wubs.Invitation():
        return 'Invitation';
      case _i9hwipt6.InvitationInfo():
        return 'InvitationInfo';
      case _insyygng.MemberRole():
        return 'MemberRole';
      case _ivw87pdb.Rule():
        return 'Rule';
      case _i13yq1r7.RuleDirection():
        return 'RuleDirection';
      case _ibgrh3pe.RuleMatchType():
        return 'RuleMatchType';
      case _ifol8nrg.ScheduledTransaction():
        return 'ScheduledTransaction';
      case _iw7q1xsb.SetupStatus():
        return 'SetupStatus';
      case _iwj8dr64.StandardCategory():
        return 'StandardCategory';
      case _ia7wudj2.StatementImport():
        return 'StatementImport';
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
    if (dataClassName == 'FinanceGroup') {
      return deserialize<_iqh5irlt.FinanceGroup>(data['data']);
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
    if (dataClassName == 'InvalidInputException') {
      return deserialize<_ijc83d8f.InvalidInputException>(data['data']);
    }
    if (dataClassName == 'Invitation') {
      return deserialize<_ix00wubs.Invitation>(data['data']);
    }
    if (dataClassName == 'InvitationInfo') {
      return deserialize<_i9hwipt6.InvitationInfo>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_insyygng.MemberRole>(data['data']);
    }
    if (dataClassName == 'Rule') {
      return deserialize<_ivw87pdb.Rule>(data['data']);
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
    if (dataClassName == 'StandardCategory') {
      return deserialize<_iwj8dr64.StandardCategory>(data['data']);
    }
    if (dataClassName == 'StatementImport') {
      return deserialize<_ia7wudj2.StatementImport>(data['data']);
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
      case _ivw87pdb.Rule:
        return _ivw87pdb.Rule.t;
      case _ifol8nrg.ScheduledTransaction:
        return _ifol8nrg.ScheduledTransaction.t;
      case _iwj8dr64.StandardCategory:
        return _iwj8dr64.StandardCategory.t;
      case _ia7wudj2.StatementImport:
        return _ia7wudj2.StatementImport.t;
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
