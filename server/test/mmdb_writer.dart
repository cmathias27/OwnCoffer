import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// A value written as a pointer to [offset] of the data section.
class MmdbPointer {
  final int offset;
  const MmdbPointer(this.offset);
}

/// Writes a small MaxMind DB in memory, as the format describes it, so the
/// reader is tested without the 130 MB database (decision 0027).
class MmdbWriter {
  final int recordSize;
  final int ipVersion;
  final _nodes = <List<Object?>>[
    [null, null],
  ];
  final _data = BytesBuilder();

  MmdbWriter({this.recordSize = 24, this.ipVersion = 6});

  /// Appends [value] to the data section; its offset.
  int add(Object? value) {
    final at = _data.length;
    _data.add(encode(value));
    return at;
  }

  /// Network [cidr] (`82.64.0.0/16`, `2a01:cb00::/32`) points to the data
  /// at [offset].
  void insert(String cidr, int offset) {
    final [ip, bits] = cidr.split('/');
    var address = InternetAddress(ip).rawAddress.toList();
    var prefix = int.parse(bits);
    if (address.length == 4 && ipVersion == 6) {
      address = [...List.filled(12, 0), ...address];
      prefix += 96;
    }
    var node = 0;
    for (var i = 0; i < prefix; i++) {
      final bit = (address[i >> 3] >> (7 - (i & 7))) & 1;
      if (i == prefix - 1) {
        _nodes[node][bit] = ('data', offset);
        break;
      }
      final next = _nodes[node][bit];
      if (next is int) {
        node = next;
      } else {
        _nodes.add([null, null]);
        _nodes[node][bit] = _nodes.length - 1;
        node = _nodes.length - 1;
      }
    }
  }

  static List<int> _size(int type, int size) {
    final head = <int>[];
    final int code;
    final extra = <int>[];
    if (size < 29) {
      code = size;
    } else if (size < 285) {
      code = 29;
      extra.add(size - 29);
    } else if (size < 65821) {
      code = 30;
      final s = size - 285;
      extra.addAll([s >> 8, s & 0xFF]);
    } else {
      code = 31;
      final s = size - 65821;
      extra.addAll([s >> 16, (s >> 8) & 0xFF, s & 0xFF]);
    }
    if (type <= 7) {
      head.add(type << 5 | code);
    } else {
      head.addAll([code, type - 7]);
    }
    return [...head, ...extra];
  }

  static List<int> encode(Object? value) {
    switch (value) {
      case MmdbPointer(:final offset):
        assert(offset < 2048);
        return [1 << 5 | (offset >> 8), offset & 0xFF];
      case String s:
        final b = utf8.encode(s);
        return [..._size(2, b.length), ...b];
      case bool b:
        return _size(14, b ? 1 : 0);
      case double d:
        final b = ByteData(8)..setFloat64(0, d);
        return [..._size(3, 8), ...b.buffer.asUint8List()];
      case int i:
        final bytes = <int>[];
        for (var v = i; v > 0; v >>= 8) {
          bytes.insert(0, v & 0xFF);
        }
        return [..._size(i < 0x10000 ? 5 : 6, bytes.length), ...bytes];
      case List l:
        return [..._size(11, l.length), for (final x in l) ...encode(x)];
      case Map m:
        return [
          ..._size(7, m.length),
          for (final e in m.entries) ...[
            ...encode(e.key as String),
            ...encode(e.value),
          ],
        ];
      default:
        throw ArgumentError(value);
    }
  }

  Uint8List build() {
    final count = _nodes.length;
    int record(Object? r) => switch (r) {
      null => count,
      int n => n,
      (String _, int offset) => count + 16 + offset,
      _ => throw StateError('$r'),
    };
    final out = BytesBuilder();
    for (final [left, right] in _nodes) {
      final l = record(left);
      final r = record(right);
      switch (recordSize) {
        case 24:
          out.add([l >> 16, l >> 8 & 0xFF, l & 0xFF]);
          out.add([r >> 16, r >> 8 & 0xFF, r & 0xFF]);
        case 28:
          out.add([l >> 16 & 0xFF, l >> 8 & 0xFF, l & 0xFF]);
          out.addByte((l >> 24 & 0x0F) << 4 | (r >> 24 & 0x0F));
          out.add([r >> 16 & 0xFF, r >> 8 & 0xFF, r & 0xFF]);
        default:
          for (final v in [l, r]) {
            out.add([v >> 24 & 0xFF, v >> 16 & 0xFF, v >> 8 & 0xFF, v & 0xFF]);
          }
      }
    }
    out.add(List.filled(16, 0));
    out.add(_data.toBytes());
    out.add([0xAB, 0xCD, 0xEF, ...ascii.encode('MaxMind.com')]);
    out.add(
      encode({
        'binary_format_major_version': 2,
        'binary_format_minor_version': 0,
        'database_type': 'Test-City',
        'ip_version': ipVersion,
        'languages': ['en', 'fr'],
        'node_count': count,
        'record_size': recordSize,
      }),
    );
    return out.toBytes();
  }
}

/// Rouen (82.64.0.0/16), Séville (90.0.0.0/8), Belgium without city
/// (81.240.0.0/12), Paris (2a01:cb00::/32).
Uint8List placesFixture({int recordSize = 24, int ipVersion = 6}) {
  final w = MmdbWriter(recordSize: recordSize, ipVersion: ipVersion);
  final france = w.add({
    'geoname_id': 3017382,
    'iso_code': 'FR',
    'is_in_european_union': true,
    'names': {'en': 'France', 'fr': 'France'},
  });
  final rouen = w.add({
    'city': {
      'names': {'en': 'Rouen'},
    },
    'country': const MmdbPointer(0),
    'location': {'latitude': 49.44, 'longitude': 1.1},
  });
  assert(france == 0);
  w.insert('82.64.0.0/16', rouen);
  w.insert(
    '90.0.0.0/8',
    w.add({
      'city': {
        'names': {'en': 'Seville', 'fr': 'Séville'},
      },
      'country': {'iso_code': 'es'},
      'subdivisions': [
        {
          'names': {'en': 'Andalusia'},
        },
      ],
    }),
  );
  w.insert(
    '81.240.0.0/12',
    w.add({
      'country': {'iso_code': 'BE'},
    }),
  );
  w.insert('1.2.3.0/24', w.add({'city': 'not a map'}));
  if (ipVersion == 6) {
    w.insert(
      '2a01:cb00::/32',
      w.add({
        'city': {
          'names': {'en': 'Paris'},
        },
        'country': const MmdbPointer(0),
      }),
    );
  }
  return w.build();
}
