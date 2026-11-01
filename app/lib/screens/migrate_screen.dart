import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../util/group_transfer.dart';
import '../util/memory_auth_storage.dart';
import '../util/server_address.dart';

/// Standalone mode: sends every group of this device to an OwnCoffer
/// server (decision 0022), then offers to switch to it. Nothing is deleted
/// here.
class MigrateScreen extends StatefulWidget {
  const MigrateScreen({super.key});

  @override
  State<MigrateScreen> createState() => _MigrateScreenState();
}

enum _Step { address, signIn, ready, sending, done }

class _MigrateScreenState extends State<MigrateScreen> {
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  var _step = _Step.address;
  var _busy = false;
  var _needsCode = false;
  String? _error;
  Uri? _api;
  Client? _target;
  AuthSuccess? _session;
  double _progress = 0;
  var _groups = 0;
  var _operations = 0;

  @override
  void dispose() {
    for (final c in [_address, _email, _password, _code]) {
      c.dispose();
    }
    _target?.close();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => (_busy = true, _error = null));
    try {
      await action();
    } on Object catch (e) {
      if (mounted) {
        setState(
          () => _error = e is _Message
              ? e.text
              : errorText(AppLocalizations.of(context), e),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _checkAddress() => _run(() async {
    final l = AppLocalizations.of(context);
    final api = ServerAddress.parse(_address.text);
    if (api == null) throw _Message(l.serverAddressInvalid);
    if (!await ServerAddress.check(api)) {
      throw _Message(l.serverAddressUnreachable);
    }
    _target?.close();
    _api = api;
    _target = Client(api.toString())
      ..authSessionManager = FlutterAuthSessionManager(
        storage: MemoryAuthStorage(),
      );
    setState(() => _step = _Step.signIn);
  });

  Future<void> _signIn() => _run(() async {
    final l = AppLocalizations.of(context);
    final target = _target!;
    if (!_needsCode) {
      final success = await target.emailIdp.login(
        email: _email.text.trim(),
        password: _password.text,
      );
      await target.auth.updateSignedInUser(success);
      _session = success;
      if (!(await target.twoFactor.status()).fullAccess) {
        setState(() => _needsCode = true);
        return;
      }
    } else {
      final success = await target.twoFactor.verify(_code.text.trim());
      await target.auth.updateSignedInUser(success);
      _session = success;
    }
    if (!await target.admin.isServerAdmin()) throw _Message(l.migrateNotAdmin);
    setState(() => _step = _Step.ready);
  });

  Future<void> _send() => _run(() async {
    setState(() => (_step = _Step.sending, _progress = 0));
    final groups = [
      for (final m in await client.group.myGroups())
        if (m.role == MemberRole.admin) m,
    ];
    var operations = 0;
    for (var i = 0; i < groups.length; i++) {
      final result = await GroupTransfer.send(
        from: client,
        to: _target!,
        groupId: groups[i].group.id!,
        progress: (p) {
          if (mounted) setState(() => _progress = (i + p) / groups.length);
        },
      );
      operations += result.transactions;
    }
    setState(
      () => (
        _step = _Step.done,
        _groups = groups.length,
        _operations = operations,
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final children = <Widget>[
      Text(l.migrateIntro),
      const SizedBox(height: 8),
      Text(l.migrateAdminNote, style: theme.textTheme.bodySmall),
      const SizedBox(height: 16),
    ];
    switch (_step) {
      case _Step.address:
        children.addAll([
          TextField(
            controller: _address,
            keyboardType: TextInputType.url,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l.serverAddressLabel,
              hintText: 'https://',
            ),
            onSubmitted: (_) => _checkAddress(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _checkAddress,
            child: Text(l.serverAddressConnect),
          ),
        ]);
      case _Step.signIn:
        children.addAll([
          Text(l.serverAddressCurrent(_api.toString())),
          const SizedBox(height: 12),
          if (!_needsCode) ...[
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l.emailLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: l.passwordLabel),
              onSubmitted: (_) => _signIn(),
            ),
          ] else
            TextField(
              controller: _code,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l.migrateCodeLabel),
              onSubmitted: (_) => _signIn(),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _signIn,
            child: Text(l.migrateSignIn),
          ),
        ]);
      case _Step.ready:
        children.add(
          FilledButton.icon(
            icon: const Icon(Icons.cloud_upload_outlined),
            label: Text(l.migrateSend),
            onPressed: _busy ? null : _send,
          ),
        );
      case _Step.sending:
        children.addAll([
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 8),
          Text(l.migrateSending((_progress * 100).round())),
        ]);
      case _Step.done:
        children.addAll([
          Text(
            l.migrateDone(_groups, _operations),
            style: TextStyle(color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(l.migrateSwitchNote, style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => switchToServer(_api!, _session!),
            child: Text(l.migrateSwitch),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.migrateStay),
          ),
        ]);
    }
    if (_error != null) {
      children.addAll([
        const SizedBox(height: 12),
        Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
      ]);
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.migrateTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: children,
          ),
        ),
      ),
    );
  }
}

/// A message already in the user's language.
class _Message implements Exception {
  final String text;
  const _Message(this.text);

  @override
  String toString() => text;
}
