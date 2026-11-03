# 0017 — Fournisseurs d'IA configurés par l'administrateur du serveur

**Statut** : Décidé (1er novembre 2026) — précise la décision 0008

## Contexte

La passerelle IA (décision 0008) appelle le fournisseur choisi par l'utilisateur. Si chaque utilisateur pouvait saisir l'adresse d'un fournisseur, n'importe quel membre d'un foyer pourrait faire appeler par le serveur une adresse de son réseau interne (box, NAS, autres services), et y envoyer des données.

## Décision

- Seul l'**administrateur du serveur** ajoute, modifie ou supprime un fournisseur : nom, type (compatible OpenAI pour l'externe, Ollama pour un modèle local), adresse de l'API, clé, modèles proposés, capacités (appel de fonctions, lecture d'images), plafond mensuel de demandes par utilisateur.
- L'**administrateur du serveur règle également le degré d'autonomie / champ d'action global de l'IA** sur une échelle de 1 à 5 :
  1. *Lecture seule* : consultation du contexte et réponses aux questions ; aucune proposition d'action ni analyse de justificatifs.
  2. *Consultation de documents* : extraction des justificatifs et contrats soumis (tickets, factures, crédits) pour présentation et vérification par l'utilisateur ; aucune proposition proactive.
  3. *Propositions avec validation (par défaut)* : l'IA prépare des propositions structurées (catégorisations, crédits) validées explicitement par l'utilisateur (décision 0009).
  4. *Automatisation limitée* : exécution automatique des actions simples et réversibles avec journal d'audit complet ; confirmation requise pour le reste.
  5. *Contrôle total interne* : gestion autonome au sein d'OwnCoffer (budgets, règles, alertes). Frontière stricte : OwnCoffer n'effectue jamais d'opération bancaire réelle (virements, paiements).
- La **clé** est chiffrée (AES-256-GCM, clé dérivée du secret du serveur), jamais renvoyée à l'application ni écrite au journal.
- Chaque **utilisateur** choisit parmi les fournisseurs activés, et un de leurs modèles ; l'IA est **désactivée par défaut** (décision 0006).
- Un fournisseur qui ne répond pas est signalé ; **jamais** de bascule vers un autre.
- Les adresses hors de la machine et du réseau local sont présentées comme **externes** : l'application dit ce qui leur est envoyé.

## Conséquences

- Tables `ai_providers`, `ai_preferences`, `ai_usage`, `ai_server_settings`.
- Les fonctions de contexte (`AiContext`) sont les seules portes de l'IA vers les données ; elles appliquent les permissions de l'utilisateur ; les modifications passent par le circuit des propositions (décision 0009).
