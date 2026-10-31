import 'package:web/web.dart' as web;

void openInNewTab(Uri uri) =>
    web.window.open(uri.toString(), '_blank', 'noopener,noreferrer');
