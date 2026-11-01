# Audit de sécurité

OwnCoffer garde les opérations bancaires d'un foyer. Avant de le conseiller à d'autres, un **audit externe** par une personne indépendante est souhaité (roadbook, phase 5). Cette page prépare cet audit : ce qu'il faut regarder, ce qui est déjà en place et vérifié automatiquement, et les points ouverts connus.

## État

| | |
| --- | --- |
| Audit externe | **Pas encore fait.** Recherche d'un auditeur bénévole ou d'un financement (dons). Contact : signalement privé GitHub (voir [SECURITY.md](../SECURITY.md)). |
| Revue interne | Faite pour la 1.0 (1er novembre 2026) : voir « Revue interne » plus bas. |
| Tests automatiques | Chaque pull request : isolation entre groupes pour chaque point d'accès, sauvegarde et restauration de bout en bout, vulnérabilités connues des dépendances (OSV). |

## Périmètre proposé à l'auditeur

Version : la dernière `vX.Y.Z` publiée, installée selon [INSTALLATION.md](INSTALLATION.md) (images vérifiables, [PUBLICATION.md](PUBLICATION.md)). Données fictives uniquement : le [mode démo](DEMO.md) en fournit.

1. **Contrôle d'accès** (priorité) : un membre ne doit jamais lire ni modifier les données d'un autre groupe, ni un compte « restreint » dont il n'est pas titulaire ; un lecteur ne doit rien modifier. Tout passe par `server/lib/src/security/access.dart`. Points d'accès : `server/lib/src/endpoints/`, serveur MCP (`server/lib/src/mcp/`), jetons personnels (décision 0018).
2. **Authentification** : connexion, réinitialisation du mot de passe, invitations, code d'installation du premier lancement, double authentification et codes de secours, blocage des IP (`ip_guard.dart`), confiance dans `CF-Connecting-IP` (`client_ip.dart`, `docker/Caddyfile`).
3. **Lecture des fichiers importés** (`shared/lib/src/import/`) : relevés OFX, QIF, CSV hostiles (très gros, mal formés, encodages), factures et documents (PDF, images : vérification du type réel, taille maximale).
4. **IA** (optionnelle) : la passerelle (`server/lib/src/ai/`) ne doit donner à l'IA que les comptes visibles de l'utilisateur, en lecture seule ; injection de consignes par un libellé ou un document ; une proposition de l'IA ne s'applique qu'après validation, revérifiée par le serveur (décision 0009).
5. **Hôte** : dossier d'échange `docker/state/` entre le conteneur et l'hôte (`handle-requests.sh` : seules des actions fixes, quel que soit le contenu des fichiers), sauvegardes chiffrées et leur clé (décision 0019), mises à jour automatiques et retour arrière.
6. **Applications Windows et Android** (décision 0020) : stockage de la session, refus du HTTP hors réseau local, aucune donnée financière gardée.
7. **Chaîne de publication** : workflow `.github/workflows/ci.yml`, signature Sigstore, SBOM (décision 0021).

## Modèle de menace

| Qui | Ce qu'on veut empêcher |
| --- | --- |
| Inconnu sur Internet | Toute lecture ; prise de contrôle d'un serveur fraîchement installé (code d'installation) ; force brute des mots de passe (blocage d'IP, limite de requêtes) |
| Membre d'un autre groupe du même serveur | Lecture ou modification des données d'un groupe dont il n'est pas membre |
| Membre du groupe | Lecture d'un compte restreint ; modification avec le rôle lecteur |
| Contenu hostile (relevé, facture, libellé) | Plantage ou lenteur du serveur ; consignes données à l'IA ; formule exécutée à l'ouverture d'un export CSV |
| Vol d'une copie de sauvegarde | Lecture des opérations (chiffrement, clé séparée) |
| Image ou fichier falsifié | Installation d'une version qui ne vient pas de ce dépôt (signatures vérifiables) |

Hors périmètre : l'administrateur du serveur (il a accès à tout par construction), la sécurité de Cloudflare et de l'hôte Docker.

## Revue interne (1.0)

Vérifié pour cette version, avec les tests qui le gardent :

- **Isolation** : chaque point d'accès qui touche des données d'un groupe a un test « un membre d'un autre groupe est refusé, les données restent intactes » (décision 0016) ; l'export (`export_test.dart`) en a un, et vérifie qu'un compte restreint n'est pas exporté pour un simple membre.
- **Export CSV** : une cellule de texte commençant par `=`, `+`, `-`, `@` est préfixée d'une apostrophe pour qu'un tableur ne l'exécute jamais comme une formule ; les montants ne sont pas touchés.
- **Export JSON** : ni clé de double authentification, ni codes de secours, ni clé d'IA, ni jeton ; l'empreinte du numéro de compte est retirée. Chaque export est journalisé.
- **Sauvegardes** : chiffrées (gpg AES-256, intégrité vérifiée), clé lisible par root seulement et passée par fichier (jamais sur la ligne de commande) ; restauration testée dans un conteneur sans réseau ; une sauvegarde modifiée ou une mauvaise clé sont refusées (`tool/test_backup_restore.sh`).
- **Applications natives** : HTTPS obligatoire hors réseau local, adresse vérifiée auprès d'un vrai serveur OwnCoffer avant d'être gardée ; sauvegarde Android dans le nuage désactivée.
- **En-têtes HTTP** (`docker/Caddyfile`) : `X-Frame-Options DENY`, pas de cache pour l'API.

## Points ouverts connus

1. **Row Level Security PostgreSQL** non mise en place (décision 0016) : une faille dans un point d'accès ne serait pas rattrapée par la base. Compensé par les tests d'isolation.
2. **Licence de Serverpod** (décision 0001) : à trancher avant d'ouvrir largement.
3. **Vérification de la signature de l'image** par `docker/auto-update.sh` avant installation : pas encore (décision 0021).
4. **Applications non signées par un éditeur** : l'utilisateur doit passer outre les avertissements de Windows et d'Android (décision 0020).
5. **Clé de sauvegarde sur le même serveur que les sauvegardes** : protège les copies emportées ailleurs, pas un attaquant qui a déjà les droits root sur le serveur.

## Après l'audit

Chaque constat devient une issue (privée tant qu'il n'est pas corrigé), corrigée dans une version publiée ; cette page reçoit la date de l'audit, son périmètre réel et la liste des constats corrigés.
