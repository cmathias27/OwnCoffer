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
  var _firstStepsHidden = false;
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

  /// « Premiers pas » hidden from the home page.
  bool get firstStepsHidden => _firstStepsHidden;

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
      _firstStepsHidden = flag(await store.read('firstSteps'));
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
}
