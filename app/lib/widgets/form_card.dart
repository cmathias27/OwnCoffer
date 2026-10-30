import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';

/// Centered card used by the sign-in, setup and two-factor screens.
class FormCard extends StatelessWidget {
  final String title;
  final String? intro;
  final List<Widget> children;

  const FormCard({
    super.key,
    required this.title,
    this.intro,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(title, style: theme.textTheme.headlineSmall),
                    if (intro != null) ...[
                      const SizedBox(height: 8),
                      Text(intro!, style: theme.textTheme.bodyMedium),
                    ],
                    const SizedBox(height: 24),
                    ...children,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Runs a server call, shows a spinner on the button and a translated error.
class AsyncAction {
  bool busy = false;
  String? error;

  Future<T?> run<T>(
    BuildContext context,
    void Function(VoidCallback) setState,
    Future<T> Function() call,
  ) async {
    final l = AppLocalizations.of(context);
    setState(() {
      busy = true;
      error = null;
    });
    try {
      return await call();
    } on Object catch (e) {
      setState(() => error = errorText(l, e));
      return null;
    } finally {
      setState(() => busy = false);
    }
  }
}

class ErrorText extends StatelessWidget {
  final String? message;
  const ErrorText(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        message!,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: FilledButton(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    ),
  );
}
