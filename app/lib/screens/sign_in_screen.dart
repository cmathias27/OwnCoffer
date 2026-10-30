import 'package:flutter/material.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../state/session.dart';
import '../widgets/form_card.dart';
import 'account_flow.dart';

/// Email + password sign-in, with the invitation and password-reset flows.
class SignInScreen extends StatefulWidget {
  final SessionController session;
  const SignInScreen({super.key, required this.session});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _action = AsyncAction();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late AccountFlowMode? _flow = widget.session.pendingInvitation != null
      ? AccountFlowMode.register
      : null;
  String? _info;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final success = await _action.run(
      context,
      setState,
      () => client.emailIdp.login(
        email: _email.text.trim(),
        password: _password.text,
      ),
    );
    if (success != null) await widget.session.signedIn(success);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final flow = _flow;
    if (flow != null) {
      return AccountFlow(
        mode: flow,
        onCancel: () => setState(() => _flow = null),
        onDone: (success) async {
          if (success != null) {
            await widget.session.signedIn(success);
          } else {
            setState(() => (_flow = null, _info = l.resetDone));
          }
        },
      );
    }
    return FormCard(
      title: l.signInTitle,
      intro: _info,
      children: [
        AutofillGroup(
          child: Column(
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(labelText: l.emailLabel),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(labelText: l.passwordLabel),
                onSubmitted: (_) => _signIn(),
              ),
            ],
          ),
        ),
        ErrorText(_action.error),
        PrimaryButton(label: l.signIn, busy: _action.busy, onPressed: _signIn),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => setState(() => _flow = AccountFlowMode.reset),
          child: Text(l.forgotPassword),
        ),
        TextButton(
          onPressed: () => setState(() => _flow = AccountFlowMode.register),
          child: Text(l.haveInvitation),
        ),
      ],
    );
  }
}
