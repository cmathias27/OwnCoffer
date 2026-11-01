import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

/// The household's log, for its administrators (#37): who did what and
/// when, without the content of the changes.
class GroupAuditScreen extends StatefulWidget {
  final GroupMembership membership;
  const GroupAuditScreen({super.key, required this.membership});

  @override
  State<GroupAuditScreen> createState() => _GroupAuditScreenState();
}

class _GroupAuditScreenState extends State<GroupAuditScreen> {
  static const _page = 100;
  final List<AdminAuditInfo> _items = [];
  var _more = true;
  var _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_loading || !_more) return;
    setState(() => _loading = true);
    try {
      final rows = await client.group.audit(
        widget.membership.group.id!,
        limit: _page,
        offset: _items.length,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(rows);
        _more = rows.length == _page;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.groupAuditTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(l.groupAuditHelp, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          if (_error != null) Text(_error!),
          if (_items.isEmpty && !_loading && _error == null)
            Text(l.adminAuditEmpty),
          for (final a in _items)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(auditIcon(a.entity), size: 20),
              title: Text(auditText(l, a.action, a.entity)),
              subtitle: Text(
                '${context.day(a.createdAt.toLocal())} '
                '${TimeOfDay.fromDateTime(a.createdAt.toLocal()).format(context)}'
                ' · ${a.email ?? l.groupAuditFormer}',
              ),
            ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_more && _items.isNotEmpty)
            Center(
              child: TextButton(
                onPressed: _load,
                child: Text(l.groupAuditMore),
              ),
            ),
        ],
      ),
    );
  }
}

IconData auditIcon(String entity) => switch (entity) {
  'transaction' => Icons.receipt_long_outlined,
  'account' => Icons.account_balance_wallet_outlined,
  'import' => Icons.upload_file_outlined,
  'rule' || 'category' => Icons.label_outline,
  'loan' => Icons.account_balance_outlined,
  'invoice' => Icons.description_outlined,
  'goal' => Icons.flag_outlined,
  'scheduled' => Icons.event_repeat,
  'group' || 'group_member' || 'invitation' => Icons.people_outline,
  'action_proposal' => Icons.lightbulb_outline,
  'ai' || 'mcp' || 'mcp_token' => Icons.auto_awesome_outlined,
  _ => Icons.history,
};

/// "Opération : catégorie changée", from the log's codes; the codes
/// themselves when unknown.
String auditText(AppLocalizations l, String action, String entity) {
  final what = switch (entity) {
    'transaction' => l.auditEntityTransaction,
    'account' => l.auditEntityAccount,
    'import' => l.auditEntityImport,
    'rule' => l.auditEntityRule,
    'category' => l.auditEntityCategory,
    'loan' => l.auditEntityLoan,
    'invoice' => l.auditEntityInvoice,
    'goal' => l.auditEntityGoal,
    'scheduled' => l.auditEntityScheduled,
    'group' => l.auditEntityGroup,
    'group_member' => l.auditEntityMember,
    'invitation' => l.auditEntityInvitation,
    'action_proposal' => l.auditEntityProposal,
    'ai' => l.auditEntityAi,
    'mcp' || 'mcp_token' => l.auditEntityMcp,
    'notification_settings' => l.auditEntityNotifications,
    _ => entity,
  };
  final did = switch (action) {
    'create' ||
    'create_from_transaction' ||
    'create_from_correction' => l.auditActionCreate,
    'update' || 'update_invoice' => l.auditActionUpdate,
    'delete' || 'delete_invoice' || 'delete_document' => l.auditActionDelete,
    'trash' => l.auditActionTrash,
    'restore' => l.auditActionRestore,
    'set_category' => l.auditActionCategory,
    'split' || 'unsplit' => l.auditActionSplit,
    'set_cleared' || 'set_cleared_many' => l.auditActionCleared,
    'import' => l.auditActionImport,
    'cancel_import' => l.auditActionCancelImport,
    'undo' || 'undo_create' || 'undo_attach' => l.auditActionUndo,
    'archive' => l.auditActionArchive,
    'invite' => l.auditActionInvite,
    'revoke' => l.auditActionRevoke,
    'set_role' => l.auditActionRole,
    'remove_member' => l.auditActionRemove,
    'propose' => l.auditActionPropose,
    'execute' => l.auditActionAccept,
    'refuse' => l.auditActionRefuse,
    'expire' => l.auditActionExpire,
    'ai_request' || 'mcp_call' => l.auditActionAsk,
    'read_document' => l.auditActionReadDocument,
    'upload_document' ||
    'upload_invoice' ||
    'attach_invoice' ||
    'attach_transaction' => l.auditActionAttach,
    _ => action,
  };
  return l.auditLine(what, did);
}
