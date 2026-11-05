import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/standalone_backups.dart';

void main() {
  final now = DateTime.utc(2026, 11, 5, 12);

  test('a backup is due: never made, a day old, or dated in the future', () {
    expect(StandaloneBackups.isDue(null, now), isTrue);
    expect(
      StandaloneBackups.isDue(now.subtract(const Duration(hours: 23)), now),
      isFalse,
    );
    expect(
      StandaloneBackups.isDue(now.subtract(const Duration(days: 1)), now),
      isTrue,
    );
    // The clock was set back: back up now rather than in a year.
    expect(StandaloneBackups.isDue(DateTime.utc(2027, 11, 5), now), isTrue);
  });

  test('file names sort by date', () {
    final a = StandaloneBackups.fileName(DateTime(2026, 11, 5, 9, 5, 3));
    final b = StandaloneBackups.fileName(DateTime(2026, 11, 5, 10, 0));
    expect(a, 'owncoffer-20261105-090503.ocbackup');
    expect(a.compareTo(b), lessThan(0));
  });
}
