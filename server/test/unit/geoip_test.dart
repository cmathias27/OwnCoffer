import 'dart:io';
import 'dart:typed_data';

import 'package:owncoffer_server/src/security/geoip.dart';
import 'package:test/test.dart';

import '../mmdb_writer.dart';

void main() {
  for (final size in [24, 28, 32]) {
    test('reads places with $size-bit records', () {
      final geo = GeoIp(MmdbReader.bytes(placesFixture(recordSize: size)));
      expect(geo.available, isTrue);
      expect(geo.lookup('82.64.10.20'), (city: 'Rouen', country: 'FR'));
      // The French name first; the country code in capitals.
      expect(geo.lookup('90.1.2.3'), (city: 'Séville', country: 'ES'));
      expect(geo.lookup('81.241.0.1'), (city: null, country: 'BE'));
      expect(geo.lookup('2a01:cb00:1:2::5'), (city: 'Paris', country: 'FR'));
      expect(geo.lookup('::ffff:82.64.10.20'), (city: 'Rouen', country: 'FR'));
      // Not listed, private, malformed, or nothing usable.
      expect(geo.lookup('82.65.0.1'), isNull);
      expect(geo.lookup('192.168.1.1'), isNull);
      expect(geo.lookup('2a02::1'), isNull);
      expect(geo.lookup('pas une IP'), isNull);
      expect(geo.lookup(null), isNull);
      expect(geo.lookup('1.2.3.4'), isNull);
    });
  }

  test('an IPv4-only database', () {
    final geo = GeoIp(MmdbReader.bytes(placesFixture(ipVersion: 4)));
    expect(geo.lookup('82.64.10.20'), (city: 'Rouen', country: 'FR'));
    expect(geo.lookup('::ffff:90.1.2.3'), (city: 'Séville', country: 'ES'));
    expect(geo.lookup('2a01:cb00::1'), isNull);
  });

  test('metadata and data values', () {
    final reader = MmdbReader.bytes(placesFixture(recordSize: 28));
    expect(reader.metadata['database_type'], 'Test-City');
    expect(reader.metadata['languages'], ['en', 'fr']);
    final rouen = reader.lookup([82, 64, 1, 1])! as Map;
    expect(rouen['location'], {'latitude': 49.44, 'longitude': 1.1});
    expect((rouen['country'] as Map)['is_in_european_union'], isTrue);
    expect((rouen['country'] as Map)['geoname_id'], 3017382);
  });

  test('long strings use the longer size forms', () {
    final w = MmdbWriter();
    final long = 'x' * 300;
    final huge = 'y' * 70000;
    w.insert('10.0.0.0/8', w.add({'a': long, 'b': huge, 'c': 'z' * 40}));
    final value = MmdbReader.bytes(w.build()).lookup([10, 0, 0, 1])! as Map;
    expect(value['a'], long);
    expect(value['b'], huge);
    expect(value['c'], 'z' * 40);
  });

  test('a damaged database is refused; a damaged record is unknown', () {
    expect(
      () => MmdbReader.bytes(Uint8List.fromList(List.filled(4096, 7))),
      throwsFormatException,
    );
    final bytes = placesFixture();
    // Cut the data section: lookups fail quietly.
    final w = MmdbWriter();
    w.insert('82.64.0.0/16', w.add({'country': const MmdbPointer(1500)}));
    final broken = GeoIp(MmdbReader.bytes(w.build()));
    expect(broken.lookup('82.64.1.1'), isNull);
    expect(GeoIp(MmdbReader.bytes(bytes)).lookup('82.64.1.1'), isNotNull);
  });

  test('from the environment: off, missing or damaged file', () {
    final dir = Directory.systemTemp.createTempSync('geoip');
    addTearDown(() => dir.deleteSync(recursive: true));
    expect(GeoIp.fromEnvironment({'OWNCOFFER_GEOIP_DB': ''}).available, false);
    expect(
      GeoIp.fromEnvironment({
        'OWNCOFFER_GEOIP_DB': '${dir.path}/absent.mmdb',
      }).available,
      isFalse,
    );
    final bad = File('${dir.path}/bad.mmdb')..writeAsStringSync('nope');
    expect(
      GeoIp.fromEnvironment({'OWNCOFFER_GEOIP_DB': bad.path}).available,
      isFalse,
    );
    final good = File('${dir.path}/good.mmdb')
      ..writeAsBytesSync(placesFixture());
    final geo = GeoIp.fromEnvironment({'OWNCOFFER_GEOIP_DB': good.path});
    expect(geo.lookup('82.64.10.20'), (city: 'Rouen', country: 'FR'));
    expect(GeoIp(null).lookup('82.64.10.20'), isNull);
  });
}
