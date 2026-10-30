import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../state/session.dart';
import '../widgets/form_card.dart';
import 'account_flow.dart';

/// First launch: administrator account, then the first group.
class SetupScreen extends StatefulWidget {
  final SessionController session;
  const SetupScreen({super.key, required this.session});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _action = AsyncAction();
  final _name = TextEditingController();
  var _accountCreated = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final m = await _action.run(
      context,
      setState,
      () => client.group.create(_name.text.trim()),
    );
    if (m != null) await widget.session.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (!_accountCreated) {
      return AccountFlow(
        mode: AccountFlowMode.setup,
        onDone: (success) async {
          // Signed in, but stay on this screen for the group step.
          await client.auth.updateSignedInUser(success);
          setState(() => _accountCreated = true);
        },
      );
    }
    return FormCard(
      title: l.setupStepGroup,
      intro: l.groupIntro,
      children: [
        TextField(
          controller: _name,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l.groupNameLabel,
            hintText: l.groupNameHint,
          ),
          onSubmitted: (_) => _createGroup(),
        ),
        ErrorText(_action.error),
        PrimaryButton(
          label: l.continueLabel,
          busy: _action.busy,
          onPressed: _createGroup,
        ),
      ],
    );
  }
}
