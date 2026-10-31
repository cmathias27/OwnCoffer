# Installer OwnCoffer sur un serveur Docker

Prérequis : un serveur avec Docker et `docker compose`, et un accès extérieur par Cloudflare (décisions 0012 et 0015).

```sh
git clone --branch v0.1.1 https://github.com/cmathias27/OwnCoffer.git
cd OwnCoffer
./docker/generate-env.sh        # crée docker/.env avec des secrets aléatoires
nano docker/.env                # régler OWNCOFFER_PUBLIC_URL, le port, la version
docker compose -f docker/compose.yaml up -d
```

L'application répond sur `http://127.0.0.1:8080` (port et adresse réglables dans `docker/.env`). Si le port 8080 est déjà pris sur votre serveur, changez `OWNCOFFER_PORT`. Faites pointer le connecteur Cloudflare vers cette adresse : Cloudflare gère le HTTPS.

**Version** : `OWNCOFFER_TAG` choisit l'image. `0.1.1` (par défaut) est la version publiée ; `edge` suit la branche `main`, pour tester ce qui vient d'être fusionné. Les versions et leurs nouveautés sont listées dans [CHANGELOG.md](../CHANGELOG.md).

## Premier lancement

1. Récupérez le **code d'installation** à 8 chiffres affiché par le serveur :
   ```sh
   docker compose -f docker/compose.yaml logs owncoffer | grep "setup code"
   ```
2. Ouvrez l'application, saisissez ce code et votre email : vous devenez **administrateur du serveur**. Le code de vérification de l'email arrive par email si le SMTP est réglé dans `docker/.env`, sinon il s'affiche dans ces mêmes journaux.
3. Créez votre groupe (foyer), puis invitez les autres membres : **personne ne peut s'inscrire sans invitation**.

Ce code n'est valable que tant qu'aucun compte n'existe. Il change après 5 essais faux et à chaque redémarrage, ce qui empêche un inconnu de prendre la main sur un serveur fraîchement installé.

## Ce qui tourne

| Conteneur | Rôle | Visible depuis l'hôte |
| --- | --- | --- |
| `proxy` (Caddy) | Port unique : `/api/…` vers l'API, le reste vers l'application web | Oui, uniquement ce port |
| `owncoffer` | Serveur Serverpod et application web | Non |
| `postgres` | Base de données (volume `owncoffer_db`) | Non |

Les migrations de la base s'appliquent automatiquement au démarrage.

## Sécurité de l'accès

- **Vraie adresse IP** : le proxy ne croit l'en-tête `CF-Connecting-IP` que si la requête vient de Cloudflare ou du connecteur Cloudflare local (`OWNCOFFER_TRUSTED_LOCAL`). Si vous passez `OWNCOFFER_BIND=0.0.0.0`, retirez de cette liste les plages de votre réseau local.
- **Blocage automatique** : 5 échecs (mot de passe, code de vérification, code d'installation, lien d'invitation) en 15 minutes bloquent l'adresse IP 1 heure ; la durée double à chaque récidive. Votre réseau domestique peut être exclu avec `OWNCOFFER_IP_ALLOWLIST`.
- **Limite de requêtes** : 600 requêtes par minute et par IP sur l'API (`OWNCOFFER_RATE_LIMIT_PER_MINUTE`).
- **fail2ban ou CrowdSec** (optionnel) : chaque échec est écrit dans les journaux sous la forme `[auth-failure] ip=… kind=…`, et chaque blocage sous la forme `[ip-banned] ip=…`.

## Sauvegarder

```sh
./docker/backup.sh            # écrit docker/backups/owncoffer-<date>-manual.dump
```

Avec les mises à jour automatiques (plus bas), une sauvegarde est faite chaque nuit et avant chaque mise à jour. Sont gardées **sur le même serveur** les 30 dernières de nuit, les 10 dernières manuelles et les 10 dernières d'avant mise à jour : copiez régulièrement `docker/backups/` ailleurs.

La page **Administration du serveur** de l'application (onglet Sauvegardes) montre leur liste, signale une sauvegarde de nuit manquante ou en échec, et permet d'en demander une tout de suite (une toutes les 10 minutes au plus). Elle ne permet ni de télécharger ni de restaurer une sauvegarde : cela se fait sur le serveur.

Le fichier contient vos opérations bancaires : rangez-le dans un endroit chiffré, jamais dans le dépôt. Gardez aussi une copie de `docker/.env`, sans laquelle la double authentification ne se déchiffre plus.

Restaurer sur une installation vide :

