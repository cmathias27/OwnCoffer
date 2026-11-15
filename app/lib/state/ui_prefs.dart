import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_lock.dart' show LockStore;
import 'home_board.dart';

export 'home_board.dart';

/// Display preferences of this device (decision 0041): never bank data,
/// only choices of how the app looks and what it shows first.
final uiPrefs = UiPrefs(store: SecureUiStore());

class SecureUiStore implements LockStore {
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: 'ui.$key');

  @override
  Future<void> write(String key, String? value) => value == null
      ? _storage.delete(key: 'ui.$key')
      : _storage.write(key: 'ui.$key', value: value);
}

/// A named set of operation filters (decision 0050), kept on the device.
/// [filters] is the same text as the remembered filters.
@immutable
class SavedView {
  final String name;
  final String search;
  final String filters;
  const SavedView({
    required this.name,
    required this.search,
    required this.filters,
  });

  @override
  bool operator ==(Object other) =>
      other is SavedView &&
      other.name == name &&
      other.search == search &&
      other.filters == filters;

  @override
  int get hashCode => Object.hash(name, search, filters);
}

/// At most this many saved views: a short menu, not a database.
const maxSavedViews = 12;

String encodeSavedViews(List<SavedView> views) => jsonEncode([
  for (final v in views) {'n': v.name, 's': v.search, 'f': v.filters},
]);

/// The views kept as JSON; anything unreadable is dropped.
List<SavedView> decodeSavedViews(String? text) {
  if (text == null || text.isEmpty) return const [];
  try {
    final list = jsonDecode(text) as List<Object?>;
    return [
      for (final e in list)
        if (e case {
          'n': final String name,
          's': final String search,
          'f': final String filters,
        })
          SavedView(name: name, search: search, filters: filters),
    ].take(maxSavedViews).toList();
  } on Object {
    return const [];
  }
}

/// The period shared by the home, budget and analysis screens.
enum SharedPeriod { thisMonth, lastMonth, thisYear }

class UiPrefs extends ChangeNotifier {
  final LockStore store;

  UiPrefs({required this.store});

  var _simpleMode = false;
  var _largeText = false;
  var _highContrast = false;
  var _period = SharedPeriod.thisMonth;
  int? _accountId;
  DateTime? _advisorSeenAt;
  String _operationFilters = '';
  List<SavedView> _operationViews = const [];
  var _firstStepsHidden = false;
  var _monthEndCalendar = false;
  var _paydayDismissed = <String>{};
  String? _homeCards;
  final _homeBoards = <int, String?>{};

  /// Hides the advanced functions (rules, community categories, journal,
  /// administration); nothing is turned off on the server.
  bool get simpleMode => _simpleMode;
  bool get largeText => _largeText;
  bool get highContrast => _highContrast;
  SharedPeriod get period => _period;

  /// The account chosen last, kept from one screen to the other.
  int? get accountId => _accountId;

  /// Last visit of « Mon conseiller »: the advice found after it is new.
  DateTime? get advisorSeenAt => _advisorSeenAt;

  /// Last filters of the operations list (`key=value;…`, no search text).
  String get operationFilters => _operationFilters;

  /// The named filter sets of the operations list (decision 0050).
  List<SavedView> get operationViews => _operationViews;

  /// « Premiers pas » hidden from the home page.
  bool get firstStepsHidden => _firstStepsHidden;

  /// The month-end marker of the forecast curve: the last day of the
  /// calendar month rather than of the budget month (the day before the
  /// month start day of the group).
  bool get monthEndCalendar => _monthEndCalendar;

  /// Whether the pay found with [label] on [accountId] was dismissed: it is
  /// not proposed again on this device.
  bool paydayDismissed(int accountId, String label) =>
      _paydayDismissed.contains('$accountId:$label');

  /// The widgets of the home page for a grid of [columns] (decision
  /// 0045): the board saved for it, else the one saved for the other grid,
  /// else the cards chosen with decision 0044, else the home page as it
  /// comes.
  HomeBoard homeBoard(int columns) {
    final saved = HomeBoard.parse(_homeBoards[columns], columns);
    if (saved != null) return saved;
    for (final e in _homeBoards.entries) {
      final other = HomeBoard.parse(e.value, e.key);
      if (other != null) return HomeBoard.reflowed(other, columns);
    }
    return HomeBoard.fromCards(_homeCards, columns) ??
        HomeBoard.defaults(
          columns,
          simple: _simpleMode,
          firstSteps: !_firstStepsHidden,
        );
  }

