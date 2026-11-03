# 0023 — Lecture du texte des tickets sur l'appareil

**Statut** : Proposée (3 novembre 2026), à valider avant le scan automatique des tickets (ROADBOOK, phase 6)

## Contexte

Le scan des tickets doit lire le texte d'une photo **sur l'appareil**, sans IA et hors ligne, donc aussi dans la version autonome (décision 0022). Contraintes du projet : licence compatible AGPL-3.0, aucune télémétrie, aucun appel réseau non demandé, trois cibles (web, Android, Windows).

Aucune bibliothèque unique ne couvre les trois (vérifié sur pub.dev et npm le 3 novembre 2026) :

| Cible | Candidat | Licence | Remarques |
| --- | --- | --- | --- |
| Android | `flutter_tesseract_ocr` (Tesseract 4 via Tesseract4Android) | Apache-2.0 (Tesseract) | Android, iOS et web ; **pas Windows** |
| Web | `tesseract.js` (WebAssembly) | Apache-2.0 | Fonctionne hors ligne si le worker, le cœur `.wasm` et les données de langue sont servis par nous (par défaut, le cœur vient d'un CDN) |
| Windows | `platform_ocr` (Windows.Media.Ocr du système) | à vérifier | Windows seulement ; moteur fourni par Windows, rien à distribuer |

Écarté : **Google ML Kit** (Android), SDK propriétaire dont les services Google collectent des mesures d'usage — incompatible avec « aucune télémétrie » (à confirmer par la lecture de ses conditions si le choix était rouvert).

## Décision

1. **Une interface unique `TextReader`** dans `app/lib/util/` (versions `_web`, `_io`, comme le reste du code propre à une plateforme) : elle reçoit une image, rend des lignes de texte avec leur position et une confiance. Rien d'autre ne dépend du moteur choisi.
2. **Un moteur par cible**, tous locaux : Tesseract sur Android, `tesseract.js` auto-hébergé sur le web (worker, `.wasm` et données de langue servis par le serveur OwnCoffer lui-même, chargés à la demande), Windows.Media.Ocr sur Windows (repli : Tesseract en FFI si la licence ou la qualité ne conviennent pas).
3. **Données de langue** `fra` et `eng` (modèles « fast » de Tesseract, Apache-2.0) embarquées dans l'application et servies par notre serveur ; jamais téléchargées d'un tiers.
4. **Le texte brut n'est qu'une matière première.** L'extraction du montant, de la date, du commerçant et de la TVA est faite par le moteur déterministe en Dart pur (`shared/`, testé sur des tickets factices), qui signale chaque champ incertain. Avec l'IA configurée, la lecture structurée par la passerelle (décision 0008) passe par le circuit des propositions (0009) ; sans IA, tout marche quand même (0006).
5. **Rien n'est enregistré sans validation** : l'écran de vérification montre la photo, les champs lus et ceux qui sont douteux.

## Conséquences

- Trois intégrations à maintenir derrière une seule interface ; la CI teste l'extraction sur du texte, pas le moteur de reconnaissance.
- Poids : les modèles de langue et le `.wasm` ajoutent quelques dizaines de Mo au total ; le web les charge seulement au premier scan.
- **Points à vérifier avant d'écrire du code** : licence exacte de chaque paquet Dart au moment de l'ajout (règle du CLAUDE.md), qualité réelle sur des tickets thermiques faux, taille ajoutée à l'APK et au zip Windows, comportement d'`image_picker` quand le recadrage automatique sera ajouté.
- Le recadrage automatique (bords, perspective, netteté) est une décision à part : scanner de documents du système sur Android, quatre coins à placer sur le web.
