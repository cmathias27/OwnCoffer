import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../util/server_address.dart';
import '../widgets/form_card.dart';

/// First launch of the Windows or Android app: the address of the user's
/// server, checked before it is kept.
class ServerAddressScreen extends StatefulWidget {
  final Future<void> Function() onSaved;

  /// For tests: whether a server answers.
  final Future<bool> Function(Uri api)? check;

  /// Back to the first launch choice (apps that offer the standalone mode).
  final Future<void> Function()? onBack;

  const ServerAddressScreen({
    super.key,
    required this.onSaved,
    this.check,
    this.onBack,
  });

  @override
  State<ServerAddressScreen> createState() => _ServerAddressScreenState();
}

class _ServerAddressScreenState extends State<ServerAddressScreen> {
  final _address = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final l = AppLocalizations.of(context);
    final api = ServerAddress.parse(_address.text);
    if (api == null) {
      setState(() => _error = l.serverAddressInvalid);
      return;
    }
    setState(() => (_busy = true, _error = null));
    final ok = await (widget.check ?? ServerAddress.check)(api);
    if (!mounted) return;
    if (!ok) {
      setState(() => (_busy = false, _error = l.serverAddressUnreachable));
      return;
    }
    await ServerAddress.save(api);
    await widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FormCard(
      title: l.serverAddressTitle,
      intro: l.serverAddressIntro,
      children: [
        TextField(
          controller: _address,
          autofocus: true,
          keyboardType: TextInputType.url,
          autocorrect: false,
          enabled: !_busy,
          decoration: InputDecoration(
            labelText: l.serverAddressLabel,
            hintText: 'https://',
            errorText: _error,
            errorMaxLines: 3,
          ),
          onSubmitted: (_) => _connect(),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _busy ? null : _connect,
          child: _busy
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l.serverAddressConnect),
        ),
        if (widget.onBack != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: _busy ? null : widget.onBack,
            child: Text(l.firstLaunchBack),
          ),
        ],
      ],
    );
  }
}
