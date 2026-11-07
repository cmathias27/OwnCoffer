import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// City and country of an IP address, read from a local MaxMind DB file
/// (decision 0027: DB-IP Lite City, CC BY 4.0, put in the Docker image at
/// build time). Never asks an outside service. Without a file, every place
/// is unknown and nothing else changes.
class GeoIp {
  final MmdbReader? _reader;

  GeoIp(this._reader);

  /// Where the image puts the database; `OWNCOFFER_GEOIP_DB` overrides it,
  /// an empty value turns the lookup off.
  static const defaultPath = '/app/geoip/dbip-city-lite.mmdb';

  factory GeoIp.fromEnvironment(Map<String, String> env) {
    final path = env['OWNCOFFER_GEOIP_DB'] ?? defaultPath;
    if (path.isEmpty) return GeoIp(null);
    try {
      final file = File(path);
      if (!file.existsSync()) return GeoIp(null);
      return GeoIp(MmdbReader.file(file));
    } on Object catch (e) {
      stderr.writeln('GeoIP database not usable ($path): $e');
      return GeoIp(null);
    }
  }

  static GeoIp? _instance;
  static GeoIp get instance =>
      _instance ??= GeoIp.fromEnvironment(Platform.environment);
  static set instance(GeoIp geo) => _instance = geo;

  bool get available => _reader != null;

  /// The place of [ip], or null when unknown (no database, private
  /// address, not listed, damaged file).
  ({String? city, String? country})? lookup(String? ip) {
    final reader = _reader;
    if (reader == null || ip == null) return null;
    final address = InternetAddress.tryParse(ip);
    if (address == null) return null;
    try {
      var raw = address.rawAddress;
      if (_mapped(raw)) raw = raw.sublist(12);
      final record = reader.lookup(raw);
      if (record is! Map) return null;
      final city = _name(record['city']);
      final country = record['country'];
      final iso = country is Map ? country['iso_code'] : null;
      final code = iso is String && iso.length == 2 ? iso.toUpperCase() : null;
      if (city == null && code == null) return null;
      return (city: city, country: code);
    } on Object {
      return null;
    }
  }

  /// `::ffff:82.64.10.20`: an IPv4 address written as IPv6.
  static bool _mapped(List<int> b) =>
      b.length == 16 &&
      b.take(10).every((x) => x == 0) &&
      b[10] == 0xFF &&
      b[11] == 0xFF;

  static String? _name(Object? place) {
    if (place is! Map) return null;
    final names = place['names'];
    if (names is! Map) return null;
    final name = names['fr'] ?? names['en'];
    if (name is! String || name.trim().isEmpty) return null;
    final n = name.trim();
    return n.length > 80 ? n.substring(0, 80) : n;
  }
}

/// Bytes of a database file, read where asked: the whole file (130 MB)
/// never sits in memory.
abstract interface class MmdbSource {
  int get length;
  Uint8List read(int offset, int count);
}

class _FileSource implements MmdbSource {
  final RandomAccessFile _file;
  @override
  final int length;

  _FileSource(this._file) : length = _file.lengthSync();

  @override
  Uint8List read(int offset, int count) {
    if (offset < 0 || offset + count > length) {
      throw const FormatException('MMDB: read outside the file');
    }
    _file.setPositionSync(offset);
    return _file.readSync(count);
  }
}

class _MemorySource implements MmdbSource {
  final Uint8List _bytes;

  _MemorySource(this._bytes);

  @override
  int get length => _bytes.length;

  @override
  Uint8List read(int offset, int count) {
    if (offset < 0 || offset + count > _bytes.length) {
      throw const FormatException('MMDB: read outside the file');
    }
    return Uint8List.sublistView(_bytes, offset, offset + count);
  }
}

/// A small reader of the open MaxMind DB format (version 2), written here
/// rather than taken from a package (decision 0027): metadata, binary
/// search tree with 24, 28 or 32-bit records, data section.
class MmdbReader {
  final MmdbSource _source;
  late final Map<String, Object?> metadata;
  late final int _nodeCount;
  late final int _recordSize;
  late final int _ipVersion;
  late final int _treeSize;
  late final int _dataStart;
  late final int _dataEnd;
  int? _ipv4Start;

