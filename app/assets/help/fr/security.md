# Sécurité

## Double authentification

Activez-la : en plus du mot de passe, un code à 6 chiffres donné par une application d'authentification (Aegis, Google Authenticator, 1Password…) est demandé à la connexion.

1. Scannez le QR code avec l'application.
2. Saisissez le code affiché pour confirmer.
3. **Gardez les codes de secours** dans un endroit sûr : ils servent si vous perdez votre téléphone. Chacun ne sert qu'une fois.

## Verrouillage automatique

Désactivé au départ : activez-le dans **Sécurité**. Après un temps sans utilisation (15 minutes par défaut, ou 5, 30, 60), l'application se verrouille : l'écran est masqué, mais la session reste ouverte et ce qui était en cours continue.

- **Déverrouiller** : votre mot de passe, ou sur Android l'empreinte (ou le code du téléphone), sur Windows Windows Hello, si vous l'avez choisi. Il est proposé après le premier déverrouillage par mot de passe.
- **Verrouiller maintenant** : bouton dans le menu, pour partir tout de suite.
- Après **5 mots de passe erronés** ou **8 heures** de verrouillage, l'application se déconnecte : reconnectez-vous avec mot de passe et double authentification.
- Version autonome : seul le verrouillage de l'appareil la déverrouille ; il faut donc qu'un code ou une empreinte soit configuré sur l'appareil.
- **Masquer l'écran hors du premier plan** (option) : cache le contenu dans la liste des applications ouvertes ; sur Android, bloque aussi les captures d'écran.

Les réglages valent pour cet appareil seulement. Sans utilisation pendant 30 jours, un appareil doit se reconnecter.

## Mes sessions
Chaque appareil ou navigateur où vous êtes connecté : application Android, Windows ou navigateur, sa version, l'adresse IP, la ville et le pays approximatifs, depuis quand et la dernière activité.
- **Fermer** une session que vous ne reconnaissez pas : l'appareil est déconnecté dans les 30 secondes. Changez ensuite votre mot de passe.
- **Fermer toutes les autres** : seul cet appareil reste connecté.
- **Renommer** un appareil (« Téléphone de Léa ») pour le reconnaître.
- Ces informations sont gardées 30 jours après la fin de la session, puis effacées ; elles font partie de votre export. L'administrateur du serveur voit vos sessions avec l'adresse IP masquée et peut les fermer ; vous en êtes prévenu par une notification.
- Le lieu vient d'une base installée sur le serveur (IP Geolocation by DB-IP) : aucun service extérieur n'est interrogé. Il est indicatif — derrière un opérateur mobile ou un VPN, la ville est souvent fausse.
- Version autonome : un seul appareil, rien n'est affiché.

### Alertes de connexion

Vos autres appareils reçoivent une notification quand une session s'ouvre :
- sur un **nouvel appareil** : une plateforme (application Android, Windows, navigateur) jamais vue pour vous dans cette ville ;
- depuis un **pays inhabituel** : un pays jamais vu pour vous, alerte mise en évidence (aussi quand une session déjà ouverte y change d'adresse).

La notification demande « C'est vous ? ». **Oui** ne fait rien de plus. **Non, déconnecter** ferme cette session, puis propose de changer votre mot de passe (toutes vos sessions sont alors fermées). Elle signale aussi une adresse IP déjà bloquée pour des essais de mot de passe ratés.

## Ce que fait OwnCoffer pour vous

- Une adresse IP qui échoue trop souvent à se connecter est **bloquée automatiquement**.
- Chaque demande vérifie votre foyer, votre rôle et les comptes que vous pouvez voir.
- Les actions sensibles sont notées dans un journal.

## Bonnes habitudes

- Un mot de passe que vous n'utilisez nulle part ailleurs.
- Se déconnecter sur un appareil partagé.
