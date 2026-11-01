import 'package:owncoffer_server/embedded.dart';
import 'package:test/test.dart';

void main() {
  test('embedded server: this device only', () {
    for (final a in ['127.0.0.1', '::1', '::ffff:127.0.0.1', '127.0.0.5']) {
      expect(isLocalAddress(a), isTrue, reason: a);
    }
    for (final a in [
      '192.168.1.20',
      '::ffff:192.168.1.20',
      '10.0.0.2',
      'fe80::1',
      '',
      'nonsense',
    ]) {
      expect(isLocalAddress(a), isFalse, reason: a);
    }
  });
}