  static final _marker = Uint8List.fromList([
    0xAB, 0xCD, 0xEF, //
    ...ascii.encode('MaxMind.com'),
  ]);

  MmdbReader(this._source) {
    final markerAt = _findMarker();
    final meta = _Decoder(
      _source,
      markerAt + _marker.length,
      _source.length,
    ).decode(0).value;
    if (meta is! Map) throw const FormatException('MMDB: bad metadata');
    metadata = meta.cast<String, Object?>();
    _nodeCount = _int(metadata['node_count']);
    _recordSize = _int(metadata['record_size']);
    _ipVersion = _int(metadata['ip_version']);
    if (![24, 28, 32].contains(_recordSize)) {
      throw FormatException('MMDB: record size $_recordSize');
    }
    if (_ipVersion != 4 && _ipVersion != 6) {
      throw FormatException('MMDB: IP version $_ipVersion');
    }
    _treeSize = _nodeCount * _recordSize * 2 ~/ 8;
    _dataStart = _treeSize + 16;
    _dataEnd = markerAt;
    if (_dataStart > _dataEnd) throw const FormatException('MMDB: too short');
  }

  factory MmdbReader.file(File file) {
    final open = file.openSync();
    try {
      return MmdbReader(_FileSource(open));
    } on Object {
      open.closeSync();
      rethrow;
    }
  }

  factory MmdbReader.bytes(Uint8List bytes) => MmdbReader(_MemorySource(bytes));

  static int _int(Object? v) {
    if (v is int) return v;
    if (v is BigInt && v.isValidInt) return v.toInt();
    throw const FormatException('MMDB: bad metadata number');
  }

  /// The metadata starts after the last marker, within the last 128 KiB.
  int _findMarker() {
    final window = _source.length < 128 * 1024 ? _source.length : 128 * 1024;
    final start = _source.length - window;
    final tail = _source.read(start, window);
    for (var i = tail.length - _marker.length; i >= 0; i--) {
      var hit = true;
      for (var j = 0; j < _marker.length; j++) {
        if (tail[i + j] != _marker[j]) {
          hit = false;
          break;
        }
      }
      if (hit) return start + i;
    }
    throw const FormatException('MMDB: no metadata');
  }

  int _record(int node, int bit) {
    final bytes = _source.read(node * _recordSize * 2 ~/ 8, _recordSize ~/ 4);
    switch (_recordSize) {
      case 24:
        final o = bit * 3;
        return bytes[o] << 16 | bytes[o + 1] << 8 | bytes[o + 2];
      case 28:
        if (bit == 0) {
          return (bytes[3] & 0xF0) << 20 |
              bytes[0] << 16 |
              bytes[1] << 8 |
              bytes[2];
        }
        return (bytes[3] & 0x0F) << 24 |
            bytes[4] << 16 |
            bytes[5] << 8 |
            bytes[6];
      default:
        final o = bit * 4;
        return bytes[o] << 24 |
            bytes[o + 1] << 16 |
            bytes[o + 2] << 8 |
            bytes[o + 3];
    }
  }

  int _walk(int node, List<int> address, int bits) {
    for (var i = 0; i < bits && node < _nodeCount; i++) {
      final bit = (address[i >> 3] >> (7 - (i & 7))) & 1;
      node = _record(node, bit);
    }
    return node;
  }

  /// The record of [address] (4 or 16 bytes), or null when not listed.
  Object? lookup(List<int> address) {
    var bytes = address;
    if (bytes.length == 16 && _ipVersion == 4) {
      // An IPv4-mapped address in an IPv4-only database.
      if (!GeoIp._mapped(bytes)) return null;
      bytes = bytes.sublist(12);
    }
    final int node;
    if (bytes.length == 4 && _ipVersion == 6) {
      // IPv4 addresses live under ::/96 of an IPv6 tree.
      final start = _ipv4Start ??= _walk(0, List.filled(12, 0), 96);
      node = _walk(start, bytes, 32);
    } else {
      node = _walk(0, bytes, bytes.length * 8);
    }
    if (node <= _nodeCount) return null; // == node count: not listed.
    final offset = node - _nodeCount - 16;
    return _Decoder(_source, _dataStart, _dataEnd).decode(offset).value;
  }
}

