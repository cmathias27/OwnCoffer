import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../state/app_lock.dart';
import '../util/device_auth.dart';

/// The device's unlock, as named on buttons.
String deviceMethodName(AppLocalizations l, DeviceAuthKind kind) =>
    switch (kind) {
      DeviceAuthKind.windowsHello => l.lockMethodWindows,
      _ => l.lockMethodAndroid,
    };

/// Above every page (decision 0025): counts touches, clicks and keys, locks
/// when idle too long, and shows the lock screen over the pages, which stay
/// as they were underneath (nothing running is interrupted).
class AppLockLayer extends StatefulWidget {
  final Widget child;
  final AppLock lock;
  const AppLockLayer({super.key, required this.child, required this.lock});

  @override
  State<AppLockLayer> createState() => _AppLockLayerState();
}

class _AppLockLayerState extends State<AppLockLayer>
    with WidgetsBindingObserver {
  static const _checkEvery = Duration(seconds: 15);
  Timer? _timer;
  var _foreground = true;

  AppLock get _lock => widget.lock;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    HardwareKeyboard.instance.addHandler(_onKey);
    _timer = Timer.periodic(_checkEvery, (_) => _lock.check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    HardwareKeyboard.instance.removeHandler(_onKey);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    _lock.activity();
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground = state == AppLifecycleState.resumed;
    if (foreground != _foreground) setState(() => _foreground = foreground);
    switch (state) {
      case AppLifecycleState.resumed:
        // Back from elsewhere: the time away counts as idle time.
        unawaited(_lock.check());
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        unawaited(_lock.persistActivity());
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: (_) => _lock.activity(),
    onPointerSignal: (_) => _lock.activity(),
    onPointerPanZoomStart: (_) => _lock.activity(),
    child: ListenableBuilder(
      listenable: _lock,
      builder: (context, child) {
        final locked = _lock.active && _lock.locked;
        // Android hides the screen itself (FLAG_SECURE); Windows and the web
        // blur it while the window is not the active one.
        final blur =
            _lock.hideContent &&
            !_foreground &&
            !locked &&
            defaultTargetPlatform != TargetPlatform.android;
        return Stack(
          children: [
            // Kept alive, not shown, not focusable while locked.
            Offstage(
              offstage: locked,
              child: ExcludeFocus(
                excluding: locked,
                child: ImageFiltered(
                  enabled: blur,
                  imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: child,
                ),
              ),
            ),
            if (locked)
              Positioned.fill(
                // Its own overlay: the text field needs one.
                child: Overlay(
                  initialEntries: [
                    OverlayEntry(builder: (_) => LockScreen(lock: _lock)),
                  ],
                ),
              ),
          ],
        );
      },
      child: widget.child,
    ),
  );
}

/// The lock screen: the account's password, or the device's own unlock.
class LockScreen extends StatefulWidget {
  final AppLock lock;
  const LockScreen({super.key, required this.lock});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with WidgetsBindingObserver {
  final _password = TextEditingController();
  final _focus = FocusNode();
  DeviceAuthKind _kind = DeviceAuthKind.none;
  var _canUseDevice = false;
  var _busy = false;
  var _away = false;
  String? _error;

  /// After a first unlock with the password: the offer to use the
  /// device's unlock next time, answered before the pages show again.
  Completer<void>? _offer;

  AppLock get _lock => widget.lock;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDevice();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _password.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _loadDevice() async {
    final kind = await _lock.deviceKind();
    final can = await _lock.canUseDevice();
    if (!mounted) return;
    setState(() => (_kind = kind, _canUseDevice = can));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Back to the app after leaving it: the fingerprint or Windows Hello is
    // asked at once. Not after the device's own prompt, which only makes the
    // app inactive: a cancelled prompt must not come back by itself.
    switch (state) {
      case AppLifecycleState.hidden || AppLifecycleState.paused:
        _away = true;
      case AppLifecycleState.resumed when _away:
        _away = false;
        if (_canUseDevice && !_busy) unawaited(_unlockWithDevice());
      default:
        break;
    }
  }

  Future<void> _unlockWithDevice() async {
    final l = AppLocalizations.of(context);
    setState(() => (_busy = true, _error = null));
    final ok = await _lock.unlockWithDevice(l.lockReason);
    if (!mounted) return;
    setState(() => (_busy = false, _error = ok ? null : l.lockDeviceFailed));
  }

  Future<void> _unlockWithPassword() async {
    final l = AppLocalizations.of(context);
    if (_password.text.isEmpty || _busy) return;
    setState(() => (_busy = true, _error = null));
    String? error;
    try {
      final result = await _lock.unlockWithPassword(
        _password.text,
        beforeUnlock: _offerDevice,
      );
      if (result == UnlockResult.wrongPassword) {
        error = l.lockWrongPassword(_lock.attemptsLeft);
      }
    } on AccessDeniedException catch (e) {
      // The server refuses any more tries for now: it counts as a failure.
      if (await _lock.recordFailure() == UnlockResult.wrongPassword) {
        error = serverErrorText(l, e.code);
      }
    } on Object catch (e) {
      // No network: not a wrong password.
      error = errorText(l, e);
    }
    if (!mounted) return;
    _password.clear();
    setState(() => (_busy = false, _error = error));
    if (error != null) _focus.requestFocus();
  }

  Future<void> _offerDevice() async {
    if (!await _lock.shouldOfferDevice() || !mounted) return;
    final offer = Completer<void>();
    setState(() => _offer = offer);
    await offer.future;
  }

  Future<void> _answerOffer(bool yes) async {
    await _lock.setDeviceUnlock(yes);
    _offer?.complete();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final standalone = _lock.standalone;
    final method = deviceMethodName(l, _kind);
    final offer = _offer;
    final List<Widget> children;
    if (offer != null) {
      children = [
        Text(
          l.lockOfferTitle(method),
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(l.lockOfferBody, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => _answerOffer(true),
          child: Text(l.lockOfferYes),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _answerOffer(false),
          child: Text(l.lockOfferNo),
        ),
      ];
    } else {
      children = [
        Icon(Icons.lock_outline, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          l.lockTitle,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          standalone ? l.lockIntroDevice : l.lockIntroPassword,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (!standalone) ...[
          TextField(
            controller: _password,
            focusNode: _focus,
            obscureText: true,
            enabled: !_busy,
            autofocus: !_canUseDevice,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(labelText: l.passwordLabel),
            onSubmitted: (_) => _unlockWithPassword(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _unlockWithPassword,
            child: Text(l.lockUnlock),
          ),
        ],
        if (_canUseDevice) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _busy ? null : _unlockWithDevice,
            icon: Icon(
              _kind == DeviceAuthKind.windowsHello
                  ? Icons.face_outlined
                  : Icons.fingerprint,
            ),
            label: Text(l.lockUseDevice(method)),
          ),
        ],
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        if (!standalone) ...[
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _busy ? null : _lock.signOut,
            icon: const Icon(Icons.logout),
            label: Text(l.signOut),
          ),
        ],
      ];
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
