import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('readReceiptText', () {
    test('standard French supermarket receipt', () {
      final lines = [
        'CARREFOUR MARKET',
        '24 RUE DE LA REPUBLIQUE',
        '75011 PARIS',
        'SIRET 12345678900012',
        'PAIN DE MIE      1,45',
        'LAIT DEMI ECREME 1,12',
        'POMMES GOLDEN    3,42',
        'SOUS-TOTAL       5,99',
        'REMISE FIDELITE -0,50',
        'TOTAL TTC        5,49 €',
        'TOTAL TVA        0,32 €',
        'CARTE BANCAIRE   5,49 €',
        'DATE: 28/10/2026 14:32',
        'MERCI DE VOTRE VISITE',
      ];
      final r = readReceiptText(lines, today: LocalDate(2026, 10, 30));
      expect(r.merchant?.value, 'CARREFOUR MARKET');
      expect(r.merchant?.certain, isTrue);
      expect(r.date?.value, LocalDate(2026, 10, 28));
      expect(r.date?.certain, isTrue);
      expect(r.totalCents?.value, 549);
      expect(r.totalCents?.certain, isTrue);
      expect(r.vatCents?.value, 32);
      expect(r.vatCents?.certain, isTrue);
      expect(r.isFullyCertain, isTrue);
    });

    test('bakery ticket with 2-digit year and amount on the next line', () {
      final lines = [
        '*** LA BAGUETTE CHAUDE ***',
        'BOULANGERIE ARTISANALE',
        'TICKET N° 0421',
        '3 CROISSANTS',
        'NET A PAYER',
        '4,20 €',
        'PAYE PAR CB',
        'LE 02/11/26 A 08:15',
      ];
      final r = readReceiptText(lines, today: LocalDate(2026, 11, 3));
      expect(r.merchant?.value, 'LA BAGUETTE CHAUDE');
      expect(r.date?.value, LocalDate(2026, 11, 2));
      expect(r.totalCents?.value, 420);
      expect(r.totalCents?.certain, isTrue);
      expect(r.vatCents, isNull);
    });

    test('fuel station receipt with ISO date', () {
      final lines = [
        'RELAIS DE L AUTOROUTE',
        'STATION TOTALENERGIES A10',
        'DATE: 2026-10-15 19:40',
        'SP95-E10  35,40 L  1,829 €',
        'MONTANT TTC : 64,75 EUR',
        'TOTAL TVA : 10,79 EUR',
        'PAIEMENT CB SANS CONTACT',
      ];
      final r = readReceiptText(lines);
      expect(r.merchant?.value, 'RELAIS DE L AUTOROUTE');
      expect(r.date?.value, LocalDate(2026, 10, 15));
      expect(r.totalCents?.value, 6475);
      expect(r.vatCents?.value, 1079);
    });

    test('rejects a future date as a misread digit', () {
      final lines = [
        'PHARMACIE CENTRALE',
        'DATE: 12/05/2035',
        'TOTAL A PAYER: 18,90 €',
      ];
      final r = readReceiptText(lines, today: LocalDate(2026, 11, 3));
      expect(r.date, isNull, reason: '2035 is in the future');
      expect(r.totalCents?.value, 1890);
    });

    test('ignores non-total keywords and picks the actual total paid', () {
      final lines = [
        'BRICOMARCHE',
        'SOUS TOTAL : 100,00',
        'TOTAL HT : 83,33',
        'REMISE : 10,00',
        'TOTAL DES TVA : 18,00',
        'TOTAL TTC : 108,00',
        'RENDU MONNAIE : 2,00',
        'POINTS FIDELITE : 120',
        '28/10/2026',
      ];
      final r = readReceiptText(lines);
      expect(r.totalCents?.value, 10800);
      expect(r.totalCents?.certain, isTrue);
      expect(r.vatCents?.value, 1800);
    });

    test('two differing totals: takes the largest and marks uncertain', () {
      final lines = [
        'RESTAURANT CHEZ MARCEL',
        'TOTAL : 45,00',
        'TOTAL : 50,00',
        '10/10/2026',
      ];
      final r = readReceiptText(lines);
      expect(r.totalCents?.value, 5000);
      expect(r.totalCents?.certain, isFalse, reason: 'two distinct totals');
      expect(r.isFullyCertain, isFalse);
    });

    test('no total keyword: picks the largest amount but marks uncertain', () {
      final lines = [
        'MARCHE DE PROVENCE',
        'TOMATES 3,50',
        'MELON 4,00',
        'FRAISES 12,00',
        '15/09/2026',
      ];
      final r = readReceiptText(lines);
      expect(r.totalCents?.value, 1200);
      expect(r.totalCents?.certain, isFalse);
      expect(r.isFullyCertain, isFalse);
    });

    test('skips header noise when choosing merchant name', () {
      final lines = [
        '*** DUPLICATA CLIENT ***',
        'SIRET 98765432100023',
        'LIBRAIRIE DU PORT',
        '44000 NANTES',
        'TOTAL: 24,90',
        '01/11/2026',
      ];
      final r = readReceiptText(lines);
      expect(r.merchant?.value, 'LIBRAIRIE DU PORT');
    });

    test('multiple distinct dates: first is used, marked uncertain', () {
      final lines = [
        'FNAC DARTY',
        'ACHAT LE 15/10/2026',
        'GARANTIE JUSQU AU 15/10/2028',
        'TOTAL TTC: 199,00',
      ];
      final r = readReceiptText(lines);
      expect(r.date?.value, LocalDate(2026, 10, 15));
      expect(r.date?.certain, isFalse, reason: 'two distinct dates found');
    });

    test('empty or unreadable lines give an empty reading', () {
      final r = readReceiptText(['', '   ', '### ---']);
      expect(r.isEmpty, isTrue);
      expect(r.merchant, isNull);
      expect(r.date, isNull);
      expect(r.totalCents, isNull);
      expect(r.vatCents, isNull);
    });
  });
}
