# Utiliser OwnCoffer

Ce guide fait le tour de l'application. Chaque page a aussi son aide détaillée, ouverte par le bouton **?** en haut de l'écran ; ces pages sont listées à la fin, en français et en anglais. Questions courantes : [FAQ.md](FAQ.md).

## Où l'utiliser

- **Dans le navigateur**, à l'adresse de votre serveur, sur ordinateur, tablette ou téléphone.
- **Installée sur le téléphone** depuis le navigateur (« Ajouter à l'écran d'accueil »).
- **Applications Windows et Android**, jointes à chaque version : [APPLICATIONS.md](APPLICATIONS.md). Au premier lancement, elles demandent l'adresse de votre serveur.

L'écran s'adapte : barre d'onglets en bas sur téléphone, menu à gauche sur grand écran. Le menu du compte (icône en haut à droite sur téléphone) donne accès aux membres, à la sécurité, à l'export, à l'aide et à « Donner un avis ».

## Premier lancement

1. L'administrateur du serveur crée son compte avec le code d'installation ([INSTALLATION.md](INSTALLATION.md)), puis le **groupe** (votre foyer) et **invite** les autres membres par courriel. Personne ne peut s'inscrire sans invitation.
2. Chacun active la **double authentification** (menu du compte → Sécurité) et range ses codes de secours.

## Le quotidien en cinq étapes

1. **Comptes** : créez chaque compte bancaire avec son solde de départ et, si vous en avez un, son découvert autorisé comme seuil d'alerte. Un compte peut être partagé avec tout le groupe ou **restreint** à certains membres.
2. **Import** : téléchargez le relevé sur le site de votre banque (OFX de préférence, sinon QIF ou CSV) et déposez-le. Un aperçu montre ce qui sera ajouté ; les opérations déjà présentes sont écartées. « Plusieurs fichiers » importe plusieurs relevés d'un coup.
3. **Opérations** : la plupart sont classées automatiquement (règles du foyer, règles communes, votre historique). Le filtre « À classer » montre le reste ; « Toujours classer ainsi » crée une règle. Une opération se ventile entre plusieurs catégories, se pointe, reçoit une note ou une facture.
4. **Opérations prévues** : déclarez ce qui revient (salaire, loyer, abonnements, échéances de crédit). Elles entrent dans le **solde prévu** et sont reliées automatiquement aux vraies opérations quand elles arrivent.
5. **Budget** : fixez des objectifs par catégorie ; OwnCoffer prévient avant qu'ils soient dépassés.

## Voir et prévoir

- **Accueil** : soldes du jour, reste à vivre jusqu'à la prochaine paie, ce qui arrive, alertes.
- **Prévisions** : la courbe du solde jour par jour sur 30 jours, 90 jours ou un an, le point bas et la date d'un éventuel découvert. Le **simulateur d'achat** montre l'effet d'un achat payé comptant ou en plusieurs fois.
- **Budget et analyses** : dépenses par catégorie et par période, comparaison avec les périodes précédentes, bilan du mois, fiabilité des prévisions, opérations inhabituelles, frais bancaires.
- **Crédits** : tableau d'amortissement, reste à rembourser, taux d'endettement, simulation d'un remboursement anticipé ou d'une renégociation.
- **Abonnements** : la liste de ce qui est prélevé régulièrement, les hausses de prix, la comparaison avec une autre offre.
- **Factures** : rangées avec l'opération qui les a payées, avec leur date de fin de garantie.

## Mon conseiller et l'assistant

- **Mon conseiller** propose des changements (une règle, un objectif, un abonnement à déclarer…) et signale ce qui mérite votre attention, chiffres à l'appui. **Rien ne change sans votre accord**, et chaque acceptation s'annule.
- **L'assistant IA** est optionnel et désactivé par défaut. L'administrateur choisit les fournisseurs (local comme Ollama, ou en ligne) ; chacun décide de l'activer. Il lit vos chiffres par OwnCoffer, qui fait tous les calculs, et ne modifie jamais rien lui-même.

## Partager avec son foyer

Rôles dans un groupe : **lecteur** (voit), **utilisateur** (importe, classe, corrige), **administrateur** (gère les comptes, les membres et les réglages du groupe). Les modifications importantes sont notées dans le **journal du groupe**.

