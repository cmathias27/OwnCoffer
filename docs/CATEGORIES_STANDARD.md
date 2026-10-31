# Catalogue de catégories standard

Le catalogue standard donne à chaque catégorie un **identifiant stable**, commun à toutes les installations d'OwnCoffer. Chaque groupe garde ses propres catégories (noms, couleurs, découpage) mais les relie à une entrée du catalogue : c'est ce qui permet aux **règles communautaires** de fonctionner chez tout le monde, même quand chacun renomme ou découpe ses catégories (voir le cahier des charges, section Classement).

Fichier de référence : [`data/standard_categories.yaml`](data/standard_categories.yaml) — **18 catégories et 79 sous-catégories** (version 2 du catalogue ; `family.pets`, retirée, compte parmi elles), en français et en anglais. Il sera déplacé dans `shared/` en phase 1 et chargé par la migration initiale.

## Règles

- **Identifiants stables** : `catégorie` ou `catégorie.sous_catégorie`, en anglais, minuscules et `_`. Un identifiant n'est **jamais renommé ni réutilisé** ; une entrée retirée reçoit `deprecated: true` et reste lisible.
- **Noms traduits** : `fr` et `en` obligatoires ; d'autres langues s'ajoutent sans changer les identifiants.
- **Types** :
  - `income` : revenus ;
  - `expense` : dépenses ;
  - `savings` : argent mis de côté (compté à part, ni revenu ni dépense) ;
  - `transfer` : mouvements internes (virement entre ses comptes, retrait d'espèces, débit différé de carte), **exclus** des revenus et des dépenses pour ne pas les compter deux fois.
- **Pas de catégorie « À classer »** : une opération non classée a simplement un statut « à classer », ce n'est pas une catégorie.
- **Évolution** : toute modification passe par une pull request et incrémente `version` ; les installations existantes migrent sans perdre leurs liens.
  - Une entrée ajoutée porte `since: <version>` : au démarrage, le serveur l'ajoute une fois aux groupes créés avant cette version (jamais si la catégorie parente a été archivée).
  - Une entrée retirée peut porter `replaced_by: <id>` : la catégorie du groupe qui y était reliée est déplacée et reliée à la nouvelle entrée, avec son nom, ses opérations et ses règles.

## Les catégories

| Catégorie | Identifiant | Type | Sous-catégories |
| --- | --- | --- | --- |
| **Revenus** / Income | `income` | income | Salaire (`income.salary`), Primes (`income.bonus`), Allocations et prestations (`income.benefits`), Retraite (`income.pension`), Revenus locatifs (`income.rental`), Remboursements (`income.refunds`), Revenus financiers (`income.investment`), Autres revenus (`income.other`) |
| **Logement** / Housing | `housing` | expense | Loyer (`housing.rent`), Crédit immobilier (`housing.mortgage`), Charges de copropriété (`housing.service_charges`), Électricité et gaz (`housing.energy`), Eau (`housing.water`), Assurance habitation (`housing.insurance`), Travaux et entretien (`housing.maintenance`), Ameublement et équipement (`housing.furniture`) |
| **Alimentation** / Food | `food` | expense | Courses (`food.groceries`), Restaurants (`food.restaurants`), Livraison et à emporter (`food.takeaway`), Cantine et restaurant d'entreprise (`food.canteen`) |
| **Transport** / Transport | `transport` | expense | Carburant et recharge (`transport.fuel`), Transports en commun (`transport.public_transport`), Train et avion (`transport.train_plane`), Parking et péages (`transport.parking_tolls`), Entretien du véhicule (`transport.vehicle_maintenance`), Assurance du véhicule (`transport.vehicle_insurance`), Crédit ou location du véhicule (`transport.vehicle_loan`), Taxi et VTC (`transport.taxi_ride_hailing`) |
| **Santé** / Health | `health` | expense | Médecins et spécialistes (`health.doctors`), Pharmacie (`health.pharmacy`), Mutuelle (`health.health_insurance`), Optique et dentaire (`health.optical_dental`), Hôpital (`health.hospital`) |
| **Télécoms et abonnements** / Telecom and subscriptions | `subscriptions` | expense | Téléphone et internet (`subscriptions.phone_internet`), Streaming, vidéo et musique (`subscriptions.streaming`), Logiciels et services en ligne (`subscriptions.software`), Presse (`subscriptions.press`) |
| **Loisirs** / Leisure | `leisure` | expense | Sport (`leisure.sport`), Culture et sorties (`leisure.culture_outings`), Loisirs et jeux (`leisure.hobbies`), Voyages et vacances (`leisure.travel`), Cadeaux (`leisure.gifts`) |
| **Achats** / Shopping | `shopping` | expense | Vêtements et chaussures (`shopping.clothing`), High-tech (`shopping.electronics`), Bricolage et jardinage (`shopping.diy_garden`), Beauté et soins (`shopping.personal_care`), Achats en ligne divers (`shopping.misc_online`) |
| **Enfants et famille** / Children and family | `family` | expense | Garde d'enfants (`family.childcare`), Scolarité et fournitures (`family.school`), Activités des enfants (`family.kids_activities`), Argent de poche (`family.pocket_money`), ~~Animaux (`family.pets`)~~ retirée en version 2, remplacée par `pets.other` |
| **Animaux** / Pets | `pets` | expense | Alimentation animale (`pets.food`), Vétérinaire (`pets.vet`), Assurance animaux (`pets.insurance`), Toilettage, garde et pension (`pets.care`), Accessoires et jouets (`pets.supplies`), Autres dépenses animaux (`pets.other`) |
| **Formation** / Education | `education` | expense | Frais de formation (`education.tuition`), Livres et fournitures (`education.books_supplies`) |
| **Banque et crédits** / Banking and loans | `banking` | expense | Frais bancaires (`banking.bank_fees`), Agios et intérêts débiteurs (`banking.overdraft_interest`), Crédits à la consommation (`banking.consumer_loan`), Paiements en plusieurs fois (`banking.installments`), Assurances (vie, prévoyance) (`banking.other_insurance`) |
| **Impôts et taxes** / Taxes | `taxes` | expense | Impôt sur le revenu (`taxes.income_tax`), Taxe foncière (`taxes.property_tax`), Taxe d'habitation (`taxes.housing_tax`), Autres taxes et amendes (`taxes.other_taxes_fines`) |
| **Dons et solidarité** / Giving | `giving` | expense | Dons à des associations (`giving.donations`), Aide à des proches (`giving.family_support`) |
| **Dépenses professionnelles** / Work expenses | `professional` | expense | Frais remboursables (`professional.reimbursable`), Dépenses d'activité indépendante (`professional.self_employed`) |
| **Épargne et placements** / Savings and investments | `savings` | savings | Versement sur épargne (`savings.savings_deposit`), Placements (`savings.investments`) |
| **Mouvements internes** / Internal movements | `transfers` | transfer | Virement entre mes comptes (`transfers.between_accounts`), Retrait d'espèces (`transfers.cash_withdrawal`), Débit différé de carte (`transfers.card_settlement`) |
| **Divers** / Miscellaneous | `misc` | expense | Autres dépenses (`misc.other`) |

## Choix à noter

- **Crédits** : le crédit immobilier est rangé dans Logement, le crédit auto dans Transport, les autres crédits et les paiements en plusieurs fois dans Banque et crédits — on voit ainsi le vrai coût du logement et du véhicule.
- **Débit différé de carte** : classé en mouvement interne quand les achats de la carte sont déjà suivis un par un, pour ne pas les compter deux fois.
- **Remboursements** (mutuelle, Sécurité sociale) : revenus, sous-catégorie Remboursements ; ils pourront être rapprochés de la dépense d'origine en phase 4.
