import 'page_reload/page_reload_stub.dart'
    if (dart.library.js_interop) 'page_reload/page_reload_web.dart'
    if (dart.library.io) 'page_reload/page_reload_io.dart'
    as impl;

/// Loads the page again, e.g. to get the application of a new version.
void reloadPage() => impl.reloadPage();
