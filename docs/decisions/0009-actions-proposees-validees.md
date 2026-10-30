# 0009 — Modifications proposées, validées par l'utilisateur, exécutées par le moteur

**Statut** : Décidé (30 octobre 2026) — précise la décision 0006

## Contexte

L'utilisateur accepte que le conseiller (avec ou sans IA) prépare des modifications, à condition de toujours garder le dernier mot. La décision 0006 interdit à l'IA d'écrire directement dans les données.

## Décision

Le conseiller **propose des actions structurées** ; seul le **moteur financier les applique**, après **validation explicite** de l'utilisateur. Cycle en cinq étapes :

1. **Détection** : un problème ou une opportunité est repéré (par le moteur ou par l'IA).
2. **Proposition** : une action structurée est préparée (par exemple « plafond Loisirs : 200 € → 250 € »), avec l'état actuel, le nouvel état et l'écart.
3. **Explication** : raisons, données utilisées, conséquences attendues (simulées par le moteur).
4. **Validation** : l'utilisateur accepte, refuse ou modifie la proposition.
5. **Exécution** : le moteur vérifie et applique le changement.

Trois composants côté serveur :

- **Service de propositions** : stocke les propositions et leur statut (en attente, acceptée, refusée, modifiée, expirée, exécutée).
- **Service de validation** : vérifie au moment de l'exécution les droits de l'utilisateur, la validité de l'action et sa confirmation.
- **Service de commandes financières** : seul composant qui applique réellement les modifications.

**Périmètre** : objectifs et budgets, catégories, règles de classement, opérations prévues et paramètres de planification. **Jamais** d'opération bancaire réelle (virement, paiement) : OwnCoffer n'agit pas sur les comptes bancaires.

## Exigences non négociables

- **Validation côté serveur** : une confirmation visuelle ne suffit pas ; droits et validité sont revérifiés à l'exécution.
- **Idempotence** : une action validée deux fois n'est exécutée qu'une fois.
- **Données périmées** : chaque proposition enregistre la version des données sur lesquelles elle repose ; si elles ont changé avant la validation, la proposition est recalculée ou soumise à nouveau, jamais appliquée telle quelle.
- **Traçabilité** : journal d'audit (proposée par quoi — moteur ou IA, fournisseur et modèle —, quand, validée par qui, changement effectué).
- **Réversibilité** : toute modification exécutée peut être annulée, et les sauvegardes permettent de restaurer les données.

## Conséquences

- Tables : `action_proposals` (type, cible, état actuel, nouvel état, version des données, origine, statut, dates) et entrées dédiées dans `audit_log`.
- Mon conseiller (décision 0007) utilise ce même circuit pour ses recommandations, avec ou sans IA.
- Tests : idempotence, refus d'une proposition périmée, refus sans droits.
