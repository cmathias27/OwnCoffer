// Community rules v0 — CC0 1.0 (decision 0013).
//
// Merchant or organisation → standard category, for labels as written by
// French banks (Caisse d'Épargne first). Patterns match whole words of the
// normalised label (upper case, no accents). No personal data: only
// merchants and public bodies, never people.
//
// Will move to the separate owncoffer-rules repository when it exists.

import '../classification/classifier.dart';

const int communityRulesVersion = 1;

typedef _R = (String pattern, String category, Direction direction);

const _d = Direction.debit;
const _c = Direction.credit;

const List<_R> _rules = [
  // Groceries
  ('CARREFOUR', 'food.groceries', _d),
  ('CARREFOUR MARKET', 'food.groceries', _d),
  ('CARREFOUR CITY', 'food.groceries', _d),
  ('E LECLERC', 'food.groceries', _d),
  ('LECLERC', 'food.groceries', _d),
  ('INTERMARCHE', 'food.groceries', _d),
  ('AUCHAN', 'food.groceries', _d),
  ('LIDL', 'food.groceries', _d),
  ('ALDI', 'food.groceries', _d),
  ('CASINO', 'food.groceries', _d),
  ('MONOPRIX', 'food.groceries', _d),
  ('FRANPRIX', 'food.groceries', _d),
  ('SUPER U', 'food.groceries', _d),
  ('HYPER U', 'food.groceries', _d),
  ('U EXPRESS', 'food.groceries', _d),
  ('SYSTEME U', 'food.groceries', _d),
  ('COCCINELLE', 'food.groceries', _d),
  ('COCCIMARKET', 'food.groceries', _d),
  ('NETTO', 'food.groceries', _d),
  ('PICARD', 'food.groceries', _d),
  ('BIOCOOP', 'food.groceries', _d),
  ('GRAND FRAIS', 'food.groceries', _d),
  ('NATURALIA', 'food.groceries', _d),
  ('SPAR', 'food.groceries', _d),
  ('VIVAL', 'food.groceries', _d),
  ('MAXI MARCHE', 'food.groceries', _d),
  ('BOULANGERIE', 'food.groceries', _d),
  // Restaurants and delivery
  ('MCDONALDS', 'food.restaurants', _d),
  ('MC DONALDS', 'food.restaurants', _d),
  ('BURGER KING', 'food.restaurants', _d),
  ('KFC', 'food.restaurants', _d),
  ('STARBUCKS', 'food.restaurants', _d),
  ('DOMINOS', 'food.takeaway', _d),
  ('UBER EATS', 'food.takeaway', _d),
  ('DELIVEROO', 'food.takeaway', _d),
  ('JUST EAT', 'food.takeaway', _d),
  // Fuel, tolls, transport
  ('TOTALENERGIES', 'transport.fuel', _d),
  ('TOTAL ACCESS', 'transport.fuel', _d),
  ('ESSO', 'transport.fuel', _d),
  ('SHELL', 'transport.fuel', _d),
  ('AVIA', 'transport.fuel', _d),
  ('STATION SERVICE', 'transport.fuel', _d),
  ('VINCI AUTOROUTES', 'transport.parking_tolls', _d),
  ('SANEF', 'transport.parking_tolls', _d),
  ('APRR', 'transport.parking_tolls', _d),
  ('AREA', 'transport.parking_tolls', _d),
  ('INDIGO', 'transport.parking_tolls', _d),
  ('SNCF', 'transport.train_plane', _d),
  ('SNCF CONNECT', 'transport.train_plane', _d),
  ('OUIGO', 'transport.train_plane', _d),
  ('AIR FRANCE', 'transport.train_plane', _d),
  ('EASYJET', 'transport.train_plane', _d),
  ('RYANAIR', 'transport.train_plane', _d),
  ('TRANSAVIA', 'transport.train_plane', _d),
  ('BLABLACAR', 'transport.train_plane', _d),
  ('RATP', 'transport.public_transport', _d),
  ('NAVIGO', 'transport.public_transport', _d),
  ('UBER', 'transport.taxi_ride_hailing', _d),
  ('BOLT', 'transport.taxi_ride_hailing', _d),
  ('NORAUTO', 'transport.vehicle_maintenance', _d),
  ('SPEEDY', 'transport.vehicle_maintenance', _d),
  ('MIDAS', 'transport.vehicle_maintenance', _d),
  ('FEU VERT', 'transport.vehicle_maintenance', _d),
  // Housing
  ('EDF', 'housing.energy', _d),
  ('ENGIE', 'housing.energy', _d),
  ('ENI', 'housing.energy', _d),
  ('VEOLIA', 'housing.water', _d),
  ('SUEZ', 'housing.water', _d),
  ('SAUR', 'housing.water', _d),
  ('IKEA', 'housing.furniture', _d),
  ('CONFORAMA', 'housing.furniture', _d),
  // Subscriptions
  ('FREE MOBILE', 'subscriptions.phone_internet', _d),
  ('FREE TELECOM', 'subscriptions.phone_internet', _d),
  ('ORANGE', 'subscriptions.phone_internet', _d),
  ('SOSH', 'subscriptions.phone_internet', _d),
  ('SFR', 'subscriptions.phone_internet', _d),
  ('RED BY SFR', 'subscriptions.phone_internet', _d),
  ('BOUYGUES TELECOM', 'subscriptions.phone_internet', _d),
  ('NETFLIX', 'subscriptions.streaming', _d),
  ('SPOTIFY', 'subscriptions.streaming', _d),
  ('DEEZER', 'subscriptions.streaming', _d),
  ('DISNEY PLUS', 'subscriptions.streaming', _d),
  ('CANAL', 'subscriptions.streaming', _d),
  ('AMAZON PRIME', 'subscriptions.streaming', _d),
  ('YOUTUBE PREMIUM', 'subscriptions.streaming', _d),
  ('APPLE COM BILL', 'subscriptions.software', _d),
  ('GOOGLE', 'subscriptions.software', _d),
  ('MICROSOFT', 'subscriptions.software', _d),
  // Health
  ('PHARMACIE', 'health.pharmacy', _d),
  ('CPAM', 'income.refunds', _c),
  ('MUTUELLE', 'health.health_insurance', _d),
  ('DOCTOLIB', 'health.doctors', _d),
  // Shopping
  ('AMAZON', 'shopping.misc_online', _d),
  ('AMZN', 'shopping.misc_online', _d),
  ('AMAZON', 'income.refunds', _c),
  ('FNAC', 'shopping.electronics', _d),
  ('DARTY', 'shopping.electronics', _d),
  ('BOULANGER', 'shopping.electronics', _d),
  ('LDLC', 'shopping.electronics', _d),
  ('DECATHLON', 'leisure.sport', _d),
  ('LEROY MERLIN', 'shopping.diy_garden', _d),
  ('CASTORAMA', 'shopping.diy_garden', _d),
  ('BRICOMARCHE', 'shopping.diy_garden', _d),
  ('BRICO DEPOT', 'shopping.diy_garden', _d),
  ('MR BRICOLAGE', 'shopping.diy_garden', _d),
  ('JARDILAND', 'shopping.diy_garden', _d),
  ('TRUFFAUT', 'shopping.diy_garden', _d),
  ('ZARA', 'shopping.clothing', _d),
  ('KIABI', 'shopping.clothing', _d),
  ('PRIMARK', 'shopping.clothing', _d),
  ('CELIO', 'shopping.clothing', _d),
  ('JULES', 'shopping.clothing', _d),
  ('SEPHORA', 'shopping.personal_care', _d),
  ('NOCIBE', 'shopping.personal_care', _d),
  ('YVES ROCHER', 'shopping.personal_care', _d),
  ('VINTED', 'shopping.misc_online', _d),
  ('VINTED', 'income.other', _c),
  ('CDISCOUNT', 'shopping.misc_online', _d),
  ('ALIEXPRESS', 'shopping.misc_online', _d),
  ('ACTION', 'shopping', _d),
  ('GIFI', 'shopping', _d),
  ('LA FOIR FOUILLE', 'shopping', _d),
  // Family
  ('MAXI ZOO', 'family.pets', _d),
  ('ANIMALIS', 'family.pets', _d),
  ('TRUFFAUT ANIMALERIE', 'family.pets', _d),
  // Income and public bodies
  ('CAF', 'income.benefits', _c),
  ('FRANCE TRAVAIL', 'income.benefits', _c),
  ('POLE EMPLOI', 'income.benefits', _c),
  ('CARSAT', 'income.pension', _c),
  ('DGFIP', 'taxes', _d),
  ('DIRECTION GENERALE DES FINANCES PUBLIQUES', 'taxes', _d),
  ('TRESOR PUBLIC', 'taxes', _d),
  ('ANTAI', 'taxes.other_taxes_fines', _d),
  // Bank
  ('RETRAIT DAB', 'transfers.cash_withdrawal', _d),
  ('RETRAIT D ESPECES', 'transfers.cash_withdrawal', _d),
  ('FRAIS', 'banking.bank_fees', _d),
  ('COTISATION', 'banking.bank_fees', _d),
  ('COMMISSION', 'banking.bank_fees', _d),
  ('FORMULE', 'banking.bank_fees', _d),
  ('OFFRE CONFORT', 'banking.bank_fees', _d),
  ('INTERET DEBITEUR', 'banking.overdraft_interest', _d),
  ('INTERETS DEBITEURS', 'banking.overdraft_interest', _d),
  ('COFIDIS', 'banking.consumer_loan', _d),
  ('CETELEM', 'banking.consumer_loan', _d),
  ('SOFINCO', 'banking.consumer_loan', _d),
  ('ONEY', 'banking.installments', _d),
  ('ALMA', 'banking.installments', _d),
  ('KLARNA', 'banking.installments', _d),
  ('PAYPAL', 'shopping.misc_online', _d),
  // Giving
  ('MEDECINS DU MONDE', 'giving.donations', _d),
  ('MEDECINS SANS FRONTIERES', 'giving.donations', _d),
  ('CROIX ROUGE', 'giving.donations', _d),
  ('RESTOS DU COEUR', 'giving.donations', _d),
  ('UNICEF', 'giving.donations', _d),
];

/// The community rules, ready for the [Classifier].
final List<CommunityRule> communityRules = [
  for (final (i, r) in _rules.indexed)
    CommunityRule(
      id: 'v$communityRulesVersion-${i + 1}',
      pattern: r.$1,
      standardCategoryId: r.$2,
      direction: r.$3,
      confidence: 60,
    ),
];

/// Raw entries, for tests and the future export to owncoffer-rules.
List<(String, String, Direction)> get communityRuleEntries => _rules;
