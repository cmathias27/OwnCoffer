# Politique de sécurité

OwnCoffer manipule des données bancaires : la sécurité est une priorité.

## Signaler une faille

**N'ouvrez pas d'issue publique pour une faille de sécurité.** Utilisez le signalement privé de GitHub : onglet **Security** du dépôt, puis **Report a vulnerability**.

Indiquez si possible :

- la version ou le commit concerné ;
- les étapes pour reproduire ;
- l'impact estimé (accès à des données d'un autre groupe, contournement de la connexion, etc.).

Nous accusons réception sous 7 jours et vous tenons informé jusqu'à la correction. Merci de laisser le temps de publier un correctif avant toute divulgation.

## Versions prises en charge

Seule la **dernière version publiée** reçoit des correctifs de sécurité. Les serveurs en mises à jour automatiques l'installent d'eux-mêmes ([docs/INSTALLATION.md](docs/INSTALLATION.md)).

## Principes appliqués

- Permissions vérifiées par le serveur à chaque requête, avec un test d'isolation entre groupes pour chaque point d'accès ; la Row Level Security de PostgreSQL est repoussée (décision 0016).
- Mots de passe hachés avec Argon2, double authentification, blocage automatique des IP après plusieurs échecs.
- HTTPS obligatoire pour l'accès extérieur ; base de données jamais exposée.
- Aucune télémétrie ; clés API chiffrées et jamais journalisées.
- Sauvegardes chiffrées, restauration testée chaque nuit (décision 0019).
- Versions signées (Sigstore) avec la liste de leurs composants (SBOM) (décision 0021).
- Dépendances surveillées : Dependabot et recherche des vulnérabilités connues (OSV) à chaque pull request.

Le périmètre et l'état de l'audit de sécurité sont décrits dans [docs/AUDIT_SECURITE.md](docs/AUDIT_SECURITE.md).
