import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/format.dart';

String _roleName(AppLocalizations l, MemberRole r) => switch (r) {
  MemberRole.admin => l.roleAdmin,
  MemberRole.user => l.roleUser,
  MemberRole.reader => l.roleReader,
};

/// Pending invitations of every group: who, into which group, sent by whom,
/// until when; invite into any group, revoke.
class AdminInvitationsView extends StatelessWidget {
  final List<AdminInvitationInfo> invitations;
  final List<AdminGroupInfo> groups;

  /// Called after an invitation was sent or revoked.
  final VoidCallback onChanged;

  const AdminInvitationsView({
    super.key,
    required this.invitations,
    required this.groups,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.adminInvitationsHelp, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            icon: const Icon(Icons.person_add_alt),
            label: Text(l.invite),
            onPressed: groups.isEmpty
                ? null
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final email = await showDialog<String>(
                      context: context,
                      builder: (_) => AdminInviteDialog(groups: groups),
                    );
                    if (email == null) return;
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.invitationSent(email))),
                    );
                    onChanged();
                  },
          ),
        ),
        const SizedBox(height: 8),
        if (groups.isNotEmpty) ...[
          Text(l.adminGroups, style: theme.textTheme.titleSmall),
          for (final g in groups)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.groups_outlined),
              title: Text(g.name),
              subtitle: Text(l.adminGroupSize(g.members, g.accounts)),
            ),
          const SizedBox(height: 8),
        ],
        Text(l.adminInvitationsPending, style: theme.textTheme.titleSmall),
        if (invitations.isEmpty) Text(l.adminInvitationsEmpty),
        for (final i in invitations)
          Card(
            child: ListTile(
              leading: Icon(
                i.serverAdmin
                    ? Icons.admin_panel_settings_outlined
                    : Icons.mail_outline,
              ),
              title: Text(i.email),
              subtitle: Text(
                [
                  if (i.groupName != null)
                    '${i.groupName} (${_roleName(l, i.role)})',
                  if (i.serverAdmin) l.adminServerAdmin,
                  if (i.invitedBy != null) l.adminInvitedBy(i.invitedBy!),
                  l.adminInvitationExpires(context.day(i.expiresAt)),
                ].join(' · '),
              ),
              trailing: TextButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await client.admin.revokeInvitation(i.id);
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.adminInvitationRevoked)),
                    );
                    onChanged();
                  } on Object catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(errorText(l, e))),
                    );
                  }
                },
                child: Text(l.revoke),
              ),
            ),
          ),
      ],
    );
  }
}

/// Email, group and role; the server emails the link.
class AdminInviteDialog extends StatefulWidget {
  final List<AdminGroupInfo> groups;
  const AdminInviteDialog({super.key, required this.groups});

  @override
  State<AdminInviteDialog> createState() => _AdminInviteDialogState();
}

class _AdminInviteDialogState extends State<AdminInviteDialog> {
  final _email = TextEditingController();
  late int _groupId = widget.groups.first.id;
  var _role = MemberRole.user;
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l = AppLocalizations.of(context);
    setState(() => (_busy = true, _error = null));
    try {
      final email = _email.text.trim();
      await client.admin.invite(_groupId, email, _role);
      if (mounted) Navigator.of(context).pop(email);
    } on Object catch (e) {
      setState(() => (_busy = false, _error = errorText(l, e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.inviteTitle),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l.emailLabel),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: _groupId,
              decoration: InputDecoration(labelText: l.groupLabel),
              items: [
                for (final g in widget.groups)
                  DropdownMenuItem(value: g.id, child: Text(g.name)),
              ],
              onChanged: (v) => setState(() => _groupId = v ?? _groupId),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MemberRole>(
              isExpanded: true,
              initialValue: _role,
              decoration: InputDecoration(
                labelText: l.roleLabel,
                helperText: l.roleHelp,
                helperMaxLines: 3,
              ),
              items: [
                for (final r in MemberRole.values)
                  DropdownMenuItem(value: r, child: Text(_roleName(l, r))),
              ],
              onChanged: (r) => setState(() => _role = r ?? _role),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _busy ? null : _send, child: Text(l.invite)),
      ],
    );
  }
}
