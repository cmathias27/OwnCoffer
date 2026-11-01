import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owncoffer_client/owncoffer_client.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../help/help.dart';

/// Two-factor authentication: enable (QR code, first code, backup codes),
/// renew backup codes, disable.
class SecurityScreen extends StatefulWidget {
  /// Inside another page (an administration tab): no own app bar.
  final bool embedded;
  const SecurityScreen({super.key, this.embedded = false});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  TwoFactorStatus? _status;
  TotpEnrollment? _enrollment;
  List<String>? _backupCodes;
  final _code = TextEditingController();
  String? _error;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s = await client.twoFactor.status();
    if (mounted) setState(() => _status = s);
  }

  Future<void> _run(Future<void> Function() call) async {
    final l = AppLocalizations.of(context);
    setState(() => (_busy = true, _error = null));
    try {
      await call();
      _code.clear();
    } on Object catch (e) {
      setState(() => _error = errorText(l, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = _status;
    final Widget body = status == null
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(l.twoFactorTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                status.enabled
                    ? l.twoFactorOn(status.backupCodesLeft)
                    : l.twoFactorOff,
              ),
              const SizedBox(height: 16),
              if (_backupCodes != null)
                ..._backupView(l, theme)
              else if (_enrollment != null)
                ..._enrollView(l)
              else if (!status.enabled)
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: _busy
                        ? null
                        : () => _run(() async {
                            final e = await client.twoFactor.begin();
                            setState(() => _enrollment = e);
                          }),
                    child: Text(l.twoFactorEnable),
                  ),
                )
              else
                ..._manageView(l),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
            ],
          );
    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.securityTitle),
        actions: const [HelpButton(HelpTopic.security)],
      ),
      body: body,
    );
  }

  Widget _codeField(AppLocalizations l, VoidCallback onSubmit) => SizedBox(
    width: 240,
    child: TextField(
      controller: _code,
      autofillHints: const [AutofillHints.oneTimeCode],
      decoration: InputDecoration(labelText: l.totpCodeLabel),
      onSubmitted: (_) => onSubmit(),
    ),
  );

  List<Widget> _enrollView(AppLocalizations l) {
    final e = _enrollment!;
    void confirm() => _run(() async {
      final codes = await client.twoFactor.confirm(_code.text.trim());
      setState(() => (_enrollment = null, _backupCodes = codes));
    });
    return [
      Text(l.twoFactorScan),
      const SizedBox(height: 16),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: QrImageView(data: e.otpauthUri, size: 200),
        ),
      ),
      const SizedBox(height: 12),
      Text(l.twoFactorSecretManual),
      SelectableText(
        e.secret,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
      ),
      const SizedBox(height: 16),
      _codeField(l, confirm),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton(
          onPressed: _busy ? null : confirm,
          child: Text(l.verify),
        ),
      ),
    ];
  }

  List<Widget> _backupView(AppLocalizations l, ThemeData theme) => [
    Text(l.backupCodesTitle, style: theme.textTheme.titleMedium),
    const SizedBox(height: 8),
    Text(l.backupCodesIntro),
    const SizedBox(height: 12),
    SelectableText(
      _backupCodes!.join('\n'),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
    ),
    const SizedBox(height: 12),
    Wrap(
      spacing: 12,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.copy),
          label: Text(l.copy),
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: _backupCodes!.join('\n'))),
        ),
        FilledButton(
          onPressed: () {
            setState(() => _backupCodes = null);
            _load();
          },
          child: Text(l.backupCodesDone),
        ),
      ],
    ),
  ];

  List<Widget> _manageView(AppLocalizations l) => [
    Text(l.twoFactorDisableIntro),
    const SizedBox(height: 8),
    _codeField(l, () {}),
    const SizedBox(height: 12),
    Wrap(
      spacing: 12,
      children: [
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _run(() async {
                  final codes = await client.twoFactor.renewBackupCodes(
                    _code.text.trim(),
                  );
                  setState(() => _backupCodes = codes);
                }),
          child: Text(l.twoFactorRenew),
        ),
        OutlinedButton(
          onPressed: _busy
              ? null
              : () => _run(() async {
                  await client.twoFactor.disable(_code.text.trim());
                  await _load();
                }),
          child: Text(l.twoFactorDisable),
        ),
      ],
    ),
  ];
}
