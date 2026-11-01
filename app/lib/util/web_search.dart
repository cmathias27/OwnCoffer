import 'web_search/web_search_stub.dart'
    if (dart.library.js_interop) 'web_search/web_search_web.dart'
    if (dart.library.io) 'web_search/web_search_io.dart'
    as impl;

/// Google search for an operation label the user does not recognise. Only
/// the cleaned label is sent (never the raw bank label, which may hold a
/// name or a reference), and only when the user asks.
Uri webSearchUri(String cleanLabel) => Uri.https('www.google.com', '/search', {
  'q': cleanLabel.trim(),
});

/// Opens the search in a new tab, without telling Google where it comes from.
void openWebSearch(String cleanLabel) =>
    impl.openInNewTab(webSearchUri(cleanLabel));

/// Opens [uri] outside the app (new tab, or the system browser), only when
/// the user asks: the downloads of the Windows and Android apps.
void openLink(Uri uri) => impl.openInNewTab(uri);
