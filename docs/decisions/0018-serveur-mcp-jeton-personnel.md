# 0018 — OwnCoffer comme serveur MCP, par jeton personnel

**Statut** : Décidé (1er novembre 2026) — complète les décisions 0008 et 0009

## Contexte

L'utilisateur veut pouvoir interroger OwnCoffer depuis un assistant qu'il utilise déjà (Claude Desktop ou tout client MCP), et pas seulement par l'assistant intégré. Le *Model Context Protocol* (MCP) permet à un assistant d'appeler les fonctions d'un serveur.

## Décision

- OwnCoffer expose un **serveur MCP** à l'adresse `/mcp` (JSON-RPC 2.0 sur HTTP, une réponse JSON par requête).
- Il offre **exactement les fonctions de l'assistant intégré** (`AiContext`) : vues en lecture seule calculées par le moteur (comptes, opérations, budget, échéances, prévisions, objectifs, catégories) et **propositions** (catégorie, crédit) qui n'appliquent rien : l'utilisateur les accepte dans Mon conseiller (décision 0009).
- L'accès se fait par un **jeton personnel** créé par l'utilisateur pour un groupe : seule son empreinte (SHA-256) est gardée, il est affiché une fois, révocable, au plus 10 actifs. Il agit avec les droits de son utilisateur et seulement sur les comptes qu'il voit ; il cesse de fonctionner si l'utilisateur quitte le groupe ou est bloqué.
- Chaque appel d'outil est **journalisé** (sans son contenu) ; la dernière utilisation du jeton est affichée.
- **Ce qui sort** : avec MCP, les données renvoyées par les fonctions partent vers le modèle utilisé par le client de l'utilisateur, en dehors de la passerelle IA (décision 0008). C'est un choix explicite de l'utilisateur, dit à la création du jeton.

## Conséquences

- Table `mcp_tokens` ; route web `/mcp` ; tests : jeton invalide ou révoqué refusé, compte restreint invisible, outil inconnu refusé, perte d'accès en quittant le groupe.
- Aucune écriture directe possible par MCP.
