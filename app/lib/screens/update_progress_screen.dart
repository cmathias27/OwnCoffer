import 'dart:async';

import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../util/page_reload.dart';

/// The steps of an installation, in order, as the host writes them in
/// docker/state/update-progress (see docker/auto-update.sh).
enum UpdateStep { requested, pull, backup, start, check, done }

/// Where an installation stands, from what the server reports.
enum UpdateOutcome { running, done, failed, waiting }

/// The state of the installation of [target] read from [o]; [unreachable]
/// when the server did not answer (it restarts during the installation).
({UpdateStep step, UpdateOutcome outcome}) updateProgress(
  UpdateOverview? o,
  String target, {
  required bool unreachable,
}) {
  if (o != null && 'v${o.runningVersion}' == target) {
    return (step: UpdateStep.done, outcome: UpdateOutcome.done);
  }
  if (unreachable || o == null) {
    return (step: UpdateStep.start, outcome: UpdateOutcome.running);
  }
  if (o.progressTarget != target) {
    return (step: UpdateStep.requested, outcome: UpdateOutcome.running);
  }
  return switch (o.progressStep) {
    'pull' => (step: UpdateStep.pull, outcome: UpdateOutcome.running),
    'backup' => (step: UpdateStep.backup, outcome: UpdateOutcome.running),
    'start' => (step: UpdateStep.start, outcome: UpdateOutcome.running),
    // Installed: done once the new server answers with its version.
    'check' || 'done' => (
      step: UpdateStep.check,
      outcome: UpdateOutcome.running,
    ),
    'rollback' => (step: UpdateStep.check, outcome: UpdateOutcome.running),
    'failed' => (step: UpdateStep.check, outcome: UpdateOutcome.failed),
    'waiting' => (step: UpdateStep.pull, outcome: UpdateOutcome.waiting),
    _ => (step: UpdateStep.requested, outcome: UpdateOutcome.running),
  };
}

/// Shown from the moment an installation is asked for until it ends: the
/// page is held (no going back) and each step is shown as the host carries
/// it out. The server restarts in the middle: its silence is expected.
class UpdateProgressScreen extends StatefulWidget {
  /// vX.Y.Z.
  final String target;

  /// For tests: how often the server is asked.
  final Duration every;

  const UpdateProgressScreen({
    super.key,
    required this.target,
    this.every = const Duration(seconds: 3),
  });

  @override
  State<UpdateProgressScreen> createState() => _UpdateProgressScreenState();
}

class _UpdateProgressScreenState extends State<UpdateProgressScreen> {
  /// Beyond this, the page may be left: the installation goes on anyway.
  static const _slow = Duration(minutes: 15);

  UpdateOverview? _o;
  var _unreachable = false;
  var _rolledBack = false;
  final _started = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _poll();
    _timer = Timer.periodic(widget.every, (_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    try {
      final o = await client.admin.updates();
      if (!mounted) return;
      setState(() {
        _o = o;
        _unreachable = false;
        if (o.progressTarget == widget.target && o.progressStep == 'rollback') {
          _rolledBack = true;
        }
      });
    } on Object {
      if (mounted) setState(() => _unreachable = true);
    }
    final p = updateProgress(_o, widget.target, unreachable: _unreachable);
    if (p.outcome != UpdateOutcome.running) _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = updateProgress(_o, widget.target, unreachable: _unreachable);
    final over = p.outcome != UpdateOutcome.running;
    final slow = !over && DateTime.now().difference(_started) > _slow;
    final steps = UpdateStep.values;
    final index = steps.indexOf(p.step);
    String label(UpdateStep s) => switch (s) {
      UpdateStep.requested => l.updateStepRequested,
      UpdateStep.pull => l.updateStepPull,
      UpdateStep.backup => l.updateStepBackup,
      UpdateStep.start =>
        _unreachable ? l.updateProgressRestarting : l.updateStepStart,
      UpdateStep.check =>
        _rolledBack ? l.updateStepRollback : l.updateStepCheck,
      UpdateStep.done => l.updateStepDone,
    };
    return PopScope(
      canPop: over || slow,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(24),
                children: [
                  Icon(
                    switch (p.outcome) {
                      UpdateOutcome.done => Icons.check_circle,
                      UpdateOutcome.failed => Icons.error,
                      UpdateOutcome.waiting => Icons.schedule,
                      UpdateOutcome.running => Icons.system_update_alt,
                    },
                    size: 56,
                    color: p.outcome == UpdateOutcome.failed
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.updateProgressTitle(widget.target),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    switch (p.outcome) {
                      UpdateOutcome.done => l.updateProgressDone(
                        widget.target,
                      ),
                      UpdateOutcome.failed => l.updateProgressFailed,
                      UpdateOutcome.waiting => l.updateProgressWaiting,
                      UpdateOutcome.running =>
                        slow ? l.updateProgressSlow : l.updateProgressHelp,
                    },
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (!over)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: (index + 0.5) / steps.length,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          for (final (i, s) in steps.indexed)
                            ListTile(
                              dense: true,
                              leading: _StepMark(
                                done:
                                    i < index ||
                                    p.outcome == UpdateOutcome.done,
                                active: i == index && !over,
                                failed:
                                    i == index &&
                                    p.outcome == UpdateOutcome.failed,
                              ),
                              title: Text(
                                label(s),
                                style: i <= index
                                    ? null
                                    : TextStyle(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (p.outcome == UpdateOutcome.done)
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(l.updateProgressReload),
                      onPressed: reloadPage,
                    ),
                  if (p.outcome != UpdateOutcome.done && (over || slow))
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l.updateProgressClose),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepMark extends StatelessWidget {
  final bool done;
  final bool active;
  final bool failed;

  const _StepMark({
    required this.done,
    required this.active,
    required this.failed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (failed) return Icon(Icons.cancel, color: scheme.error);
    if (done) return Icon(Icons.check_circle, color: scheme.primary);
    if (active) {
      return const SizedBox.square(
        dimension: 22,
        child: Padding(
          padding: EdgeInsets.all(2),
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }
    return Icon(Icons.radio_button_unchecked, color: scheme.outline);
  }
}
