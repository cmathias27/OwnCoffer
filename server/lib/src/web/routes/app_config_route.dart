import 'package:serverpod/serverpod.dart';

class AppConfigWidget extends JsonWidget {
  final String apiUrl;

  AppConfigWidget({
    required this.apiUrl,
  }) : super(object: {'apiUrl': apiUrl});
}

class AppConfigRoute extends WidgetRoute {
  AppConfigWidget widget;

  /// [sameOriginPath], when set (e.g. `/api/`), is sent as a relative URL that
  /// the web app resolves against its own origin.
  AppConfigRoute({
    required final ServerConfig apiConfig,
    final String? sameOriginPath,
  }) : widget = AppConfigWidget(
         apiUrl: (sameOriginPath != null && sameOriginPath.isNotEmpty)
             ? sameOriginPath
             : apiConfig.apiUrl.toString(),
       );

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return widget;
  }
}

extension on ServerConfig {
  Uri get apiUrl => Uri(
    scheme: publicScheme,
    host: publicHost,
    port: publicPort,
  );
}