## Vos données

- **Exporter** : menu du compte → « Exporter mes données ». **JSON** complet (tout ce que vous voyez, montants en centimes) ou **CSV** des opérations pour LibreOffice Calc ou Excel (séparateur `;` et virgule décimale en français, `,` et point en anglais).
- **Sauvegardes** : faites par le serveur chaque nuit, chiffrées, et restaurées à l'essai pour vérifier qu'elles sont bonnes. L'administrateur les suit dans Administration → Sauvegardes.
- **Corbeille** : une opération supprimée y reste jusqu'à ce que vous la vidiez.

### Format du JSON exporté

```json
{
  "format": "owncoffer-export",
  "formatVersion": 1,
  "exportedAt": "2026-11-02T08:00:00.000Z",
  "serverVersion": "1.0.0",
  "amounts": "cents",
  "group": {}, "member": {}, "members": [],
  "accounts": [], "categories": [], "rules": [], "goals": [],
  "scheduledTransactions": [], "transactions": [], "transactionSplits": [],
  "balanceChecks": [], "imports": [], "loans": [], "loanDocuments": [],
  "invoices": [], "aiMemories": [], "aiConversations": []
}
```

Les opérations (`transactions`) vont de la plus ancienne à la plus récente ; celles de la corbeille ont un `deletedAt`. Les identifiants (`id`, `accountId`, `categoryId`…) relient les éléments entre eux. Les factures et documents de crédit sont décrits (nom, type, taille, date) sans leur contenu. `formatVersion` augmentera à chaque changement incompatible.

## Accessibilité

Tous les boutons ont un nom lu par les lecteurs d'écran (TalkBack, NVDA, VoiceOver), les zones à toucher sont assez grandes, les contrastes sont vérifiés en thème clair et sombre, et l'application reste utilisable avec un texte agrandi à 200 %. Les graphiques ont une description lue. Ces règles sont vérifiées par des tests automatiques ; un problème rencontré se signale avec « Donner un avis ».

## Les pages d'aide de l'application

| Page | Français | English |
| --- | --- | --- |
| Premiers pas | [start](../app/assets/help/fr/start.md) | [start](../app/assets/help/en/start.md) |
| Accueil | [home](../app/assets/help/fr/home.md) | [home](../app/assets/help/en/home.md) |
| Comptes | [accounts](../app/assets/help/fr/accounts.md) | [accounts](../app/assets/help/en/accounts.md) |
| Opérations | [operations](../app/assets/help/fr/operations.md) | [operations](../app/assets/help/en/operations.md) |
| Import | [import](../app/assets/help/fr/import.md) | [import](../app/assets/help/en/import.md) |
| Catégories et règles | [categories](../app/assets/help/fr/categories.md) | [categories](../app/assets/help/en/categories.md) |
| Budget | [budget](../app/assets/help/fr/budget.md) | [budget](../app/assets/help/en/budget.md) |
| Prévisions | [forecast](../app/assets/help/fr/forecast.md) | [forecast](../app/assets/help/en/forecast.md) |
| Crédits | [loans](../app/assets/help/fr/loans.md) | [loans](../app/assets/help/en/loans.md) |
| Factures | [invoices](../app/assets/help/fr/invoices.md) | [invoices](../app/assets/help/en/invoices.md) |
| Mon conseiller | [advisor](../app/assets/help/fr/advisor.md) | [advisor](../app/assets/help/en/advisor.md) |
| Assistant | [assistant](../app/assets/help/fr/assistant.md) | [assistant](../app/assets/help/en/assistant.md) |
| Notifications | [notifications](../app/assets/help/fr/notifications.md) | [notifications](../app/assets/help/en/notifications.md) |
| Membres | [members](../app/assets/help/fr/members.md) | [members](../app/assets/help/en/members.md) |
| Sécurité | [security](../app/assets/help/fr/security.md) | [security](../app/assets/help/en/security.md) |
| Vos données | [privacy](../app/assets/help/fr/privacy.md) | [privacy](../app/assets/help/en/privacy.md) |
| Administration | [admin](../app/assets/help/fr/admin.md) | [admin](../app/assets/help/en/admin.md) |
