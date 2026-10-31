import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/util/web_search.dart';

void main() {
  test('searches the cleaned label only, encoded', () {
    final uri = webSearchUri('  SumUp *Le Café & Co ');
    expect(uri.host, 'www.google.com');
    expect(uri.path, '/search');
    expect(uri.queryParameters, {'q': 'SumUp *Le Café & Co'});
    expect(uri.toString(), isNot(contains(' ')));
  });
}
