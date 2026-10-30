import 'package:owncoffer_shared/owncoffer_shared.dart';
import 'package:test/test.dart';

void main() {
  group('cleanLabel', () {
    final cases = <String, (String, OperationKind)>{
      'PRLV SEPA EDF SA': ('EDF', OperationKind.directDebit),
      'PRLV SEPA EDF SA ECH/061026 ID EMETTEUR/FR00ZZZ000000 MDT/000 REF/1': (
        'EDF',
        OperationKind.directDebit,
      ),
      'PRLV SEPA FREE MOBILE': ('FREE MOBILE', OperationKind.directDebit),
      'CB CARREFOUR MARKET FACT 021026': (
        'CARREFOUR MARKET',
        OperationKind.card,
      ),
      'CB CAFÉ DE LA GARE FACT 031026': ('CAFE DE LA GARE', OperationKind.card),
      'CB AMAZON PAYMENTS 4970XXXXXXXX1234': (
        'AMAZON PAYMENTS',
        OperationKind.card,
      ),
      'PAIEMENT CB 0210 SNCF CONNECT': ('SNCF CONNECT', OperationKind.card),
      'RETRAIT DAB 05/10/26': ('RETRAIT DAB', OperationKind.withdrawal),
      'VIR SEPA RECU EMPLOYEUR EXEMPLE SAS': (
        'EMPLOYEUR EXEMPLE',
        OperationKind.transferIn,
      ),
      'VIR INST EMIS MARTIN': ('MARTIN', OperationKind.transferOut),
      'CHEQUE 0000123': ('CHEQUE', OperationKind.cheque),
      'FRAIS TENUE DE COMPTE': ('TENUE DE COMPTE', OperationKind.fee),
      'VIRGIN MEGASTORE': ('VIRGIN MEGASTORE', OperationKind.other),
      'CBD SHOP': ('CBD SHOP', OperationKind.other),
      'LIBRAIRIE DU CENTRE': ('LIBRAIRIE DU CENTRE', OperationKind.other),
    };
    cases.forEach((raw, expected) {
      test(raw, () {
        final c = cleanLabel(raw);
        expect(c.display, expected.$1);
        expect(c.kind, expected.$2);
      });
    });

    test('never keeps dates, card numbers or long references', () {
      final c = cleanLabel(
        'PRLV SEPA ASSURANCE EXEMPLE 29/10/2026 4970XXXXXXXX1234 '
        'FR76300040000312345678901 1234567890',
      );
      expect(c.display, 'ASSURANCE EXEMPLE');
    });

    test('Caisse d\'Épargne profile', () {
      expect(
        cleanCaisseEpargneLabel('VIR EUROPEEN EMIS LOGEMENT').kind,
        OperationKind.transferOut,
      );
      expect(
        cleanCaisseEpargneLabel('COTIS FORMULE EXEMPLE').display,
        'FORMULE EXEMPLE',
      );
    });
  });

  group('Classifier', () {
    CleanedLabel l(String raw) => cleanLabel(raw);

    final standardToGroup = {
      'food': 'cat-food',
      'food.groceries': 'cat-groceries',
      'housing.energy': 'cat-energy',
      'transport': 'cat-transport',
      'income.salary': 'cat-salary',
    };

    final community = [
      CommunityRule(
        id: 'c-carrefour',
        pattern: 'CARREFOUR',
        standardCategoryId: 'food.groceries',
      ),
      CommunityRule(
        id: 'c-edf',
        pattern: 'EDF',
        matchType: MatchType.startsWith,
        standardCategoryId: 'housing.energy',
        direction: Direction.debit,
      ),
      CommunityRule(
        id: 'c-sncf',
        pattern: 'SNCF',
        standardCategoryId: 'transport.train',
      ),
      CommunityRule(
        id: 'c-boulangerie',
        pattern: 'BOULANGERIE',
        standardCategoryId: 'food.bakery',
      ),
      CommunityRule(
        id: 'c-unmapped',
        pattern: 'CINEMA',
        standardCategoryId: 'leisure.cinema',
      ),
    ];

    test('order: group rule, then community rule, then history', () {
      final c = Classifier<String>(
        groupRules: [
          GroupRule(id: 1, categoryId: 'cat-custom', pattern: 'CARREFOUR CITY'),
        ],
        communityRules: community,
        standardToGroup: standardToGroup,
        history: [
          HistoryEntry(
            labelKey: 'CHEZ PAUL',
            amountCents: -1500,
            categoryId: 'cat-restaurant',
            date: LocalDate(2026, 9, 1),
          ),
        ],
      );
      final groupHit = c.classify(l('CB CARREFOUR CITY FACT 011026'), -500);
      expect(groupHit.categoryId, 'cat-custom');
      expect(groupHit.source, CategorySource.groupRule);
      expect(groupHit.ruleId, 1);

      final communityHit = c.classify(l('CB CARREFOUR MARKET'), -4512);
      expect(communityHit.categoryId, 'cat-groceries');
      expect(communityHit.source, CategorySource.communityRule);
      expect(communityHit.ruleId, 'c-carrefour');

      final historyHit = c.classify(l('CB CHEZ PAUL FACT 021026'), -2000);
      expect(historyHit.categoryId, 'cat-restaurant');
      expect(historyHit.source, CategorySource.history);

      final none = c.classify(l('CB INCONNU'), -100);
      expect(none.isClassified, isFalse);
      expect(none.source, CategorySource.none);
    });

    test('community sub-category falls back to the mapped parent', () {
      final c = Classifier<String>(
        groupRules: const [],
        communityRules: community,
        standardToGroup: standardToGroup,
      );
      expect(
        c.classify(l('CB BOULANGERIE DU COIN'), -250).categoryId,
        'cat-food',
      );
      expect(
        c.classify(l('PAIEMENT CB SNCF CONNECT'), -4000).categoryId,
        'cat-transport',
      );
      // No mapping at all: left unclassified rather than guessed.
      expect(c.classify(l('CB CINEMA'), -900).isClassified, isFalse);
    });

    test('direction: an EDF refund is not an energy expense', () {
      final c = Classifier<String>(
        groupRules: const [],
        communityRules: community,
        standardToGroup: standardToGroup,
      );
      expect(c.classify(l('PRLV SEPA EDF SA'), -7142).categoryId, 'cat-energy');
      expect(c.classify(l('VIR SEPA RECU EDF SA'), 3000).isClassified, isFalse);
    });

    test('whole words only: SNCF does not match ASNCF', () {
      final c = Classifier<String>(
        groupRules: const [],
        communityRules: community,
        standardToGroup: standardToGroup,
      );
      expect(c.classify(l('CB ASNCF'), -100).isClassified, isFalse);
    });

    test('group rules: priority, then specificity, amount bounds', () {
      final c = Classifier<String>(
        groupRules: [
          GroupRule(id: 'a', categoryId: 'generic', pattern: 'AMAZON'),
          GroupRule(
            id: 'b',
            categoryId: 'books',
            pattern: 'AMAZON',
            maxAbsCents: 3000,
          ),
          GroupRule(
            id: 'c',
            categoryId: 'forced',
            pattern: 'AMAZON PRIME',
            priority: 1,
          ),
          GroupRule(
            id: 'd',
            categoryId: 'salary',
            pattern: 'EMPLOYEUR',
            matchType: MatchType.equals,
            direction: Direction.credit,
          ),
        ],
      );
      expect(c.classify(l('CB AMAZON PRIME'), -699).categoryId, 'forced');
      expect(c.classify(l('CB AMAZON MKTP'), -2500).categoryId, 'books');
      expect(c.classify(l('CB AMAZON MKTP'), -12000).categoryId, 'generic');
      expect(
        c.classify(l('VIR SEPA RECU EMPLOYEUR SAS'), 215035).categoryId,
        'salary',
      );
      expect(c.classify(l('VIR SEPA EMIS EMPLOYEUR'), -100).categoryId, isNull);
    });

    test('history: most frequent wins, then most recent; debit ≠ credit', () {
      HistoryEntry<String> h(String cat, int amount, int day) => HistoryEntry(
        labelKey: 'MAGASIN',
        amountCents: amount,
        categoryId: cat,
        date: LocalDate(2026, 9, day),
      );
      final c = Classifier<String>(
        groupRules: const [],
        history: [
          h('gifts', -100, 1),
          h('clothes', -100, 2),
          h('clothes', -100, 3),
          h('refund', 500, 4),
        ],
      );
      expect(c.classify(l('CB MAGASIN'), -100).categoryId, 'clothes');
      expect(c.classify(l('CB MAGASIN'), 100).categoryId, 'refund');

      final tie = Classifier<String>(
        groupRules: const [],
        history: [h('old', -1, 1), h('recent', -1, 20)],
      );
      expect(tie.classify(l('CB MAGASIN'), -1).categoryId, 'recent');
    });

    test('rejects empty patterns', () {
      expect(
        () => GroupRule(id: 1, categoryId: 'x', pattern: ' - '),
        throwsArgumentError,
      );
    });

    test('automatic rate (decision 0014)', () {
      final results = [
        const Classification('a', CategorySource.groupRule),
        const Classification('a', CategorySource.communityRule),
        const Classification('a', CategorySource.history),
        const Classification('a', CategorySource.ai),
        Classification.none<String>(),
      ];
      expect(automaticClassificationRate(results), 0.6);
    });
  });
}
