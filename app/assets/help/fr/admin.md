# Administration du serveur

Cette page n'est visible que par l'**administrateur du serveur**. Elle ne montre jamais les données financières d'un foyer.

## Les onglets

- **Santé et chiffres** : version, durée de fonctionnement, base de données, espace disque, envoi des courriels (avec un courriel de test), chiffres du serveur et taux de classement automatique.
- **Utilisateurs** : comptes, foyers et rôles. On peut **bloquer** un compte, qui est déconnecté et ne peut plus se connecter, sans rien supprimer.
- **Invitations** : toutes les invitations en attente, à révoquer ; inviter dans n'importe quel foyer.
- **IP bloquées** après trop d'échecs de connexion, à débloquer.
- **Journal** des dernières actions sensibles : qui, quoi, quand.
- **Sauvegardes** : sauvegarde de chaque nuit, « Sauvegarder maintenant », liste. La restauration se fait sur le serveur seulement : les sauvegardes contiennent toutes les données bancaires.
- **Mises à jour** : version en service, dernière publiée, mises à jour automatiques ou non. L'installation sauvegarde d'abord et revient en arrière si la nouvelle version ne démarre pas.
- **IA** : les fournisseurs d'IA proposés aux utilisateurs.
- **Retours** : les messages envoyés par les utilisateurs avec « Donner un avis » ; cochez ceux qui sont traités.

## Ajouter un fournisseur d'IA

Choisissez **Google Gemini**, **OpenAI ChatGPT** ou **Anthropic Claude** et collez la clé d'API : la liste des modèles est demandée au fournisseur, ce qui vérifie aussi la clé. Pour **Ollama**, indiquez l'adresse de la machine. Seuls les modèles courants sont gardés (sans versions d'essai ni variantes spécialisées). **« Tester la connexion »** essaie une vraie petite conversation avec le premier modèle : en cas d'erreur, la réponse exacte du fournisseur s'affiche (clé refusée, modèle inconnu…). La clé est chiffrée et n'est jamais réaffichée. Un plafond mensuel de demandes par utilisateur peut être fixé.
