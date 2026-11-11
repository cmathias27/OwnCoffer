import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../client.dart' show isStandalone;
import '../l10n/app_localizations.dart';
import '../state/pepite.dart';
import '../state/pepite_messages.dart';
import '../util/app_update.dart';
import '../util/app_versions.dart';
import '../util/web_search.dart';
import '../widgets/app_update_flow.dart';
import '../widgets/pepite.dart';

/// Opens [AppsScreen] from anywhere (Pépite's invitations).
Future<void> openApps(BuildContext context) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => AppsScreen(serverVersion: AppVersions.server),
  ),
);

/// The Windows and Android apps: this app's version against the server's,
/// and their downloads in the version the server runs.
class AppsScreen extends StatefulWidget {
  final String? serverVersion;

  /// For tests: where links go.
  final void Function(Uri uri)? open;

  /// What the apps add, said in a browser (tests say it elsewhere too).
  final bool? why;

  /// Tests give their own; the app's otherwise.
  final Pepite? pepiteController;

  /// Tests give their own; the device's otherwise (decision 0032).
  final AppUpdater? updater;

  /// Standalone or not; the app's mode otherwise.
  final bool? standalone;

  const AppsScreen({
    super.key,
    required this.serverVersion,
    this.open,
    this.why,
    this.pepiteController,
    this.updater,
    this.standalone,
  });

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  String? _app;

  /// Standalone: the latest published version, once asked (decision 0032).
  String? _latest;
  bool _checked = false;
  bool _checking = false;

  AppUpdater get _updater => widget.updater ?? appUpdater;
  bool get _standalone => widget.standalone ?? isStandalone;

  Future<void> _checkLatest() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _checking = true);
    try {
      final latest = await _updater.latest();
      if (!mounted) return;
      setState(() {
        _latest = latest;
        _checked = true;
      });
    } on AppUpdateException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(appUpdateErrorText(l, e.code))),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Widget _install(AppLocalizations l, String version) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: FilledButton.icon(
      key: const Key('apps-install'),
      icon: const Icon(Icons.system_update),
      label: Text(l.appsInstall(version)),
      onPressed: () => installAppUpdate(
        context,
        version,
        updater: _updater,
        open: widget.open,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    AppVersions.app().then((v) {
      if (mounted) setState(() => _app = v);
    });
  }

  void _open(Uri uri) => (widget.open ?? openLink)(uri);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final server = widget.serverVersion;
    final published = AppVersions.parse(server) != null;
    final order = _standalone ? null : AppVersions.compare(_app, server);
    final latest = _latest;
    final newer = latest != null && AppVersions.compare(_app, latest) == -1;

    Widget platform(String id, IconData icon, String title, String help) {
      final uri = AppVersions.download(server, id);
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(help),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FilledButton.icon(
                  icon: const Icon(Icons.download_outlined),
                  label: Text(l.appsDownload),
                  onPressed: () =>
                      _open(uri ?? AppVersions.releasePage(server)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.appsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.appsIntro),
              const SizedBox(height: 12),
              if (widget.why ?? kIsWeb) ...[
                _why(context, l),
                const SizedBox(height: 12),
              ],
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.appsThisApp(_app ?? l.appsUnknown)),
                      // Standalone: the server is this app.
                      if (!isStandalone)
                        Text(l.appsServer(server ?? l.appsUnknown)),
                      const SizedBox(height: 8),
                      if (!kIsWeb && order == -1) ...[
                        Text(
                          l.appsUpdate(server!),
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                        if (_updater.supported) _install(l, server),
                      ] else if (!kIsWeb && order == 1)
                        Text(l.appsNewerThanServer)
                      else if (!kIsWeb && order == 0)
                        Text(l.appsUpToDate),
                      if (_standalone)
                        Text(l.appsStandaloneHint)
                      else if (!published)
                        Text(l.appsDevServer),
                      if (_standalone && _updater.supported) ...[
                        const SizedBox(height: 8),
                        if (_checked && newer) ...[
                          Text(
                            l.appsLatest(latest),
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                          _install(l, latest),
                        ] else if (_checked)
                          Text(l.appsLatestNone),
                        if (!newer)
                          OutlinedButton.icon(
                            key: const Key('apps-check-latest'),
                            icon: const Icon(Icons.refresh),
                            label: Text(l.appsCheckLatest),
                            onPressed: _checking ? null : _checkLatest,
                          ),
                      ],
                      if (_updater.supported) ...[
                        const SizedBox(height: 8),
                        Text(
                          l.appsInstallHelp,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              platform(
                'android',
                Icons.android,
                l.appsAndroid,
                l.appsAndroidHelp,
              ),
              const SizedBox(height: 12),
              platform(
                'windows',
                Icons.desktop_windows_outlined,
                l.appsWindows,
                l.appsWindowsHelp,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: Text(l.appsAllFiles),
                onPressed: () => _open(AppVersions.releasePage(server)),
              ),
              const SizedBox(height: 8),
              Text(l.appsNote, style: theme.textTheme.bodySmall),
              if (kIsWeb) ...[
                const SizedBox(height: 8),
                Text(l.appsWebHint, style: theme.textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// What the apps add (decision 0027, point 8), with Pépite unless she is
  /// hidden.
  Widget _why(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    final mascot = (widget.pepiteController ?? pepite).enabled;
    Widget item(IconData icon, String title, String help) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(help),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mascot)
              Row(
                children: [
                  const PepiteImage(PepitePose.wave, size: 72),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.appsWhyPepite,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(l.appsWhyTitle, style: theme.textTheme.titleMedium),
            item(
              Icons.notifications_active_outlined,
              l.appsWhyReminder,
              l.appsWhyReminderHelp,
            ),
            item(Icons.fingerprint, l.appsWhyUnlock, l.appsWhyUnlockHelp),
            item(
              Icons.phonelink_lock_outlined,
              l.appsWhyStandalone,
              l.appsWhyStandaloneHelp,
            ),
            if (mascot)
              item(
                Icons.emoji_events_outlined,
                l.pepiteBadgeNomad,
                l.appsWhyBadgeHelp(pepiteBadgeSeeds),
              ),
          ],
        ),
      ),
    );
  }
}
