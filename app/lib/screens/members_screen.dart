import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';

/// Members of the group; invitations for administrators.
class MembersScreen extends StatefulWidget {
  final GroupMembership membership;

  /// Inside another page (an administration tab): no own app bar, the
  /// invite button at the top of the list.
  final bool embedded;
  const MembersScreen({
    super.key,
    required this.membership,
    this.embedded = false,
  });

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<MemberInfo>? _members;
  List<InvitationInfo> _invitations = [];
  String? _error;

  bool get _isAdmin => widget.membership.role == MemberRole.admin;
  int get _groupId => widget.membership.group.id!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final members = await client.group.members(_groupId);
      final invitations = _isAdmin
          ? await client.invitation.list(_groupId)
          : <InvitationInfo>[];
      if (mounted) {
        setState(() => (_members = members, _invitations = invitations));
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() => _error = errorText(AppLocalizations.of(context), e));
      }
    }
  }

  static String roleName(AppLocalizations l, MemberRole r) => switch (r) {
    MemberRole.admin => l.roleAdmin,
    MemberRole.user => l.roleUser,
    MemberRole.reader => l.roleReader,
  };

  Future<void> _invite() async {
    final l = AppLocalizations.of(context);
    final sent = await showDialog<String>(
      context: context,
      builder: (_) => _InviteDialog(groupId: _groupId),
    );
    if (sent != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.invitationSent(sent))));
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final members = _members;
    final embedded = widget.embedded;
    final Widget body = _error != null
        ? Center(child: Text(_error!))
        : members == null
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (embedded) ...[
                Text(
                  l.adminMembersOf(widget.membership.group.name),
                  style: theme.textTheme.titleMedium,
                ),
                if (_isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FilledButton.icon(
                        onPressed: _invite,
                        icon: const Icon(Icons.person_add_alt),
                        label: Text(l.invite),
                      ),
                    ),
                  ),
              ],
              for (final m in members)
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(m.email ?? '—'),
                  subtitle: Text(roleName(l, m.role)),
                ),
              if (_isAdmin) ...[
                const Divider(height: 32),
                Text(l.invitationsTitle, style: theme.textTheme.titleMedium),
                if (_invitations.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l.noInvitations),
                  ),
                for (final i in _invitations)
                  ListTile(
                    leading: const Icon(Icons.mail_outline),
                    title: Text(i.email),
                    subtitle: Text(
                      '${roleName(l, i.role)} · ${l.invitationExpires(DateFormat.yMMMd(locale).format(i.expiresAt.toLocal()))}',
                    ),
                    trailing: TextButton(
                      onPressed: () async {
                        await client.invitation.revoke(i.id);
                        await _load();
                      },
                      child: Text(l.revoke),
                    ),
                  ),
              ],
            ],
          );
    if (embedded) return body;
    return Scaffold(
      appBar: AppBar(title: Text(l.membersTitle)),
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _invite,
              icon: const Icon(Icons.person_add_alt),
              label: Text(l.invite),
            )
          : null,
      body: body,
    );
  }
}

class _InviteDialog extends StatefulWidget {
  final int groupId;
  const _InviteDialog({required this.groupId});

  @override
  State<_InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends State<_InviteDialog> {
  final _email = TextEditingController();
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
      await client.invitation.create(widget.groupId, email, _role);
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
            DropdownButtonFormField<MemberRole>(
              initialValue: _role,
              decoration: InputDecoration(
                labelText: l.roleLabel,
                helperText: l.roleHelp,
                helperMaxLines: 3,
              ),
              items: [
                for (final r in MemberRole.values)
                  DropdownMenuItem(
                    value: r,
                    child: Text(_MembersScreenState.roleName(l, r)),
                  ),
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
