# Instance de démonstration

Pour montrer OwnCoffer sans aucune vraie donnée : une instance séparée, en mode démo, remplie d'un **foyer fictif** (trois comptes, douze mois d'opérations, abonnements, objectifs, un crédit auto, un paiement en plusieurs fois, quelques opérations à classer).

## Règles

- **Jamais** sur l'instance réelle : un projet Docker à part, avec sa propre base, son propre port et son propre fichier d'environnement.
- Les données sont **fictives** et générées toujours de la même façon (`shared/lib/src/demo/demo_data.dart`), datées par rapport au jour du remplissage.
- Chaque page affiche le bandeau « Démonstration : données fictives ».
- Les visiteurs reçoivent des comptes de **membres**, pas d'administrateur ; l'IA reste **désactivée** (ou branchée sur un modèle local avec un plafond bas).

## Lancer

```bash
# Depuis une copie du dépôt, jamais depuis /opt/docker/owncoffer.
docker/generate-env.sh docker/.env.demo     # secrets propres à la démo
# Dans docker/.env.demo : OWNCOFFER_DEMO=true, OWNCOFFER_PORT=8096,
# OWNCOFFER_PUBLIC_URL=https://demo.exemple.fr
docker compose -p owncoffer-demo --env-file docker/.env.demo -f docker/compose.yaml up -d
```

Puis : premier lancement (code d'installation dans les journaux du conteneur), créer le compte administrateur et le foyer, puis **Administration > Santé > « Remplir avec le foyer de démonstration »** (le foyer doit être vide). Inviter ensuite les visiteurs comme membres.

## Remettre à zéro

```bash
docker compose -p owncoffer-demo --env-file docker/.env.demo -f docker/compose.yaml down -v
```

puis relancer et remplir à nouveau.
