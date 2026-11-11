import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/util/file_pick.dart';
import 'package:owncoffer_app/util/text_reader.dart';
import 'package:owncoffer_app/widgets/invoices.dart';
import 'package:owncoffer_app/widgets/receipt_operation_dialog.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

Widget _wrap(Widget child) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

/// An engine that returns fixed lines (or nothing), and counts its calls.
class _FakeReader implements TextReader {
  final List<String>? lines;
  @override
  final bool isAvailable;
  var calls = 0;

  _FakeReader(this.lines, {this.isAvailable = true});

  @override
  Future<TextReading?> read(Uint8List imageBytes) async {
    calls++;
    final l = lines;
    return l == null ? null : TextReading([for (final t in l) TextLine(t)]);
  }
}

InvoiceInfo _waiting({int? amount, DateTime? date, String? merchant}) =>
    InvoiceInfo(
      invoice: Invoice(
        id: 5,
        groupId: 1,
        fileName: 'ticket.jpg',
        mimeType: 'image/jpeg',
        sizeBytes: 10,
        hintAmountCents: amount,
        hintDate: date,
        hintMerchant: merchant,
      ),
      name: 'ticket.jpg',
    );

void main() {
  final photo = PickedFile('ticket.jpg', Uint8List.fromList([1, 2, 3]));
  final pdf = PickedFile('facture.pdf', Uint8List.fromList([1, 2, 3]));

  Future<InvoiceHints?> ask(
    WidgetTester tester,
    PickedFile file,
    TextReader reader,
    Future<void> Function() interact,
  ) async {
    InvoiceHints? result;
    var done = false;
    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await askReceiptHints(context, file, reader: reader);
              done = true;
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await interact();
    await tester.pumpAndSettle();
    expect(done, isTrue);
    return result;
  }

  testWidgets('a photo is read on the device and checked by the user', (
    tester,
  ) async {
    final reader = _FakeReader([
      'BOULANGERIE DUPONT',
      'LE 02/11/2026 10:32',
      'BAGUETTE 1,20',
      'TOTAL EUR 12,50',
    ]);
    final hints = await ask(tester, photo, reader, () async {
      final l = lookupAppLocalizations(const Locale('fr'));
      expect(find.text(l.receiptCheckTitle), findsOneWidget);
      expect(find.text('12,50'), findsOneWidget);
      await tester.tap(find.text(l.receiptCheckConfirm));
    });
    expect(reader.calls, 1);
    expect(hints?.amountCents, 1250);
    expect(hints?.date, DateTime.utc(2026, 11, 2));
    expect(hints?.merchant, 'BOULANGERIE DUPONT');
  });

  testWidgets('nothing read, a PDF or no engine: typed by the user', (
    tester,
  ) async {
    final l = lookupAppLocalizations(const Locale('fr'));
    for (final (file, reader) in [
      (photo, _FakeReader(null)),
      (pdf, _FakeReader(['TOTAL 12,50'])),
      (photo, _FakeReader(['TOTAL 12,50'], isAvailable: false)),
    ]) {
      await ask(tester, file, reader, () async {
        expect(find.text(l.receiptCheckTitle), findsNothing);
        await tester.tap(find.text(l.cancel));
      });
      expect(reader.calls, file == pdf || !reader.isAvailable ? 0 : 1);
    }
  });

  group('operation created from a receipt', () {
    final accounts = [
      Account(id: 3, groupId: 1, name: 'Livret', kind: AccountKind.savings),
      Account(id: 4, groupId: 1, name: 'Courant', kind: AccountKind.checking),
    ];
    final food = Category(
      id: 8,
      groupId: 1,
      name: 'Boulangerie',
      kind: CategoryKind.expense,
    );

    Future<void> open(
      WidgetTester tester,
      InvoiceInfo info,
      ReceiptOperationCreate create,
    ) async {
      tester.view.physicalSize = const Size(900, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await tester.pumpWidget(
        _wrap(
          ReceiptOperationDialog(
            info: info,
            load: (groupId) async {
              expect(groupId, 1);
              return (accounts: accounts, categories: [food]);
            },
            create: create,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('filled from the receipt, checking account first', (
      tester,
    ) async {
      final sent = <Object?>[];
      await open(
        tester,
        _waiting(
          amount: 1250,
          date: DateTime.utc(2026, 11, 2),
          merchant: 'BOULANGERIE',
        ),
        (invoiceId, accountId, date, cents, label, categoryId) async {
          sent.addAll([invoiceId, accountId, date, cents, label, categoryId]);
          return _waiting();
        },
      );
      final l = lookupAppLocalizations(const Locale('fr'));
      expect(find.text('Courant'), findsOneWidget);
      expect(find.text('12,50'), findsOneWidget);
      expect(find.text('BOULANGERIE'), findsOneWidget);
      expect(find.text(l.receiptOperationByRules), findsOneWidget);
      await tester.tap(find.text(l.receiptOperationCreate));
      await tester.pumpAndSettle();
      expect(sent, [
        5,
        4,
        DateTime.utc(2026, 11, 2),
        1250,
        'BOULANGERIE',
        null,
      ]);
    });

    testWidgets('amount and label required; server errors shown', (
      tester,
    ) async {
      var calls = 0;
      await open(tester, _waiting(), (a, b, c, d, e, f) async {
        calls++;
        throw StateError('refused');
      });
      final l = lookupAppLocalizations(const Locale('fr'));
      await tester.tap(find.text(l.receiptOperationCreate));
      await tester.pumpAndSettle();
      expect(find.text(l.amountInvalid), findsOneWidget);
      expect(find.text(l.receiptOperationLabelMissing), findsOneWidget);
      expect(calls, 0);

      await tester.enterText(
        find.byKey(const ValueKey('receipt-operation-amount')),
        '7,40',
      );
      await tester.enterText(
        find.byKey(const ValueKey('receipt-operation-label')),
        'MARCHÉ',
      );
      await tester.tap(find.text(l.receiptOperationCreate));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(find.byType(ReceiptOperationDialog), findsOneWidget);
    });
  });

  test('texts in both languages', () {
    for (final locale in const [Locale('fr'), Locale('en')]) {
      final l = lookupAppLocalizations(locale);
      expect(l.receiptReading, isNotEmpty);
      expect(l.receiptOperationHelp, isNotEmpty);
      expect(l.receiptOperationCreated('x.jpg'), contains('x.jpg'));
      expect(l.error_invoice_already_attached, isNotEmpty);
    }
  });
}