  /// Text scale applied to the whole app.
  double get textScale => _largeText ? 1.25 : 1.0;

  Future<void> load() async {
    try {
      bool flag(String? v) => v == 'true';
      _simpleMode = flag(await store.read('simple'));
      _largeText = flag(await store.read('largeText'));
      _highContrast = flag(await store.read('contrast'));
      final period = await store.read('period');
      _period =
          SharedPeriod.values.where((p) => p.name == period).firstOrNull ??
          SharedPeriod.thisMonth;
      _accountId = int.tryParse(await store.read('account') ?? '');
      _advisorSeenAt = DateTime.tryParse(await store.read('advisorSeen') ?? '');
      _operationFilters = await store.read('opFilters') ?? '';
      _operationViews = decodeSavedViews(await store.read('opViews'));
      _firstStepsHidden = flag(await store.read('firstSteps'));
      _monthEndCalendar = await store.read('monthEnd') == 'calendar';
      _paydayDismissed = {
        for (final k in (await store.read('paydayDismissed') ?? '').split(';'))
          if (k.isNotEmpty) k,
      };
      _homeCards = await store.read('home');
      for (final columns in const [2, 4]) {
        _homeBoards[columns] = await store.read('home.$columns');
      }
    } on Object {
      // Storage unavailable (private window, tests): defaults.
    }
    notifyListeners();
  }

  /// Only the look of the app is listened to (the whole app is built
  /// again); the other choices are read when a screen opens, and may be
  /// saved while a screen is being built.
  Future<void> _save(String key, String? value, {bool look = false}) async {
    if (look) notifyListeners();
    try {
      await store.write(key, value);
    } on Object {
      // Kept for this run only.
    }
  }

  Future<void> setSimpleMode(bool on) {
    _simpleMode = on;
    return _save('simple', '$on', look: true);
  }

  Future<void> setLargeText(bool on) {
    _largeText = on;
    return _save('largeText', '$on', look: true);
  }

  Future<void> setHighContrast(bool on) {
    _highContrast = on;
    return _save('contrast', '$on', look: true);
  }

  Future<void> setPeriod(SharedPeriod p) {
    if (p == _period) return Future.value();
    _period = p;
    return _save('period', p.name);
  }

  Future<void> setAccountId(int? id) {
    if (id == _accountId) return Future.value();
    _accountId = id;
    return _save('account', id?.toString());
  }

  Future<void> setMonthEndCalendar(bool on) {
    _monthEndCalendar = on;
    return _save('monthEnd', on ? 'calendar' : 'budget');
  }

  Future<void> dismissPayday(int accountId, String label) {
    _paydayDismissed = {..._paydayDismissed, '$accountId:$label'};
    return _save('paydayDismissed', _paydayDismissed.join(';'));
  }

  Future<void> markAdvisorSeen(DateTime at) {
    _advisorSeenAt = at;
    return _save('advisorSeen', at.toUtc().toIso8601String());
  }

  /// Saves the board of its grid; the other grid keeps its own.
  Future<void> setHomeBoard(HomeBoard board) {
    _homeBoards[board.columns] = board.toString();
    return _save('home.${board.columns}', board.toString());
  }

  /// Back to the home page as it comes, on every grid but the one of
  /// [keep], arranged after that.
  Future<void> resetHome({HomeBoard? keep}) async {
    _homeCards = null;
    _firstStepsHidden = false;
    final grids = {..._homeBoards.keys, ?keep?.columns};
    for (final c in grids) {
      _homeBoards[c] = c == keep?.columns ? keep.toString() : null;
    }
    await _save('home', null);
    await _save('firstSteps', null);
    for (final c in grids) {
      await _save('home.$c', _homeBoards[c]);
    }
  }

  Future<void> setOperationFilters(String filters) {
    if (filters == _operationFilters) return Future.value();
    _operationFilters = filters;
    return _save('opFilters', filters);
  }

  /// Saves [view], replacing the one of the same name; the newest first.
  Future<void> saveOperationView(SavedView view) {
    _operationViews = [
      view,
      ..._operationViews.where((v) => v.name != view.name),
    ].take(maxSavedViews).toList();
    return _save('opViews', encodeSavedViews(_operationViews));
  }

  Future<void> removeOperationView(String name) {
    _operationViews = [
      for (final v in _operationViews)
        if (v.name != name) v,
    ];
    return _save(
      'opViews',
      _operationViews.isEmpty ? null : encodeSavedViews(_operationViews),
    );
  }
}
