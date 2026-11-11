import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../state/pepite.dart';
import '../state/pepite_messages.dart';
import '../util/app_versions.dart';
import '../widgets/pepite.dart';
import 'apps_screen.dart';

/// The weekly ritual with Pépite, four steps: import, check, forecast,
/// celebrate. Pépite ticks by herself what she sees (decision 0029) and
/// counts the week once the three are done; "Ouvrir" goes back to the page
/// of the app the step needs (the screen returns that step); the box ticks
/// it without going (no new statement this week, for instance).
class PepiteRitualScreen extends StatelessWidget {
  const PepiteRitualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.pepiteRitualTitle)),
      body: ListenableBuilder(
        listenable: pepite,
        builder: (context, _) {
          final done = pepite.steps;
          final ready = pepite.ritualReady;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  PepiteImage(
                    ready ? PepitePose.cheer : PepitePose.happy,
                    size: 88,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.pepiteRitualIntro)),
                ],
              ),
              const SizedBox(height: 16),
              for (final (step, title, help) in [
                (
                  PepiteStep.statements,
                  l.pepiteStepImport,
                  l.pepiteStepImportHelp,
                ),
                (PepiteStep.check, l.pepiteStepCheck, l.pepiteStepCheckHelp),
                (
                  PepiteStep.forecast,
                  l.pepiteStepForecast,
                  l.pepiteStepForecastHelp,
                ),
              ])
                Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: done.contains(step),
                      onChanged: done.contains(step)
                          ? null
                          : (_) => pepite.markStep(step),
                    ),
                    title: Text(title),
                    subtitle: Text(help),
                    trailing: TextButton(
                      onPressed: () async {
                        await pepite.markStep(step);
                        if (context.mounted) Navigator.of(context).pop(step);
                      },
                      child: Text(l.pepiteOpen),
                    ),
                  ),
                ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.celebration_outlined),
                  title: Text(l.pepiteStepCelebrate),
                  subtitle: Text(l.pepiteStepCelebrateHelp),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: FilledButton.icon(
                  icon: const Icon(Icons.celebration),
                  label: Text(l.pepiteCelebrate),
                  onPressed: ready && !pepite.doneThisWeek
                      ? () async {
                          final apps = await celebrateWithPepite(context);
                          if (!context.mounted) return;
                          final navigator = Navigator.of(context)..pop();
                          if (apps) {
                            await navigator.push(
                              MaterialPageRoute<void>(
                                builder: (_) => AppsScreen(
                                  serverVersion: AppVersions.server,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