/// Decodes values of a data section beginning at [base].
class _Decoder {
  final MmdbSource _source;
  final int base;
  final int end;

  _Decoder(this._source, this.base, this.end);

  /// Value at section [offset], and the offset just after it.
  ({Object? value, int next}) decode(int offset, {int depth = 0}) {
    if (depth > 32) throw const FormatException('MMDB: nested too deep');
    var at = offset;
    int byte() {
      final b = _source.read(base + at, 1)[0];
      at++;
      return b;
    }

    if (base + at >= end) throw const FormatException('MMDB: outside data');
    final control = byte();
    var type = control >> 5;
    if (type == 1) {
      // Pointer: its target is decoded in place, then reading goes on here.
      final ss = (control >> 3) & 3;
      final vvv = control & 7;
      final int pointer;
      switch (ss) {
        case 0:
          pointer = vvv << 8 | byte();
        case 1:
          pointer = (vvv << 16 | byte() << 8 | byte()) + 2048;
        case 2:
          pointer = (vvv << 24 | byte() << 16 | byte() << 8 | byte()) + 526336;
        default:
          pointer = byte() << 24 | byte() << 16 | byte() << 8 | byte();
      }
      return (value: decode(pointer, depth: depth + 1).value, next: at);
    }
    if (type == 0) type = 7 + byte();
    var size = control & 0x1F;
    if (size == 29) {
      size = 29 + byte();
    } else if (size == 30) {
      size = 285 + (byte() << 8 | byte());
    } else if (size == 31) {
      size = 65821 + (byte() << 16 | byte() << 8 | byte());
    }
    Uint8List take(int n) {
      if (base + at + n > end) throw const FormatException('MMDB: too long');
      final b = _source.read(base + at, n);
      at += n;
      return b;
    }

    int unsigned(Uint8List b) {
      var v = 0;
      for (final x in b) {
        v = v << 8 | x;
      }
      return v;
    }

    switch (type) {
      case 2: // UTF-8 string
        return (value: utf8.decode(take(size)), next: at);
      case 3: // double
        return (
          value: ByteData.sublistView(take(8)).getFloat64(0),
          next: at,
        );
      case 4: // bytes
        return (value: Uint8List.fromList(take(size)), next: at);
      case 5 || 6: // uint16, uint32
        return (value: unsigned(take(size)), next: at);
      case 7: // map
        final map = <String, Object?>{};
        for (var i = 0; i < size; i++) {
          final key = decode(at, depth: depth + 1);
          if (key.value is! String) {
            throw const FormatException('MMDB: map key not a string');
          }
          final value = decode(key.next, depth: depth + 1);
          map[key.value! as String] = value.value;
          at = value.next;
        }
        return (value: map, next: at);
      case 8: // int32
        var v = unsigned(take(size));
        if (size == 4 && v >= 0x80000000) v -= 0x100000000;
        return (value: v, next: at);
      case 9 || 10: // uint64, uint128
        var v = BigInt.zero;
        for (final x in take(size)) {
          v = v << 8 | BigInt.from(x);
        }
        return (value: v.isValidInt ? v.toInt() : v, next: at);
      case 11: // array
        final list = <Object?>[];
        for (var i = 0; i < size; i++) {
          final item = decode(at, depth: depth + 1);
          list.add(item.value);
          at = item.next;
        }
        return (value: list, next: at);
      case 14: // boolean: the value is the size
        return (value: size != 0, next: at);
      case 15: // float
        return (
          value: ByteData.sublistView(take(4)).getFloat32(0),
          next: at,
        );
      default:
        throw FormatException('MMDB: data type $type');
    }
  }
}
