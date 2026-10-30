# Maquettes

Les maquettes sont sur une toile de design : **[OwnCoffer — aperçus](https://claude.ai/artifact/UUoygwpNiXzmJwBJ4B2jw2)** (accès à demander au propriétaire du dépôt). Elles servent de référence visuelle ; les montants sont des données de démonstration.

## Style retenu

- Fond gris très clair, cartes blanches, une couleur principale indigo (`#3346C8`), une couleur fixe par catégorie dans tous les écrans.
- Typographies : **Manrope** pour les titres et les chiffres, **Inter** pour le texte ; chiffres à chasse fixe.
- Contrastes conformes aux règles d'accessibilité (texte 4,5:1), cibles tactiles de 44 px minimum, vrais boutons et champs étiquetés.

## Écrans de l'application web (alpha)

| Écran | Contenu | Phase |
| --- | --- | --- |
| Connexion | Email et mot de passe, passkey, double authentification à 6 chiffres, message de blocage après 5 échecs, choix FR / EN | 2 |
| Assistant de premier lancement | 5 étapes (administrateur, groupe, premier compte, premier import, terminé) ; étape « premier compte » avec Caisse d'Épargne | 2-3 |
| Opérations | Recherche et filtres, filtre « à classer », pointage, libellé nettoyé et libellé brut, source de la catégorie (votre règle, communauté, historique), panneau de détail qui propose de créer une règle et de la partager | 3 |
| Import d'un relevé | Dépôt de fichier, compte reconnu, encodage détecté, bilan (lues, nouvelles, doublons, classées, à classer), aperçu, historique avec annulation d'un import | 3 |
| Catégories et règles | Catégories reliées au catalogue standard, règles avec leur origine et le nombre d'opérations, nouvelle règle avec testeur | 3 |
| Réglages — IA | Interrupteur « Utiliser une IA » (optionnelle), modèle local ou fournisseur externe, capacités détectées, plafond, ce que voit et peut faire l'IA, pas de basculement automatique | 4 |
| Administration | État du serveur (version, base, disque, sauvegarde), mise à jour disponible, utilisateurs et double authentification, adresses bloquées (IP réelle via Cloudflare), retours reçus | 2-5 |

## Autres écrans

| Écran | Phase |
| --- | --- |
| Tableau de bord (ordinateur) : soldes, reste à vivre, répartition, objectifs, échéances, solde prévu | 3-4 |
| Crédits et paiements en plusieurs fois | 4 |
| Téléphone : accueil, import, objectifs (servent aussi de base à l'application installable) | 1-4 |
