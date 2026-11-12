import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_lock.dart' show LockStore;

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
enum SharedPeriod { thisMonth, lastMonth, twelveMonths }

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
    } on Object {
      // Storage unavailable (private window, tests): defaults.
    }
    notifyListeners();
  }

  Future<void> _save(String key, String? value) async {
    notifyListeners();
    try {
      await store.write(key, value);
    } on Object {
      // Kept for this run only.
    }
  }

  Future<void> setSimpleMode(bool on) {
    _simpleMode = on;
    return _save('simple', '$on');
  }

  Future<void> setLargeText(bool on) {
    _largeText = on;
    return _save('largeText', '$on');
  }

  Future<void> setHighContrast(bool on) {
    _highContrast = on;
    return _save('contrast', '$on');
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

  Future<void> setOperationFilters(String filters) {
    if (filters == _operationFilters) return Future.value();
    _operationFilters = filters;
    return _save('opFilters', filters);
  }
}
