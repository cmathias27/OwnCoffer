# Assistant (IA, facultatif)

OwnCoffer fonctionne entièrement sans IA. L'assistant est **désactivé par défaut** : chacun choisit de l'activer.

## L'activer

1. L'administrateur du serveur ajoute un fournisseur dans **Administration > IA** (Ollama sur votre réseau, Gemini, ChatGPT, Claude…).
2. Dans **Assistant : réglages** (icône ✨ tant qu'il n'est pas activé), choisissez le **fournisseur** et le **modèle**, puis activez l'assistant.

## La bulle de discussion

Une fois l'assistant activé, une **bulle** apparaît en bas à droite de l'écran. Touchez-la pour ouvrir la conversation, comme dans une messagerie : elle **reste ouverte quand vous changez de page**, et la bulle signale une réponse arrivée pendant qu'elle était réduite. L'en-tête permet de commencer une nouvelle conversation, d'ouvrir les réglages ou de réduire la fenêtre.

## Ce qu'il garde en tête, et l'historique

- Dans les réglages, **« Ce que l'assistant doit savoir »** : quelques phrases (« je suis payé le 28 »…) envoyées avec chaque question. Vous seul les voyez, et vous les oubliez d'un geste.
- Dans la bulle, le bouton **historique** montre vos 30 dernières conversations, gardées sur votre serveur et visibles par vous seul : touchez-en une pour la reprendre, ou supprimez-la.

## Ce qu'il peut faire

- **Répondre à vos questions** sur vos comptes : « combien ai-je dépensé en restaurants ce mois-ci ? », « quelles échéances arrivent ? ».
- **Classer les opérations à classer** : le raccourci le demande pour vous. Il propose une catégorie et, pour un commerçant qui revient, une règle.
- **Lire un document** (avec un modèle qui lit les images) : joignez la photo d'un tableau d'amortissement pour qu'il propose le crédit. Les tickets, factures et documents de crédit déjà gardés dans OwnCoffer se lisent aussi directement, depuis leur menu (bouton « Lire avec l'IA »).

## Ses limites, voulues

- Il lit vos chiffres **seulement par les fonctions d'OwnCoffer**, sur les comptes que vous voyez. Il ne calcule aucun montant lui-même.
- Il **ne modifie rien** : ses propositions arrivent dans **Mon conseiller**, et vous les acceptez ou non.
- Chaque réponse dit quelles fonctions ont été consultées. Avec un fournisseur en ligne, ce qui lui a été envoyé est signalé.
- Si le fournisseur ne répond pas, c'est dit clairement : OwnCoffer n'en essaie jamais un autre à sa place.

## Depuis un autre assistant (MCP)

Vous pouvez aussi interroger OwnCoffer depuis un assistant que vous utilisez déjà (Claude Desktop ou tout client MCP) : créez un **jeton personnel** dans cette page. Il agit avec vos droits, se révoque à tout moment, et ne fait que des propositions.
