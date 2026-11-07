import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../help/help.dart';
import 'app_lock.dart';
import 'pepite.dart';

/// Pépite's advice on the app (decision 0028, point 12).
final pepiteAdvice = PepiteAdvice(
  store: SecurePepiteStore(),
  tips: () => client.pepiteAdvice.tips(),
  seen: (code) => client.pepiteAdvice.tipSeen(code),
);

/// A « Le savais-tu ? » tip: shown on the first visit of the screen of
/// [topic], whose help page « En savoir plus » opens.
class PepiteTip {
  /// Never changes: the server keeps the codes of the tips seen.
  final String code;
  final HelpTopic topic;
  final String text;

  const PepiteTip(this.code, this.topic, this.text);

  static final _header = RegExp(r'^## ([a-z0-9_]{1,40}) · ([a-z]+)\s*$');

  /// The tips of `assets/tips/<language>/tips.md`: each starts with a line
  /// `## code · topic`, followed by its text. Anything else is skipped.
  static List<PepiteTip> parse(String markdown) {
    final tips = <PepiteTip>[];
    String? code;
    HelpTopic? topic;
    final text = <String>[];
    void close() {
      if (code != null && topic != null && text.isNotEmpty) {
        tips.add(PepiteTip(code, topic, text.join(' ')));
      }
      text.clear();
    }

    for (final raw in markdown.split('\n')) {
      final line = raw.trim();
      if (line.startsWith('#')) {
        close();
        final m = _header.firstMatch(line);
        code = m?[1];
        topic = HelpTopic.values.where((t) => t.name == m?[2]).firstOrNull;
      } else if (line.isNotEmpty && code != null) {
        text.add(line);
      }
    }
    close();
    return tips;
  }

  /// Shipped with the app, in French or English.
  static Future<List<PepiteTip>> load(String language) async => parse(
    await rootBundle.loadString(
      'assets/tips/${language == 'en' ? 'en' : 'fr'}/tips.md',
    ),
  );
}

/// The tips seen (kept by the server, so that another device does not show
/// them again) and the settings of this device: « Afficher les astuces »,
/// separate from « Afficher Pépite », and « Pas maintenant » on the card of
/// « Bien démarrer », which never comes back.
///
/// At most one tip a day: the one shown today stays on its screen until
/// « Compris », and no other is shown that day.
class PepiteAdvice extends ChangeNotifier {
  final LockStore _store;
  final Future<PepiteTips> Function() _fetch;
  final Future<PepiteTips> Function(String code) _seen;
  final Future<List<PepiteTip>> Function(String language) _catalogue;
  final DateTime Function() _now;

  PepiteAdvice({
    required this._store,
    required Future<PepiteTips> Function() tips,
    required this._seen,
    Future<List<PepiteTip>> Function(String language)? catalogue,
    DateTime Function()? now,
  }) : _fetch = tips,
       _catalogue = catalogue ?? PepiteTip.load,
       _now = now ?? DateTime.now;

  var tipsOn = true;
  var startHidden = false;

  /// Codes seen, null until known (or without the server: no tip then).
  Set<String>? _seenCodes;
  DateTime? _lastSeenAt;

  /// The tip shown today: `date|code`.
  String? _shown;
  List<PepiteTip>? _tips;
  String? _language;

  Future<void> signedIn() async {
    try {
      tipsOn = await _store.read('tips') != 'false';
      startHidden = await _store.read('startHidden') == 'true';
      _shown = await _store.read('tipShown');
    } catch (_) {
      // Storage unavailable: defaults.
    }
    try {
      _take(await _fetch());
    } catch (_) {
      _seenCodes = null;
    }
    notifyListeners();
  }

  void signedOut() {
    _seenCodes = null;
    _lastSeenAt = null;
    notifyListeners();
  }

  void _take(PepiteTips t) {
    _seenCodes = t.seen.toSet();
    _lastSeenAt = t.lastSeenAt;
  }

  /// The catalogue in [language], loaded once.
  Future<void> prepare(String language) async {
    if (_language == language && _tips != null) return;
    try {
      _tips = await _catalogue(language);
      _language = language;
      notifyListeners();
    } catch (_) {
      _tips = const [];
    }
  }

  String get _today {
    final n = _now();
    return '${n.year}-${n.month}-${n.day}';
  }

  bool _isToday(DateTime? t) {
    if (t == null) return false;
    final local = t.toLocal();
    final n = _now();
    return local.year == n.year && local.month == n.month && local.day == n.day;
  }

  /// The tip of the screen of [topic], if one is due: tips shown, the
  /// catalogue and the tips seen known, none seen nor shown elsewhere today.
  /// When [force] is true (asked on demand), returns the topic's tip even if
  /// already seen or shown today.
  PepiteTip? tipFor(HelpTopic topic, {bool force = false}) {
    final seen = _seenCodes;
    final tips = _tips;
    if (!tipsOn || tips == null) return null;
    if (force) {
      return tips
              .where(
                (t) => t.topic == topic && !(seen?.contains(t.code) ?? false),
              )
              .firstOrNull ??
          tips.where((t) => t.topic == topic).firstOrNull;
    }
    if (seen == null) return null;
    final shown = _shown?.split('|');
    if (shown != null && shown.length == 2 && shown[0] == _today) {
      final tip = tips.where((t) => t.code == shown[1]).firstOrNull;
      return tip != null && tip.topic == topic && !seen.contains(tip.code)
          ? tip
          : null;
    }
    if (_isToday(_lastSeenAt)) return null;
    final tip = tips
        .where((t) => t.topic == topic && !seen.contains(t.code))
        .firstOrNull;
    if (tip != null) {
      _shown = '$_today|${tip.code}';
      unawaited(_quietly(() => _store.write('tipShown', _shown)));
    }
    return tip;
  }

  /// « Compris » or « En savoir plus »: not shown again, on any device.
  Future<void> seen(PepiteTip tip) async {
    _seenCodes = {...?_seenCodes, tip.code};
    _lastSeenAt = _now().toUtc();
    notifyListeners();
    try {
      _take(await _seen(tip.code));
      notifyListeners();
    } catch (_) {
      // Offline: seen on this device for now; the server learns it next
      // time it is shown and acknowledged.
    }
  }

  Future<void> setTipsOn(bool value) async {
    tipsOn = value;
    notifyListeners();
    await _quietly(() => _store.write('tips', '$value'));
  }

  /// « Pas maintenant » on the card of « Bien démarrer »: the list stays in
  /// Pépite's page.
  Future<void> hideStart() async {
    startHidden = true;
    notifyListeners();
    await _quietly(() => _store.write('startHidden', 'true'));
  }

  static Future<void> _quietly(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Storage unavailable: the setting lasts until the app closes.
    }
  }

  @visibleForTesting
  List<PepiteTip>? get catalogue => _tips;
}
