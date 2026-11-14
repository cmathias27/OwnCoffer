# 0048 — Coût et volume de l'IA par fonction

**Statut**: Décidé (14 novembre 2026), mis en œuvre en 1.33.0. Complète les décisions 0008 et 0017.

## Contexte

Le seul repère d'usage de l'IA est un nombre de demandes par utilisateur et par mois, comparé au plafond du fournisseur (décision 0017). Une demande n'a pourtant pas le même poids selon la fonction: une question courte au conseiller coûte peu, la lecture d'un tableau d'amortissement de douze pages coûte beaucoup plus. Ni l'utilisateur ni l'administrateur du serveur ne savent ce que coûte l'IA, ni quelle fonction en consomme le plus.

## Décision

1. **Trois fonctions comptées à part.**
   - **Discussion**: l'assistant et Mon conseiller, y compris les catégories et règles proposées dans la conversation (le classement par l'IA passe par elle).
   - **Tickets et factures**: lecture d'un ticket ou d'une facture, jointe ou à rattacher.
   - **Documents de crédit**: offre de prêt et tableau d'amortissement.

   Pour chaque utilisateur, fournisseur, mois et fonction, le serveur garde le nombre de demandes et les **jetons envoyés et reçus**, tels que le fournisseur les annonce dans sa réponse (`usage` d'OpenAI et des API compatibles, Gemini et Ollama compris; `usage` de Claude). Un fournisseur qui ne les annonce pas compte zéro jeton, et l'application l'affiche comme « non communiqué ». Rien du contenu n'est gardé, comme avant.
2. **Prix saisis par l'administrateur du serveur.** Chaque fournisseur reçoit deux prix facultatifs: le prix d'un million de jetons envoyés et celui d'un million de jetons reçus, dans la monnaie de sa facture. Ils sont gardés en entiers, en centièmes de centime (0,075 € le million = 750), pour les modèles bon marché. Sans prix, aucun coût n'est affiché; un fournisseur local (Ollama) n'en a généralement pas.
3. **Coût calculé par le serveur.** Coût en centimes = (jetons envoyés × prix envoyé + jetons reçus × prix reçu) ÷ 100 000 000, arrondi une seule fois au centime le plus proche, en entiers. Le calcul porte sur les totaux du mois, pas demande par demande, pour ne pas cumuler les arrondis. Un prix manquant compte comme inconnu: pas de coût affiché pour ce fournisseur. Il est indicatif: il suit les prix saisis, pas la facture réelle du fournisseur.
4. **Ce que voit l'utilisateur.** Page Assistant: sa consommation du mois et du mois précédent, par fonction (demandes, jetons, coût estimé quand le prix est connu), en plus du compteur du plafond.
5. **Ce que voit l'administrateur du serveur.** Administration, onglet IA: la consommation de tout le serveur par fournisseur et par fonction, sur les six derniers mois, avec le nombre d'utilisateurs qui s'en sont servis. Jamais le détail d'un utilisateur nommé.
6. **Le plafond reste en demandes.** Il ne change pas: le coût est un repère, pas une limite. Un plafond en euros pourra venir plus tard, si l'usage le demande.

## Conséquences

- Nouvelle table `ai_function_usage`; deux colonnes facultatives dans `ai_providers` (`inputPricePerMillion`, `outputPricePerMillion`). Migration PostgreSQL et SQLite.
- Les adaptateurs renvoient les jetons de chaque réponse dans une clé `_usage`, jamais transmise à un fournisseur.
- Points d'accès `ai.usage` (l'utilisateur, ses propres chiffres seulement) et `ai.serverUsage` (administrateur du serveur seulement), avec tests d'isolation.
- Le calcul du coût (`aiCostCents`) est testé à part, arrondis compris.
