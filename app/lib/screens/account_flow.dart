import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../widgets/form_card.dart';

enum AccountFlowMode {
  /// First launch: setup code + email, code, password.
  setup,

  /// Account from an invitation: email, code, password.
  register,

  /// Forgotten password: email, code, new password.
  reset,
}

/// Email → verification code → password, for the three cases above.
class AccountFlow extends StatefulWidget {
  final AccountFlowMode mode;

  /// Signed in (setup, register) — or null after a password reset.
  final Future<void> Function(AuthSuccess? success) onDone;
  final VoidCallback? onCancel;

  const AccountFlow({
    super.key,
    required this.mode,
    required this.onDone,
    this.onCancel,
  });

  @override
  State<AccountFlow> createState() => _AccountFlowState();
}

class _AccountFlowState extends State<AccountFlow> {
  final _action = AsyncAction();
  final _setupCode = TextEditingController();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _step = 0;
  UuidValue? _requestId;
  String? _token;
  String? _localError;

  @override
  void dispose() {
    for (final c in [_setupCode, _email, _code, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _next() async {
    final email = _email.text.trim();
    switch (_step) {
      case 0:
        final id = await _action.run(context, setState, () async {
          if (widget.mode == AccountFlowMode.setup) {
            await client.setup.start(_setupCode.text.trim(), email);
          }
          return widget.mode == AccountFlowMode.reset
              ? client.emailIdp.startPasswordReset(email: email)
              : client.emailIdp.startRegistration(email: email);
        });
        if (id != null) setState(() => (_requestId = id, _step = 1));
      case 1:
        final token = await _action.run(
          context,
          setState,
          () => widget.mode == AccountFlowMode.reset
              ? client.emailIdp.verifyPasswordResetCode(
                  passwordResetRequestId: _requestId!,
                  verificationCode: _code.text.trim(),
                )
              : client.emailIdp.verifyRegistrationCode(
                  accountRequestId: _requestId!,
                  verificationCode: _code.text.trim(),
                ),
        );
        if (token != null) setState(() => (_token = token, _step = 2));
      case 2:
        final l = AppLocalizations.of(context);
        if (_password.text != _confirm.text) {
          setState(() => _localError = l.passwordsDiffer);
          return;
        }
        setState(() => _localError = null);
        if (widget.mode == AccountFlowMode.reset) {
          final ok = await _action.run(context, setState, () async {
            await client.emailIdp.finishPasswordReset(
              finishPasswordResetToken: _token!,
              newPassword: _password.text,
            );
            return true;
          });
          if (ok == true) await widget.onDone(null);
        } else {
          final success = await _action.run(
            context,
            setState,
            () => client.emailIdp.finishRegistration(
              registrationToken: _token!,
              password: _password.text,
            ),
          );
          if (success != null) await widget.onDone(success);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (title, intro) = switch (widget.mode) {
      AccountFlowMode.setup => (l.setupTitle, l.setupIntro),
      AccountFlowMode.register => (l.registerTitle, l.registerIntro),
      AccountFlowMode.reset => (l.resetTitle, l.resetIntro),
    };
    return FormCard(
      title: title,
      intro: _step == 0 ? intro : l.verifyIntro(_email.text.trim()),
      children: [
        if (_step == 0) ...[
          if (widget.mode == AccountFlowMode.setup) ...[
            TextField(
              controller: _setupCode,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              decoration: InputDecoration(
                labelText: l.setupCodeLabel,
                helperText: l.setupCodeHelp,
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(labelText: l.emailLabel),
            onSubmitted: (_) => _next(),
          ),
        ],
        if (_step == 1)
          TextField(
            controller: _code,
            autofocus: true,
            autofillHints: const [AutofillHints.oneTimeCode],
            decoration: InputDecoration(
              labelText: l.verificationCodeLabel,
              helperText: l.verificationCodeHelp,
              helperMaxLines: 2,
            ),
            onSubmitted: (_) => _next(),
          ),
        if (_step == 2) ...[
          TextField(
            controller: _password,
            obscureText: true,
            autofocus: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(
              labelText: l.passwordLabel,
              helperText: l.passwordHelp,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirm,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: InputDecoration(labelText: l.passwordConfirmLabel),
            onSubmitted: (_) => _next(),
          ),
        ],
        ErrorText(_localError ?? _action.error),
        PrimaryButton(
          label: l.continueLabel,
          busy: _action.busy,
          onPressed: _next,
        ),
        if (widget.onCancel != null)
          TextButton(onPressed: widget.onCancel, child: Text(l.back)),
      ],
    );
  }
}
