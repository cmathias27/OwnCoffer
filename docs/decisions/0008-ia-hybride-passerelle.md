# 0008 — IA hybride derrière une passerelle IA unique

**Statut** : Décidé (30 octobre 2026)

## Contexte

L'utilisateur doit pouvoir choisir entre un modèle externe (API d'un fournisseur) et un modèle local (sur le serveur OwnCoffer ou une autre machine de son réseau), sans que chaque fonction de l'application dépende d'un fournisseur précis. L'IA doit avoir accès à toutes les données du compte associé, et seulement à celles-ci.

## Décision

1. **Passerelle IA** (*AI Gateway*) : composant central par lequel passe toute demande à une IA. Aucune fonction n'appelle un fournisseur directement. Elle gère :
   - les **adaptateurs** par fournisseur derrière une interface commune ;
   - le **choix du fournisseur et du modèle** par l'utilisateur ;
   - les **capacités** de chaque modèle (appel de fonctions, lecture d'images, longueur de contexte), pour n'activer que ce qu'il sait faire ;
   - les **erreurs** : un modèle indisponible est signalé clairement ; **jamais de basculement automatique** vers un fournisseur externe ;
   - la **confidentialité** : affichage de ce qui quitte le serveur quand un modèle externe est utilisé ; minimisation des données envoyées.
2. **Hybride = choix explicite** : les données ne sont jamais envoyées à plusieurs modèles ni à un modèle externe sans que l'utilisateur l'ait choisi.
3. **Contexte financier** : l'IA ne lit jamais la base. Elle interroge des fonctions internes en lecture seule, qui renvoient des données structurées calculées par le moteur financier, par exemple :
   - `get_account_overview` — situation générale ;
   - `get_transactions` — historique des opérations ;
   - `get_budget_status` — état des objectifs et budgets ;
   - `get_upcoming_expenses` — échéances à venir ;
   - `get_cashflow_forecast` — prévisions de trésorerie, avec hypothèses et marge d'incertitude ;
   - `get_financial_goals` — objectifs et projets.
4. **Périmètre** : toutes les données des comptes visibles par l'utilisateur qui a connecté l'IA, rien au-delà. L'IA n'attribue jamais une dépense à un membre du foyer sans information explicite.
5. **Livraison progressive** : l'interface commune est conçue dès le départ, mais une première version ne livre qu'**un connecteur externe et un connecteur local** ; les autres fournisseurs viennent ensuite.

## Conséquences

- Phase 3 : passerelle, un connecteur externe (compatible API OpenAI, ce qui couvre plusieurs fournisseurs), un connecteur local (Ollama).
- Les fonctions de contexte sont testées comme le moteur financier ; elles appliquent les mêmes permissions que l'API.
- Complète la décision 0006 (IA optionnelle) ; la décision 0009 précise comment l'IA propose des modifications.
