import 'dart:convert';
import 'dart:io';

/// One call to a chat model: the messages so far (OpenAI format) and the
/// functions it may call. Returns the assistant message (OpenAI format):
/// `content` and/or `tool_calls`.
abstract interface class AiAdapter {
  Future<Map<String, Object?>> chat({
    required String baseUrl,
    required String? apiKey,
    required String model,
    required List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  });

  /// The models the provider offers (to test a provider's set-up).
  Future<List<String>> models({required String baseUrl, String? apiKey});
}

/// Thrown when the provider cannot be reached or refuses the request; the
/// app says so plainly, never switching to another provider (0008).
class AiUnavailable implements Exception {
  final String reason;
  const AiUnavailable(this.reason);

  @override
  String toString() => 'AiUnavailable: $reason';
}

/// Any API compatible with OpenAI's chat completions: OpenAI, Mistral,
/// OpenRouter… and Ollama (`http://host:11434/v1`), which speaks the same.
class OpenAiCompatibleAdapter implements AiAdapter {
  static const _timeout = Duration(seconds: 120);

  Uri _uri(String baseUrl, String path) {
    final base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    return Uri.parse(base).resolve(path);
  }

  Future<Map<String, Object?>> _send(
    String method,
    Uri uri,
    String? apiKey, [
    Object? body,
  ]) async {
    final http = HttpClient()..connectionTimeout = const Duration(seconds: 15);
    try {
      final req = await http.openUrl(method, uri).timeout(_timeout);
      req.headers.contentType = ContentType.json;
      if (apiKey != null && apiKey.isNotEmpty) {
        req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $apiKey');
      }
      if (body != null) req.write(jsonEncode(body));
      final res = await req.close().timeout(_timeout);
      final text = await res.transform(utf8.decoder).join().timeout(_timeout);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        // The provider's own message, without echoing the request.
        throw AiUnavailable('HTTP ${res.statusCode}');
      }
      final json = jsonDecode(text);
      if (json is! Map<String, Object?>) {
        throw const AiUnavailable('unexpected answer');
      }
      return json;
    } on AiUnavailable {
      rethrow;
    } on Object catch (e) {
      throw AiUnavailable(e.runtimeType.toString());
    } finally {
      http.close(force: true);
    }
  }

  @override
  Future<Map<String, Object?>> chat({
    required String baseUrl,
    required String? apiKey,
    required String model,
    required List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  }) async {
    final json = await _send(
      'POST',
      _uri(baseUrl, 'chat/completions'),
      apiKey,
      {
        'model': model,
        'messages': messages,
        if (tools != null && tools.isNotEmpty) 'tools': tools,
        'temperature': 0.2,
      },
    );
    final choices = json['choices'];
    if (choices is! List || choices.isEmpty) {
      throw const AiUnavailable('no answer');
    }
    final message = (choices.first as Map)['message'];
    if (message is! Map<String, Object?>) {
      throw const AiUnavailable('no answer');
    }
    return message;
  }

  @override
  Future<List<String>> models({required String baseUrl, String? apiKey}) async {
    final json = await _send('GET', _uri(baseUrl, 'models'), apiKey);
    final data = json['data'];
    if (data is! List) return const [];
    return [
      for (final m in data)
        if (m is Map && m['id'] is String) m['id'] as String,
    ]..sort();
  }
}
