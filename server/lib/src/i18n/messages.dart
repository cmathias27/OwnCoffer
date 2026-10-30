/// Server-side texts (emails). The app has its own translation files; these
/// are the only user-facing texts produced by the server. Every email is
/// sent in French then English, as the recipient's language is unknown.
abstract final class Messages {
  static const fr = <String, String>{
    'registration.subject': 'OwnCoffer — votre code de vérification',
    'registration.body':
        'Votre code pour créer votre compte OwnCoffer : {code}\n'
        'Il est valable 15 minutes. Si vous n\'avez rien demandé, ignorez ce message.',
    'reset.subject': 'OwnCoffer — réinitialisation du mot de passe',
    'reset.body':
        'Votre code pour choisir un nouveau mot de passe : {code}\n'
        'Il est valable 15 minutes. Si vous n\'avez rien demandé, ignorez ce message.',
    'invitation.subject': 'OwnCoffer — invitation à rejoindre « {group} »',
    'invitation.body':
        'Vous êtes invité à rejoindre le groupe « {group} » sur OwnCoffer.\n'
        'Ouvrez ce lien avant le {expires} : {link}',
  };

  static const en = <String, String>{
    'registration.subject': 'OwnCoffer — your verification code',
    'registration.body':
        'Your code to create your OwnCoffer account: {code}\n'
        'It is valid for 15 minutes. If you did not ask for it, ignore this message.',
    'reset.subject': 'OwnCoffer — password reset',
    'reset.body':
        'Your code to choose a new password: {code}\n'
        'It is valid for 15 minutes. If you did not ask for it, ignore this message.',
    'invitation.subject': 'OwnCoffer — invitation to join "{group}"',
    'invitation.body':
        'You are invited to join the group "{group}" on OwnCoffer.\n'
        'Open this link before {expires}: {link}',
  };

  static String _fill(String text, Map<String, String> values) {
    var s = text;
    values.forEach((k, v) => s = s.replaceAll('{$k}', v));
    return s;
  }

  /// Bilingual subject and body for [key].
  static ({String subject, String body}) bilingual(
    String key,
    Map<String, String> values,
  ) => (
    subject: _fill(fr['$key.subject']!, values),
    body:
        '${_fill(fr['$key.body']!, values)}\n\n---\n\n'
        '${_fill(en['$key.body']!, values)}',
  );
}
