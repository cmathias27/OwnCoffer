# Questions fréquentes

Pour installer le serveur : [INSTALLATION.md](INSTALLATION.md). Pour se servir de l'application : [UTILISATION.md](UTILISATION.md) et le bouton **?** de chaque page.

## Généralités

**OwnCoffer se connecte-t-il à ma banque ?**
Non, jamais. Vous téléchargez vous-même vos relevés (OFX, QIF ou CSV) sur le site de votre banque et vous les importez. OwnCoffer ne connaît ni vos identifiants bancaires ni votre numéro de compte : il n'en garde qu'une empreinte, pour reconnaître le compte d'un relevé OFX.

**Mes données partent-elles quelque part ?**
Non. Tout reste sur votre serveur. Il n'y a aucune télémétrie. Sortent seulement, et seulement si vous le demandez : les courriels (si l'envoi est réglé), une recherche Google d'un libellé nettoyé, et les questions posées à l'assistant IA si vous l'activez avec un fournisseur en ligne (signalé à chaque réponse).

**Est-ce gratuit ? Pourquoi ?**
Oui, et libre (licence AGPL-3.0) : sans publicité, sans abonnement, sans revente de données. Le projet vit des dons.

**Quelles banques ?**
Les relevés de la **Caisse d'Épargne** sont reconnus en premier (décision 0003). Les fichiers OFX et QIF des autres banques s'importent en général sans souci ; pour un CSV inconnu, l'import vous demande quelle colonne contient quoi.

**Faut-il l'IA ?**
Non. Tout fonctionne sans IA : import, classement, prévisions, budget, crédits, analyses, conseiller. L'IA est une option, avec le fournisseur que l'administrateur choisit (un modèle local comme Ollama, ou un service en ligne). Elle propose, vous validez ; elle ne calcule jamais un montant et ne modifie rien seule.

## Import et classement

**J'ai importé deux fois le même relevé : vais-je avoir des doublons ?**
Non. Chaque opération a une empreinte ; celles déjà présentes sont reconnues et écartées. Les doublons *possibles* (même date, même montant, libellé proche) sont laissés de côté et signalés dans l'aperçu.

**Pourquoi une opération n'est-elle pas classée ?**
Aucune règle (de votre foyer ou commune) ni votre historique ne la reconnaît. Classez-la une fois et cochez « Toujours classer ainsi » : les suivantes le seront.

**J'ai annulé un import par erreur.**
Les opérations vont à la corbeille (page Opérations, « Corbeille ») : restaurez-les, ou réimportez le relevé.

## Prévisions et budget

**Le solde prévu est faux.**
Vérifiez que le solde de départ du compte est juste (« Vérifier le solde » compare avec le solde affiché par la banque), et que vos opérations qui reviennent (salaire, loyer, abonnements, crédits) sont déclarées. Les dépenses variables (courses…) peuvent être estimées à partir de vos derniers mois.

**Qu'est-ce que le « reste à vivre » ?**
Ce qu'il vous reste à dépenser jusqu'à la prochaine paie, une fois payées les opérations prévues d'ici là.

## Sauvegardes et données

**Mes données sont-elles sauvegardées ?**
Si l'administrateur a installé les mises à jour automatiques (`docker/install-auto-update.sh`), oui : chaque nuit et avant chaque mise à jour, **chiffrées**. Chaque nuit, la dernière sauvegarde est aussi **restaurée dans une base d'essai** pour vérifier qu'elle est bonne. L'onglet Sauvegardes de l'administration montre le résultat.

**Où est la clé des sauvegardes ? Que se passe-t-il si je la perds ?**
Dans `docker/backup.key`, sur le serveur, lisible par root seulement. **Gardez-en une copie ailleurs** (gestionnaire de mots de passe). Sans elle, les sauvegardes chiffrées ne peuvent pas être relues : personne ne peut les déchiffrer, pas même le projet. Tant que le serveur fonctionne, rien n'est perdu ; en cas de panne du disque, c'est la copie de la clé qui permet de restaurer.

**Comment récupérer toutes mes données ?**
Menu du compte → **« Exporter mes données »** : un fichier JSON complet (comptes, opérations, catégories, règles, objectifs, crédits…, montants en centimes) ou vos opérations en CSV pour LibreOffice Calc ou Excel. Vous n'obtenez que ce que vous pouvez voir dans le groupe ; chaque export est noté dans le journal du groupe.

**L'export remplace-t-il les sauvegardes ?**
Non. L'export sert à garder une archive ou à changer de logiciel. Seule une sauvegarde du serveur permet de tout restaurer (utilisateurs, double authentification, factures…).

## Applications

**Y a-t-il une application pour téléphone ?**
Oui, de deux façons : l'application web s'installe depuis le navigateur (« Ajouter à l'écran d'accueil »), et une application **Android** (fichier APK) est jointe à chaque version, comme une application **Windows**. Voir [APPLICATIONS.md](APPLICATIONS.md).

**Windows ou Android me disent que l'application n'est pas sûre.**
Elles ne sont pas encore signées par un éditeur reconnu (certificat payant) ni publiées sur un magasin. Téléchargez-les uniquement depuis la page des versions du dépôt, et vérifiez leur empreinte et leur signature ([PUBLICATION.md](PUBLICATION.md)).

**L'application fonctionne-t-elle sans connexion ?**
Pas encore : elle lit tout sur votre serveur. Le mode hors-ligne est prévu en phase 6.

## Sécurité

**Qui peut voir mes comptes ?**
Les membres de votre groupe, selon leur rôle (lecteur, utilisateur, administrateur). Un compte **restreint** n'est visible que de ses titulaires et des administrateurs du groupe. Le serveur vérifie ces droits à chaque requête ; chaque fonction a un test qui vérifie qu'un membre d'un autre groupe est refusé.

**Comment protéger mon compte ?**
Activez la **double authentification** (Sécurité) et gardez vos codes de secours. Après 5 échecs de connexion en 15 minutes, l'adresse IP est bloquée une heure.

**J'ai trouvé une faille.**
Ne la publiez pas : suivez [SECURITY.md](../SECURITY.md).

## Mises à jour

**Comment mettre à jour ?**
Avec les mises à jour automatiques, rien à faire : le serveur installe chaque version publiée, après une sauvegarde, et revient en arrière si elle ne démarre pas. Sinon, voir « Mettre à jour » dans [INSTALLATION.md](INSTALLATION.md).

**Comment savoir ce qui a changé ?**
[CHANGELOG.md](../CHANGELOG.md), et l'onglet Mises à jour de l'administration.
