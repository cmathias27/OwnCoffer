import 'package:url_launcher/url_launcher.dart';

/// The system browser, outside the app.
void openInNewTab(Uri uri) {
  launchUrl(uri, mode: LaunchMode.externalApplication);
}
