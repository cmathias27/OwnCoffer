import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  test('every rule targets an existing, non-deprecated standard category', () {
    for (final (pattern, category, _) in communityRuleEntries) {
      final def = standardCategoriesById[category];
      expect(def, isNotNull, reason: '$pattern → $category');
      expect(def!.deprecated, isFalse, reason: category);
    }
  });

  test('no duplicate pattern + direction, patterns already normalised', () {
    final seen = <String>{};
    for (final (pattern, _, direction) in communityRuleEntries) {
      expect(seen.add('$pattern|$direction'), isTrue, reason: pattern);
      expect(normalizeForMatch(pattern), pattern);
    }
  });

  group('on Caisse d\'Épargne labels', () {
    final classifier = Classifier<String>(
      groupRules: const [],
      communityRules: communityRules,
      standardToGroup: {
        for (final c in standardCategories) c.id: c.id,
      },
    );
    String? classify(String label, int cents) =>
        classifier.classify(cleanCaisseEpargneLabel(label), cents).categoryId;

    test('common merchants', () {
      expect(
        classify('CB CARREFOUR MARKET FACT 281026', -4512),
        'food.groceries',
      );
      expect(classify('CB INTERMARCHE FACT 231026', -8740), 'food.groceries');
      expect(
        classify('PRLV FREE MOBILE', -1999),
        'subscriptions.phone_internet',
      );
      expect(
        classify('PRLV EDF clients particuliers', -7142),
        'housing.energy',
      );
      expect(
        classify('CB AMAZON PAYMENTS FACT 271026', -1299),
        'shopping.misc_online',
      );
      expect(classify('VIR SEPA CPAM EXEMPLE', 1865), 'income.refunds');
      expect(
        classify('RETRAIT DAB 26 10 12345 678901', -6000),
        'transfers.cash_withdrawal',
      );
      expect(
        classify('MIN FORFAIT INTERET DEBITEUR', -390),
        'banking.overdraft_interest',
      );
      expect(classify('FORMULE FAMILLE CONFORT', -1230), 'banking.bank_fees');
    });

    test('the most specific pattern wins, direction matters', () {
      expect(classify('PRLV AMAZON PRIME', -699), 'subscriptions.streaming');
      expect(classify('VIR SEPA AMAZON PAYMENTS', 1500), 'income.refunds');
      expect(classify('CB ORANGERIE DU PARC', -1000), isNull);
    });
  });
}
