import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('invoice file names', () {
    test('built from the operation', () {
      expect(
        invoiceFileName(
          originalName: 'IMG_2041.JPG',
          date: LocalDate(2026, 10, 31),
          operationLabel: 'DARTY',
          amountCents: -49900,
          currency: 'EUR',
          label: 'Lave-linge',
        ),
        '2026-10-31 - DARTY - Lave-linge - 499,00 EUR.jpg',
      );
      expect(
        invoiceFileName(
          originalName: 'facture.pdf',
          date: LocalDate(2026, 1, 5),
          operationLabel: 'EDF',
          amountCents: -123456,
          currency: 'EUR',
          label: 'edf',
          index: 2,
        ),
        '2026-01-05 - EDF - 1234,56 EUR (2).pdf',
        reason: 'label repeating the operation is not written twice',
      );
    });

    test('characters refused by file systems are replaced', () {
      expect(
        invoiceFileName(
          originalName: 'a.pdf',
          date: LocalDate(2026, 3, 1),
          operationLabel: 'CB  A/B: "C"*?',
          amountCents: 100,
          currency: 'EUR',
        ),
        '2026-03-01 - CB A_B_ _C___ - 1,00 EUR.pdf',
      );
      expect(safeFileLabel('  fin.. '), 'fin');
      expect(safeFileLabel('x' * 80).length, 60);
    });

    test('without an operation: its label, else the original name', () {
      expect(
        invoiceFileName(originalName: 'scan 12.pdf', label: 'Garantie TV'),
        'Garantie TV.pdf',
      );
      expect(invoiceFileName(originalName: 'scan 12.pdf'), 'scan 12.pdf');
      expect(invoiceFileName(originalName: 'noext'), 'noext');
      expect(fileExtension('.hidden'), '');
    });

    test('names made unique, case-insensitively', () {
      expect(uniqueFileNames(['a.pdf', 'A.pdf', 'a.pdf', 'b']), [
        'a.pdf',
        'A (2).pdf',
        'a (3).pdf',
        'b',
      ]);
    });
  });

  group('zip', () {
    test('crc32 of the standard check value', () {
      expect(crc32(Uint8List.fromList(ascii.encode('123456789'))), 0xCBF43926);
    });

    test('an archive that unzip reads back', () async {
      final entries = <ZipEntry>[
        (
          name: '2026-10-31 - Électricité - 12,00 EUR.pdf',
          bytes: Uint8List.fromList(ascii.encode('%PDF-1.7 hello')),
          modified: DateTime(2026, 10, 31, 12, 30, 10),
        ),
        (
          name: 'empty.txt',
          bytes: Uint8List(0),
          modified: DateTime(1970),
        ),
      ];
      final zip = buildZip(entries);
      expect(zip.sublist(0, 4), [0x50, 0x4b, 0x03, 0x04]);
      // End of central directory: 2 entries.
      final end = zip.length - 22;
      expect(zip.sublist(end, end + 4), [0x50, 0x4b, 0x05, 0x06]);
      expect(zip[end + 10], 2);

      final python = await _which('python3');
      if (python == null) return;
      final dir = await Directory.systemTemp.createTemp('zip_test');
      addTearDown(() => dir.delete(recursive: true));
      final f = File('${dir.path}/t.zip')..writeAsBytesSync(zip);
      final r = await Process.run(python, [
        '-I',
        '-c',
        'import sys,zipfile\n'
            'z=zipfile.ZipFile(sys.argv[1])\n'
            'assert z.testzip() is None\n'
            'for i in z.infolist(): print(i.filename, i.file_size, '
            'z.read(i).decode())',
        f.path,
      ], stdoutEncoding: utf8);
      expect(r.exitCode, 0, reason: '${r.stderr}');
      expect(
        r.stdout,
        '2026-10-31 - Électricité - 12,00 EUR.pdf 14 %PDF-1.7 hello\n'
        'empty.txt 0 \n',
      );
    });
  });
}

Future<String?> _which(String name) async {
  try {
    final r = await Process.run('which', [name]);
    return r.exitCode == 0 ? (r.stdout as String).trim() : null;
  } on ProcessException {
    return null;
  }
}