```sh
docker compose -f docker/compose.yaml exec -T postgres \
  pg_restore -U owncoffer -d owncoffer --clean --if-exists < owncoffer-AAAA-MM-JJ.dump
```

## Mettre à jour

Sans les mises à jour automatiques ci-dessous :

1. Sauvegardez : `./docker/backup.sh`.
2. Lisez les nouveautés de la version dans [CHANGELOG.md](../CHANGELOG.md).
3. Récupérez les fichiers de la nouvelle version et changez `OWNCOFFER_TAG` dans `docker/.env` :
   ```sh
   git fetch --tags && git checkout v0.1.1      # la nouvelle version
   nano docker/.env                             # OWNCOFFER_TAG=0.1.1
   docker compose -f docker/compose.yaml pull
   docker compose -f docker/compose.yaml up -d
   ```

Les migrations de la base s'appliquent au démarrage.

## Mises à jour automatiques (recommandé)

Pour recevoir chaque **version publiée** sans intervenir, installez les unités systemd (en root, depuis le dossier d'installation) :

```sh
./docker/install-auto-update.sh
```

- `owncoffer-update.timer`, toutes les 15 minutes : si une nouvelle version `vX.Y.Z` est publiée et son image disponible, `docker/auto-update.sh` **sauvegarde la base**, passe les fichiers et l'image à cette version, redémarre et vérifie que l'API répond. Sinon, il **revient à la version précédente et restaure la sauvegarde**, puis n'essaie plus cette version : il attend la suivante. L'image `edge` (développement) n'est jamais installée ainsi.
- `owncoffer-backup.timer`, chaque nuit à 3 h 30 : sauvegarde dans `docker/backups/` (30 dernières gardées, dossier lisible par root seulement).
- `owncoffer-request.path` : dès que la page d'administration dépose une demande dans `docker/state/`, `docker/handle-requests.sh` l'exécute. Seules des actions prévues à l'avance sont possibles (une sauvegarde), quel que soit le contenu des fichiers.
- `docker/state/` est le **dossier d'échange** entre l'hôte et l'application (monté dans le conteneur, appartenant à l'utilisateur 10001 de l'image) : les scripts y écrivent la liste des sauvegardes et leur résultat, l'application y dépose ses demandes. Il ne contient jamais de données bancaires.
- Journal : `journalctl -u owncoffer-update -u owncoffer-backup -u owncoffer-request`.
- Une installation antérieure à la 0.3.8 reçoit `owncoffer-request.path` et le dossier d'échange toute seule, à la mise à jour automatique suivante. Pour ne pas attendre : relancez `./docker/install-auto-update.sh`, que l'on peut lancer autant de fois qu'on veut.

Le script refuse d'agir si des fichiers suivis par git ont été modifiés à la main dans le dossier d'installation : réglez tout dans `docker/.env`.

Depuis la page **Administration du serveur** (onglet Mises à jour), l'administrateur voit la version en service et la dernière publiée, lit les notes des versions à venir et installées, et consulte l'historique (installée, retour en arrière, refusée). Il peut aussi :

- **désactiver les mises à jour automatiques** : le choix est écrit dans `docker/state/settings` (`auto=false`) ; le script vérifie toujours les nouvelles versions, mais n'installe plus rien seul ;
- **vérifier maintenant** ou **installer une version** publiée plus récente : `docker/handle-requests.sh` lance `docker/auto-update.sh --check` ou `--install vX.Y.Z`, avec la même sauvegarde préalable et le même retour en arrière. Une version qui a échoué n'est plus réessayée automatiquement, mais peut être réinstallée à la main.

Le script s'utilise aussi en ligne de commande : `./docker/auto-update.sh --check`, `./docker/auto-update.sh --install v0.3.10`.

## Image privée

Si `docker compose pull` répond `denied` ou `unauthorized`, l'image `ghcr.io/cmathias27/owncoffer` n'est pas publique : rendez le paquet public dans GitHub (Packages, owncoffer, Package settings), ou connectez-vous avec `docker login ghcr.io` et un jeton ayant le droit `read:packages`.

## Points d'attention

- `docker/.env` contient les secrets : ne jamais le commiter ni le partager. Le perdre rend les sessions invalides, et le mot de passe de la base reste celui de la première installation.
- Laissez `OWNCOFFER_BIND=127.0.0.1` si le connecteur Cloudflare tourne sur la même machine.
- Sauvegardes : voir « Sauvegarder » et « Mises à jour automatiques » ci-dessus ; une copie hors du serveur reste à votre charge.
