import 'dart:convert';
import 'dart:io';

import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

List<int> fixture(String name) => File('test/fixtures/$name').readAsBytesSync();

List<int> latin(String s) => latin1.encode(s);

void main() {
  group('decodeBankFile', () {
    test('UTF-8 with BOM', () {
      final d = decodeBankFile([0xEF, 0xBB, 0xBF, ...utf8.encode('Café\r\n')]);
      expect(d.text, 'Café\n');
      expect(d.encoding, 'utf-8');
    });
    test('Windows-1252 with euro sign and curly quote', () {
      final d = decodeBankFile([0x43, 0x61, 0x66, 0xE9, 0x20, 0x80, 0x92]);
      expect(d.text, 'Café €’');
      expect(d.encoding, 'windows-1252');
    });
  });

  group('QIF', () {
    late ParsedStatement s;
    setUp(() => s = parseQif(fixture('sample_bank.qif')));

    test('reads every record with exact amounts', () {
      expect(s.issues, isEmpty);
      expect(s.transactions, hasLength(9));
      expect(s.transactions.map((t) => t.amountCents), [
        -65000,
        215035,
        -4512,
        -250,
        -250,
        -6000,
        -7142,
        -1999,
        1200,
      ]);
      expect(sumCents(s.transactions.map((t) => t.amountCents)), 131082);
    });

    test('keeps label, memo and dates', () {
      final rent = s.transactions.first;
      expect(rent.date, LocalDate(2026, 10, 1));
      expect(rent.label, 'PRLV SEPA AGENCE LOGEMENT EXEMPLE');
      expect(rent.memo, 'LOYER OCTOBRE REF 2026100001');
      expect(s.firstDate, LocalDate(2026, 10, 1));
      expect(s.lastDate, LocalDate(2026, 10, 8));
    });

    test('Windows-1252 accents', () {
      final bytes = latin(
        '!Type:Bank\nD04/10/2026\nT-3,20\nPCB CAF\xc9 DE LA GARE\n^\n',
      );
      final t = parseQif(bytes).transactions.single;
      expect(t.label, 'CB CAFÉ DE LA GARE');
    });

    test('skips broken records with precise errors, keeps the rest', () {
      final bytes = utf8.encode(
        '!Type:Bank\n'
        'D31/02/2026\nT-1,00\nPBAD DATE\n^\n'
        'D01/03/2026\nT-1,234\nPBAD AMOUNT\n^\n'
        'T-5,00\nPNO DATE\n^\n'
        'D02/03/2026\nPNO AMOUNT\n^\n'
        'D03/03/2026\nT-7,00\nPOK\n^\n'
        'D04/03/2026\nT-8,00\nPNO END MARKER\n',
      );
      final r = parseQif(bytes);
      expect(r.transactions.map((t) => t.label), ['OK', 'NO END MARKER']);
      expect(r.issues.map((i) => i.code), [
        'invalid_date',
        'invalid_amount',
        'missing_date',
        'missing_amount',
        'qif_missing_end',
      ]);
      expect(r.issues.first.line, 2);
      expect(r.hasErrors, isTrue);
    });

    test('ignores non-bank sections and account blocks', () {
      final bytes = utf8.encode(
        '!Option:AutoSwitch\n!Account\nNCompte\nTBank\n^\n!Clear:AutoSwitch\n'
        '!Type:Cat\nNAlimentation\nE\n^\n'
        '!Type:Bank\nD01/01/2026\nT1,00\nPA\n^\n',
      );
      final r = parseQif(bytes);
      expect(r.transactions, hasLength(1));
      expect(r.issues.single.code, 'qif_section_skipped');
    });

    test('U is used only when T is missing', () {
      final r = parseQif(
        utf8.encode(
          '!Type:Bank\nD01/01/2026\nU-9,00\nT-10,00\nPA\n^\n'
          'D01/01/2026\nU-11,00\nPB\n^\n',
        ),
      );
      expect(r.transactions.map((t) => t.amountCents), [-1000, -1100]);
    });

    test('rejects a file without header', () {
      expect(
        () => parseQif(utf8.encode('D01/01/2026\nT1,00\n^\n')),
        throwsA(isA<StatementFormatException>()),
      );
    });
  });

  group('OFX', () {
    test('SGML: amounts, dates, ids, balance, entities', () {
      final s = parseOfx(fixture('sample_sgml.ofx'));
      expect(s.transactions, hasLength(3));
      expect(s.transactions.map((t) => t.amountCents), [-4512, 215035, -7142]);
      expect(s.transactions[1].date, LocalDate(2026, 10, 2));
      expect(s.transactions[1].memo, 'SALAIRE OCTOBRE');
      expect(s.transactions[2].label, 'PRLV SEPA EDF SA & CO');
      expect(s.transactions.map((t) => t.bankId), [
        'FIT0001',
        'FIT0002',
        'FIT0003',
      ]);
      expect(s.issues.single.code, 'invalid_date');
      expect(s.accountNumber, '00000000000');
      expect(s.statedBalanceCents, 138581);
      expect(s.statedBalanceDate, LocalDate(2026, 10, 31));
    });

    test('XML', () {
      final s = parseOfx(fixture('sample_xml.ofx'));
      expect(s.issues, isEmpty);
      expect(s.transactions.map((t) => t.amountCents), [-1999, -3000]);
      expect(s.transactions[1].reference, '0000123');
      expect(s.statedBalanceCents, 100000);
    });

    test('rejects a non-OFX file', () {
      expect(
        () => parseOfx(utf8.encode('hello')),
        throwsA(isA<StatementFormatException>()),
      );
    });
  });

  group('CSV', () {
    test('current Caisse d\'Épargne layout, debit/credit columns', () {
      final s = parseCsv(fixture('sample_bank.csv'));
      expect(s.issues, isEmpty);
      expect(s.transactions.map((t) => t.amountCents), [-4512, 215035, -7142]);
      expect(s.transactions.first.date, LocalDate(2026, 10, 3));
      expect(s.transactions.first.label, 'CB CARREFOUR MARKET FACT 021026');
      expect(s.transactions[1].memo, 'SALAIRE OCTOBRE');
      expect(s.transactions[2].memo, 'ECH/061026; MDT/000');
      expect(s.transactions.first.reference, '0000001');
    });

    test('legacy layout in Windows-1252 with a preamble and a footer', () {
      final s = parseCsv(fixture('sample_legacy_cp1252.csv'));
      expect(s.encoding, 'windows-1252');
      expect(s.transactions.map((t) => t.amountCents), [-4512, 215035, -320]);
      expect(s.transactions[2].label, 'CB CAFÉ DE LA GARE FACT 031026');
      expect(s.transactions[0].date, LocalDate(2026, 10, 3));
      // The "Solde en fin de période" footer is reported, never imported.
      expect(s.issues.single.code, 'invalid_date');
    });

    test('signed amount column and comma delimiter with quotes', () {
      final s = parseCsv(
        utf8.encode(
          'Date,Libellé,Montant\n'
          '2026-10-01,"LOYER, OCTOBRE",-650.00\n'
          '2026-10-02,"SALAIRE ""EXEMPLE""",2150.35\n',
        ),
      );
      expect(s.transactions.map((t) => t.amountCents), [-65000, 215035]);
      expect(s.transactions[0].label, 'LOYER, OCTOBRE');
      expect(s.transactions[1].label, 'SALAIRE "EXEMPLE"');
    });

    test('rejects a row with both debit and credit', () {
      final s = parseCsv(
        utf8.encode('Date;Libelle;Debit;Credit\n01/10/2026;X;-1,00;1,00\n'),
      );
      expect(s.transactions, isEmpty);
      expect(s.issues.single.code, 'debit_and_credit');
    });

    test('unknown columns need a user mapping', () {
      final bytes = utf8.encode('a;b;c\n01/10/2026;X;-1,00\n');
      expect(
        () => parseCsv(bytes),
        throwsA(isA<StatementFormatException>()),
      );
      final s = parseCsv(
        bytes,
        mapping: const CsvMapping(
          delimiter: ';',
          headerRow: 0,
          dateColumn: 0,
          labelColumn: 1,
          amountColumn: 2,
        ),
      );
      expect(s.transactions.single.amountCents, -100);
    });
  });

  group('readStatement', () {
    test('detects the format from the content', () {
      expect(
        detectStatementFormat(fixture('sample_bank.qif')),
        StatementFormat.qif,
      );
      expect(
        detectStatementFormat(fixture('sample_sgml.ofx')),
        StatementFormat.ofx,
      );
      expect(
        detectStatementFormat(fixture('sample_xml.ofx')),
        StatementFormat.ofx,
      );
      expect(
        detectStatementFormat(fixture('sample_bank.csv')),
        StatementFormat.csv,
      );
      expect(detectStatementFormat(utf8.encode('nothing')), isNull);
      expect(
        detectStatementFormat(utf8.encode('just a line; of text\n')),
        isNull,
      );
    });

    test('a table with unknown columns asks for them', () {
      final csv = utf8.encode(
        'Jour;Texte;Valeur\n03/11/2026;CB EXEMPLE;-42,10\n04/11/2026;EXEMPLE;-1,00\n',
      );
      expect(detectStatementFormat(csv), StatementFormat.csv);
      expect(
        () => readStatement(csv),
        throwsA(
          isA<StatementFormatException>().having(
            (e) => e.code,
            'code',
            'csv_columns_unknown',
          ),
        ),
      );
      final s = readStatement(
        csv,
        csvMapping: const CsvMapping(
          delimiter: ';',
          headerRow: 0,
          dateColumn: 0,
          labelColumn: 1,
          amountColumn: 2,
        ),
      );
      expect(s.transactions.map((t) => t.amountCents), [-4210, -100]);
    });

    test('same operations give the same amounts whatever the format', () {
      int total(String name) => sumCents(
        readStatement(fixture(name)).transactions.map((t) => t.amountCents),
      );
      expect(total('sample_sgml.ofx'), total('sample_bank.csv'));
    });

    test('empty and unknown files', () {
      expect(
        () => readStatement([]),
        throwsA(isA<StatementFormatException>()),
      );
      expect(
        () => readStatement(utf8.encode('???')),
        throwsA(isA<StatementFormatException>()),
      );
    });
  });

  group('duplicates', () {
    final qif = parseQif(fixture('sample_bank.qif')).transactions;

    test('identical operations on the same day stay distinct', () {
      final prints = fingerprints(qif);
      expect(prints.toSet(), hasLength(prints.length));
      expect(prints, fingerprints(qif), reason: 'deterministic');
    });

    test('re-importing an overlapping file adds nothing twice', () {
      final first = qif.sublist(0, 6);
      final existing = [
        for (final c in checkDuplicates(first, const []))
          ExistingTransaction(
            date: c.transaction.date,
            amountCents: c.transaction.amountCents,
            fingerprint: c.fingerprint,
          ),
      ];
      final second = checkDuplicates(qif, existing);
      expect(
        second.where((c) => c.status == DuplicateStatus.duplicate),
        hasLength(6),
      );
      expect(
        second.where((c) => c.status == DuplicateStatus.isNew),
        hasLength(3),
      );
    });

    test('one of two identical coffees already imported: the other is new', () {
      final coffees = qif.sublist(3, 5);
      final firstOnly = checkDuplicates(coffees.sublist(0, 1), const []);
      final existing = [
        ExistingTransaction(
          date: coffees[0].date,
          amountCents: coffees[0].amountCents,
          fingerprint: firstOnly.single.fingerprint,
        ),
      ];
      final r = checkDuplicates(coffees, existing);
      expect(r.map((c) => c.status), [
        DuplicateStatus.duplicate,
        DuplicateStatus.isNew,
      ]);
    });

    test('same date and amount but another label: possible duplicate', () {
      final csv = parseCsv(fixture('sample_bank.csv')).transactions;
      final ofx = parseOfx(fixture('sample_sgml.ofx')).transactions;
      final existing = [
        for (final c in checkDuplicates(ofx, const []))
          ExistingTransaction(
            date: c.transaction.date,
            amountCents: c.transaction.amountCents,
            fingerprint: c.fingerprint,
            bankId: c.transaction.bankId,
          ),
      ];
      final r = checkDuplicates(csv, existing);
      // Same label on the card payment: exact duplicate. The two others have
      // a different label in the CSV export: flagged for the user.
      expect(r.map((c) => c.status), [
        DuplicateStatus.duplicate,
        DuplicateStatus.possibleDuplicate,
        DuplicateStatus.possibleDuplicate,
      ]);
    });

    test('a manual entry is flagged when the bank operation arrives', () {
      final r = checkDuplicates(qif.sublist(0, 1), [
        ExistingTransaction(date: LocalDate(2026, 10, 1), amountCents: -65000),
      ]);
      expect(r.single.status, DuplicateStatus.possibleDuplicate);
    });

    test('OFX bank id catches a re-import even if the label changed', () {
      final ofx = parseOfx(fixture('sample_sgml.ofx')).transactions;
      final r = checkDuplicates(ofx.sublist(0, 1), [
        ExistingTransaction(
          date: ofx[0].date,
          amountCents: ofx[0].amountCents,
          fingerprint: 'other',
          bankId: 'FIT0001',
        ),
      ]);
      expect(r.single.status, DuplicateStatus.duplicate);
    });
  });
}
