import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/invoice_scan_screen.dart';
import 'package:owncoffer_app/util/file_pick.dart';

void main() {
  test('only photos are cropped', () {
    expect(isScannable('IMG_1.JPG'), isTrue);
    expect(isScannable('scan.webp'), isTrue);
    expect(isScannable('facture.pdf'), isFalse);
  });

  testWidgets('unreadable photo: kept as it is', (tester) async {
    final photo = PickedFile('photo.jpg', Uint8List.fromList([1, 2, 3]));
    PickedFile? result;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async =>
                result = await scanInvoicePhoto(context, photo),
            child: const Text('go'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    // Off the web, decoding is not available: the error is shown.
    expect(find.textContaining('ne peut pas être lue'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Garder telle quelle'));
    await tester.pumpAndSettle();
    expect(result, same(photo));
  });
}
