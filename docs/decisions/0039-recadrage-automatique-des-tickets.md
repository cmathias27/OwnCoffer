# 0039 — Recadrage automatique des tickets, sur l'appareil

**Statut**: Décidé (12 novembre 2026), mis en œuvre en 1.24.0. Remplace le dernier point de la décision 0023 (« scanner de documents du système sur Android »).

## Contexte

Depuis la 0.3.15, une photo de facture ou de ticket passe par un écran de recadrage: le papier est cherché, l'utilisateur place les quatre coins, puis la photo est redressée et rendue plus lisible. Le ROADBOOK demande que ce recadrage devienne automatique: bords trouvés seuls, perspective redressée, contraste amélioré, et une photo nette.

La décision 0023 prévoyait le scanner de documents du système sur Android. Sur Android, ce scanner est celui de Google Play Services (ML Kit Document Scanner). Il pose les mêmes problèmes que ML Kit, déjà écarté par 0023: code propriétaire, mesures d'usage envoyées à Google, et absent des téléphones sans services Google. Il ne couvre pas non plus Windows ni le web.

## Décision

1. **Tout en Dart pur, sur l'appareil**, dans `shared/lib/src/documents/scan.dart`, pour les trois cibles. Aucune dépendance nouvelle et aucun appel réseau.
2. **Bords plus sûrs** (`findDocument`):
   - L'image réduite à 400 px est légèrement lissée, pour que l'impression ne coupe pas le papier en morceaux.
   - Le papier est séparé du fond par sa clarté (seuil d'Otsu). La plus grande région claire est gardée, de préférence une qui ne longe pas presque tout le cadre (une table claire, par exemple).
   - Les coins sont ceux du **plus grand quadrilatère inscrit dans le contour convexe** de cette région, calculé en O(n²). Avant, les coins étaient pris sur les diagonales: un ticket tourné d'environ 45° était manqué.
3. **Assurance.** Le papier est « trouvé à coup sûr » quand toutes ces conditions sont remplies:
   - il ne touche pas le bord de la photo;
   - il est nettement plus clair que ce qui l'entoure (au moins 40 niveaux sur 255);
   - il remplit son quadrilatère (90 à 110 %);
   - ce quadrilatère couvre au moins 95 % du contour convexe, donc la forme a bien quatre côtés;
   - chaque angle est compris entre 40° et 140°.
4. **Quand le papier est trouvé à coup sûr**, l'écran montre directement le ticket redressé et rendu lisible, avec « Garder » et « Ajuster les coins ». Sinon, l'écran des quatre coins s'ouvre comme avant, déjà placés au mieux. « Garder telle quelle » reste toujours possible.
5. **Netteté** (`blurLevel`):
   - Mesure sans référence de Crété-Roffet et al. (2007), faite dans le papier, sur une copie de 1600 px. L'image est floutée une seconde fois et on mesure la variation perdue entre pixels voisins. Les écarts de moins de 4 niveaux (bruit du capteur) sont ignorés.
   - Au-dessus de 0,5, l'écran prévient: « La photo semble floue: le texte risque d'être illisible ». Quand la photo vient de l'appareil photo, il propose « Reprendre la photo ».
   - C'est un avertissement, pas un blocage: un ticket un peu flou reste mieux que pas de ticket.
6. **Contraste** (`enhanceDocument`):
   - Avant l'étirement des niveaux, l'éclairage est égalisé. Chaque pixel est divisé par la couleur du papier autour de lui, estimée par le plus clair de cases d'environ 1/24 de l'image, puis de leurs voisines. Ainsi un grand logo n'est pas pris pour du papier.
   - L'ombre du téléphone ou une lumière venant d'un seul côté ne noircissent plus une moitié du ticket, et l'impression thermique pâlie redevient foncée.
7. **Pas de déclenchement automatique pendant la visée.** Il faudrait un flux vidéo, donc le paquet `camera` et un écran de visée propre à chaque plateforme. L'appareil photo du système prend la photo, et la netteté est vérifiée juste après. Ce déclenchement pourra venir dans une autre décision si l'usage le demande.

## Conséquences

- Les calculs lourds (analyse, redressement) tournent hors du fil de l'écran dans les applications (`compute`). Sur le web, ils restent sur le même fil, avec un indicateur d'attente.
- Mêmes fichiers produits qu'avant (PNG dans les applications, JPEG sur le web). La lecture du ticket (0036) suit sans changement.
- Tests:
  - `shared/test/scan_test.dart`: feuille droite; ticket tourné de 40°; impression sur le ticket; ticket coupé par le cadre (non sûr); contraste trop faible (non sûr); tache ronde (non sûre); netteté nette, floue, mesurée seulement dans les coins, feuille blanche (indéterminée); ombre égalisée; impression thermique pâlie.
  - `app/test/invoice_scan_test.dart`: ticket redressé tout de suite puis coins ajustables; photo floue signalée puis reprise; pas de reprise sans appareil photo.
