import 'dart:convert';
import 'dart:typed_data';

/// A file to put in a ZIP archive.
typedef ZipEntry = ({String name, Uint8List bytes, DateTime modified});

final _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

/// CRC-32 (ISO 3309), as ZIP stores it.
int crc32(Uint8List bytes) {
  var c = 0xFFFFFFFF;
  for (final b in bytes) {
    c = _crcTable[(c ^ b) & 0xFF] ^ (c >> 8);
  }
  return c ^ 0xFFFFFFFF;
}

/// A ZIP archive of [entries], stored without compression: invoices are
/// PDFs and photos, already compressed. Names are UTF-8 (flag 11), which
/// every current archiver reads. Under 4 GB and 65 535 files (no ZIP64).
Uint8List buildZip(List<ZipEntry> entries) {
  if (entries.length > 0xFFFF) {
    throw ArgumentError('Too many files for a ZIP archive');
  }
  final out = BytesBuilder(copy: false);
  final central = BytesBuilder(copy: false);
  var offset = 0;

  void u16(BytesBuilder b, int v) => b.add([v & 0xFF, (v >> 8) & 0xFF]);
  void u32(BytesBuilder b, int v) => b.add([
    v & 0xFF,
    (v >> 8) & 0xFF,
    (v >> 16) & 0xFF,
    (v >> 24) & 0xFF,
  ]);

  for (final e in entries) {
    final name = utf8.encode(e.name);
    final crc = crc32(e.bytes);
    final size = e.bytes.length;
    final m = e.modified;
    final year = m.year < 1980 ? 1980 : (m.year > 2107 ? 2107 : m.year);
    final dosTime = (m.hour << 11) | (m.minute << 5) | (m.second ~/ 2);
    final dosDate = ((year - 1980) << 9) | (m.month << 5) | m.day;
    if (offset + 30 + name.length + size > 0xFFFFFFFF) {
      throw ArgumentError('ZIP archive too large');
    }

    final local = BytesBuilder(copy: false);
    u32(local, 0x04034b50);
    u16(local, 20); // version needed
    u16(local, 0x0800); // UTF-8 names
    u16(local, 0); // stored
    u16(local, dosTime);
    u16(local, dosDate);
    u32(local, crc);
    u32(local, size);
    u32(local, size);
    u16(local, name.length);
    u16(local, 0);
    local.add(name);
    final header = local.takeBytes();
    out
      ..add(header)
      ..add(e.bytes);

    u32(central, 0x02014b50);
    u16(central, 20); // made by
    u16(central, 20);
    u16(central, 0x0800);
    u16(central, 0);
    u16(central, dosTime);
    u16(central, dosDate);
    u32(central, crc);
    u32(central, size);
    u32(central, size);
    u16(central, name.length);
    u16(central, 0); // extra
    u16(central, 0); // comment
    u16(central, 0); // disk
    u16(central, 0); // internal attributes
    u32(central, 0); // external attributes
    u32(central, offset);
    central.add(name);
    offset += header.length + size;
  }

  final dir = central.takeBytes();
  out.add(dir);
  final end = BytesBuilder(copy: false);
  u32(end, 0x06054b50);
  u16(end, 0);
  u16(end, 0);
  u16(end, entries.length);
  u16(end, entries.length);
  u32(end, dir.length);
  u32(end, offset);
  u16(end, 0);
  out.add(end.takeBytes());
  return out.takeBytes();
}
