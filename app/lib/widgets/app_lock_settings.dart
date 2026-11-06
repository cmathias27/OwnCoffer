import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../state/app_lock.dart';
import '../util/device_auth.dart';
import 'app_lock_layer.dart';

/// The automatic lock's settings, in the Security page (decision 0025).
/// They belong to this device, not to the account.
class AppLockSettings extends StatefulWidget {
  final AppLock lock;
  const AppLockSettings({super.key, required this.lock});

  @override
  State<AppLockSettings> createState() => _AppLockSettingsState();
}

class _AppLockSettingsState extends State<AppLockSettings> {
  DeviceAuthKind? _kind;

  AppLock get _lock => widget.lock;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _lock.load();
    final kind = await _lock.deviceKind();
    if (mounted) setState(() => _kind = kind);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final kind = _kind;
    if (kind == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: _lock,
      builder: (context, _) {
        final standalone = _lock.standalone;
        final hasDevice = kind != DeviceAuthKind.none;
        // Standalone: no password, the device's lock is the only way back.
        final canEnable = !standalone || hasDevice;
        final method = deviceMethodName(l, kind);
        final android = defaultTargetPlatform == TargetPlatform.android;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.lockSettingsTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.lockSettingsIntro),
            const SizedBox(height: 4),
            Text(standalone ? l.lockSettingsDevice : l.lockSettingsPassword),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.lockEnable),
              subtitle: canEnable ? null : Text(l.lockNeedsDeviceLock),
              value: _lock.enabled,
              onChanged: canEnable || _lock.enabled ? _lock.setEnabled : null,
            ),
            if (_lock.enabled) ...[
              Text(l.lockDelay, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (final m in AppLock.timeouts)
                    ButtonSegment(value: m, label: Text(l.lockMinutes(m))),
                ],
                selected: {_lock.minutes},
                onSelectionChanged: (s) => _lock.setMinutes(s.first),
              ),
              if (!standalone && hasDevice)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.lockUseDeviceSetting(method)),
                  value: _lock.deviceUnlock,
                  onChanged: _lock.setDeviceUnlock,
                ),
              if (!standalone)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l.lockSignOutRule,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _lock.lockNow,
                icon: const Icon(Icons.lock_outline),
                label: Text(l.lockNow),
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.lockHideContent),
              subtitle: Text(
                android ? l.lockHideContentAndroid : l.lockHideContentHelp,
              ),
              value: _lock.hideContent,
              onChanged: _lock.setHideContent,
            ),
          ],
        );
      },
    );
  }
}
