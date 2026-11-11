# 0036 — Scan des tickets : pré-remplissage et opération créée depuis le ticket

**Statut** : Décidé (11 novembre 2026), mis en œuvre en 1.21.0

## Contexte

La lecture du texte sur l'appareil (décision 0023), l'analyse partagée d'un ticket (`readReceiptText` : commerçant, date, total, TVA) et la fenêtre de vérification existaient, mais n'étaient appelées nulle part : à l'envoi d'un ticket, l'utilisateur retapait montant, date et commerçant. Le rapprochement avec une opération bancaire existait déjà (factures à rattacher, 0.3.14), mais un ticket payé en espèces ou depuis un compte non importé n'avait aucune opération à laquelle se rattacher. La feuille de route (phase 6) demande le pré-remplissage de l'opération et son rapprochement, le ticket joint comme justificatif.

## Décision

1. **Lecture à l'envoi, sur l'appareil.** Quand un ticket en photo est ajouté aux factures à rattacher, l'application le lit sur l'appareil (Tesseract sous Android, décision 0023), sans IA et sans réseau, puis ouvre la fenêtre de vérification pré-remplie : l'utilisateur corrige ou confirme. Si aucun moteur n'est disponible (web, Windows), si le fichier n'est pas une image ou si rien n'est lu, la saisie à la main reste proposée comme avant. Rien n'est envoyé au serveur avant confirmation.
2. **Rapprochement inchangé.** Les montant, date et commerçant confirmés servent d'indices au serveur pour proposer l'opération bancaire correspondante, comme pour toute facture à rattacher.
3. **Créer l'opération depuis le ticket.** Dans les propositions d'un ticket encore non rattaché, « Créer l'opération depuis ce ticket » ouvre une fenêtre pré-remplie (montant, date, libellé = commerçant, compte courant en premier, catégorie facultative) ; à défaut de catégorie, les règles du groupe classent l'opération comme à l'import.
4. **Point d'accès.** `invoice.createOperation(invoiceId, accountId, date, amountCents, label, categoryId)` :
   - exige le droit d'écriture sur la facture et sur le compte, tous deux du même groupe (`transaction_access_denied` sinon) ;
   - refuse un ticket déjà rattaché (`invoice_already_attached`), un montant nul ou négatif, une date hors 2000–2100 ;
   - crée la dépense (montant négatif) par le même chemin que la saisie manuelle d'une opération (`TransactionEndpoint.create`, qui vérifie la catégorie et le libellé et applique les règles), puis rattache le ticket.
   Tests d'isolation dans `invoices_test.dart` (membre d'un autre groupe, compte et catégorie d'un autre groupe, lecteur, compte privé d'un autre membre), sur PostgreSQL et SQLite.

## Conséquences

- Aucune dépendance, aucune table, aucune migration, aucun appel réseau sortant.
- Écriture seulement après validation explicite de l'utilisateur, revérifiée côté serveur.
- Textes en français et en anglais.
- Reste le recadrage automatique (détection des bords, déclenchement quand l'image est nette) : les quatre coins à placer, la perspective et le contraste existent depuis 0.3.15.
