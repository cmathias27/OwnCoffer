import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../client.dart' show isStandalone;
import '../l10n/app_localizations.dart';
import '../util/app_versions.dart';
import '../util/web_search.dart';

/// The Windows and Android apps: this app's version against the server's,
/// and their downloads in the version the server runs.
class AppsScreen extends StatefulWidget {
  final String? serverVersion;

  /// For tests: where links go.
  final void Function(Uri uri)? open;

  const AppsScreen({super.key, required this.serverVersion, this.open});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  String? _app;

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
    final order = isStandalone ? null : AppVersions.compare(_app, server);

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
                      if (!kIsWeb && order == -1)
                        Text(
                          l.appsUpdate(server!),
                          style: TextStyle(color: theme.colorScheme.primary),
                        )
                      else if (!kIsWeb && order == 1)
                        Text(l.appsNewerThanServer)
                      else if (!kIsWeb && order == 0)
                        Text(l.appsUpToDate),
                      if (isStandalone)
                        Text(l.appsStandaloneHint)
                      else if (!published)
                        Text(l.appsDevServer),
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
}
