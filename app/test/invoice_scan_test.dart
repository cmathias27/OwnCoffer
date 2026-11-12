import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:owncoffer_app/l10n/app_localizations.dart';
import 'package:owncoffer_app/screens/invoice_scan_screen.dart';
import 'package:owncoffer_app/util/file_pick.dart';
import 'package:owncoffer_shared/owncoffer_shared.dart' show RgbaImage;

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

  group('found for sure, blurred (decision 0039)', () {
    testWidgets('straightened at once, the corners stay adjustable', (
      tester,
    ) async {
      final photo = PickedFile('ticket.jpg', Uint8List.fromList([2]));
      final result = await _open(tester, photo);
      await _settle(tester, find.textContaining('Ticket trouvé'));
      expect(find.textContaining('semble floue'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'Garder'), findsOneWidget);
      expect(find.byType(RawImage), findsOneWidget);

      await tester.tap(find.text('Ajuster les coins'));
      await tester.pump();
      expect(find.textContaining('Faites glisser'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Recadrer'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Recadrer'));
      await _settle(tester, find.text('go'));
      final kept = await result;
      expect(kept!.name, 'ticket.png');
    });

    testWidgets('a blurred photo is pointed out and can be taken again', (
      tester,
    ) async {
      var retaken = 0;
      final photo = PickedFile('flou.jpg', Uint8List.fromList([1]));
      await _open(
        tester,
        photo,
        retake: () async {
          retaken++;
          return PickedFile('net.jpg', Uint8List.fromList([2]));
        },
      );
      await _settle(tester, find.textContaining('semble floue'));
      await tester.tap(find.text('Reprendre la photo'));
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await _settle(tester, find.textContaining('Ticket trouvé'));
      expect(retaken, 1);
      expect(find.textContaining('semble floue'), findsNothing);
      // The photo kept as it is is the new one.
      expect(find.text('Garder telle quelle'), findsOneWidget);
    });

    testWidgets('no camera: no retake offered', (tester) async {
      final photo = PickedFile('flou.jpg', Uint8List.fromList([1]));
      await _open(tester, photo);
      await _settle(tester, find.textContaining('semble floue'));
      expect(find.text('Reprendre la photo'), findsNothing);
    });
  });
}

/// Pushes the scan of [photo] (bytes [1]: a blurred ticket, [2]: a sharp
/// one) and returns what it gives back.
Future<Future<PickedFile?>> _open(
  WidgetTester tester,
  PickedFile photo, {
  Future<PickedFile?> Function()? retake,
}) async {
  final done = Completer<PickedFile?>();
  await tester.pumpWidget(
    _app(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async => done.complete(
            await Navigator.of(context).push<PickedFile>(
              MaterialPageRoute(
                builder: (_) => InvoiceScanScreen(
                  photo: photo,
                  retake: retake,
                  decode: (bytes) async =>
                      bytes.first == 1 ? _ticket(blurred: true) : _ticket(),
                ),
              ),
            ),
          ),
          child: const Text('go'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('go'));
  await tester.pump();
  return done.future;
}

/// Lets the work off the screen's thread finish until [target] shows and
/// nothing is in progress.
Future<void> _settle(WidgetTester tester, Finder target) async {
  bool working() =>
      target.evaluate().isEmpty ||
      find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
  for (var i = 0; i < 400 && working(); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pumpAndSettle();
  expect(target, findsWidgets);
}

Widget _app(Widget home) => MaterialApp(
  locale: const Locale('fr'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

/// A printed ticket, slightly turned, on a dark table; [blurred] as by a
/// shaking hand.
RgbaImage _ticket({bool blurred = false}) {
  const w = 600, h = 450;
  final img = RgbaImage.blank(w, h);
  const corners = [
    (170.0, 40.0),
    (420.0, 60.0),
    (400.0, 420.0),
    (150.0, 400.0),
  ];
  bool inside(double x, double y) {
    for (var i = 0; i < 4; i++) {
      final (ax, ay) = corners[i];
      final (bx, by) = corners[(i + 1) % 4];
      if ((bx - ax) * (y - ay) - (by - ay) * (x - ax) < 0) return false;
    }
    return true;
  }

  final random = math.Random(3);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      var v = 45;
      if (inside(x + 0.5, y + 0.5)) {
        // Lines of letters, away from the edges of the paper.
        final printed = x > 200 && x < 370 && y > 100 && y < 360 && y % 14 < 8;
        v = printed && random.nextInt(3) > 0 ? 30 : 235;
      }
      final p = (y * w + x) * 4;
      img.pixels
        ..[p] = v
        ..[p + 1] = v
        ..[p + 2] = v
        ..[p + 3] = 255;
    }
  }
  if (!blurred) return img;
  // Twice a 9-pixel average, across then down.
  for (var pass = 0; pass < 4; pass++) {
    final across = pass.isEven;
    final copy = Uint8List.fromList(img.pixels);
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        var sum = 0;
        for (var k = -4; k <= 4; k++) {
          final xx = across ? (x + k).clamp(0, w - 1) : x;
          final yy = across ? y : (y + k).clamp(0, h - 1);
          sum += copy[(yy * w + xx) * 4];
        }
        final p = (y * w + x) * 4;
        final v = sum ~/ 9;
        img.pixels
          ..[p] = v
          ..[p + 1] = v
          ..[p + 2] = v;
      }
    }
  }
  return img;
}
