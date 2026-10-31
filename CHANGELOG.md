# Nouveautés

Les versions suivent le [versionnage sémantique](https://semver.org/lang/fr/). L'image Docker de chaque version est `ghcr.io/cmathias27/owncoffer:<version>` ; l'installation et la mise à jour sont décrites dans [docs/INSTALLATION.md](docs/INSTALLATION.md).

## 0.1.0 — alpha (31 octobre 2026)

Première version utilisable, pour un usage personnel (décision 0010). À utiliser un mois avant d'ajouter quoi que ce soit (#20).

### Comptes et opérations

- Comptes bancaires : solde initial, seuil d'alerte (découvert autorisé), compte restreint à certains membres.
- Solde actuel, solde pointé et point bas à 30 jours sur chaque compte.
- Opérations : recherche, filtres « À classer » et « Non pointées », pointage, note personnelle, corbeille avec annulation, saisie manuelle.
- Montants en centimes entiers de bout en bout ; un montant ambigu est refusé plutôt que deviné.

### Import des relevés

- Caisse d'Épargne en QIF, OFX et CSV (et tout CSV dont on choisit les colonnes) ; accents, virgule décimale et dates françaises gérés.
- Aperçu avant import : nouvelles opérations, doublons écartés par empreinte (même entre QIF et OFX), doublons possibles à cocher.
- Solde de la banque (OFX) comparé au solde qu'aura OwnCoffer après l'import.
- Compte reconnu d'après le numéro du fichier OFX, sans stocker ce numéro.
- Historique des imports, avec annulation.

### Classement

- 90 catégories standard, renommables, et 154 règles communautaires pour les grandes enseignes.
- Libellés nettoyés : « PRLV SEPA EDF SA REF… » devient « EDF ».
- Ordre : règles du groupe, puis règles communautaires, puis vos choix passés ; l'origine de chaque catégorie est affichée.
- « Toujours classer ainsi » crée une règle et reclasse les opérations concernées ; écran des règles avec testeur de libellé.
- Sur le relevé de démonstration, 70 % des opérations sont classées sans intervention.

### Solde prévu et alertes

- Opérations prévues (loyer, salaire, abonnements), courbe du solde jour par jour sur 30 jours, 90 jours ou 1 an.
- Rapprochement des opérations réelles avec les échéances prévues ; échéances en retard signalées.
- Alerte de découvert prévu dans l'application et par email, vérifiée dès qu'une opération change.

### Sécurité

- Inscription sur invitation seulement ; double authentification (TOTP et codes de secours).
- Blocage automatique des adresses IP après des échecs répétés ; limite de requêtes.
- Chaque point d'accès vérifie groupe, rôle et visibilité du compte, et a son test d'isolation (décision 0016).
- Un seul port publié, derrière Cloudflare ; aucune télémétrie.

### Limites connues

- Une seule banque testée : la Caisse d'Épargne.
- Pas encore de sauvegarde automatique : voir « Sauvegarder » dans l'installation.
- Pas d'IA ni d'objectifs : ils viennent en phase 4.
