import 'package:flutter/material.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../state/session.dart';
import '../widgets/form_card.dart';

/// After the password: TOTP or backup code.
class TwoFactorScreen extends StatefulWidget {
  final SessionController session;
  const TwoFactorScreen({super.key, required this.session});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  final _action = AsyncAction();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final success = await _action.run(
      context,
      setState,
      () => client.twoFactor.verify(_code.text.trim()),
    );
    if (success != null) await widget.session.signedIn(success);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FormCard(
      title: l.totpTitle,
      intro: l.totpIntro,
      children: [
        TextField(
          controller: _code,
          autofocus: true,
          autofillHints: const [AutofillHints.oneTimeCode],
          decoration: InputDecoration(labelText: l.totpCodeLabel),
          onSubmitted: (_) => _verify(),
        ),
        ErrorText(_action.error),
        PrimaryButton(label: l.verify, busy: _action.busy, onPressed: _verify),
        TextButton(
          onPressed: widget.session.signOut,
          child: Text(l.cancel),
        ),
      ],
    );
  }
}
