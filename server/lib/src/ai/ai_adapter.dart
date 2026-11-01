import 'dart:convert';
import 'dart:io';

/// One call to a chat model: the messages so far (OpenAI format) and the
/// functions it may call. Returns the assistant message (OpenAI format):
/// `content` and/or `tool_calls`. Keys starting with `_` carry what an
/// adapter needs back on the next round (never sent to another provider).
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

/// HTTP shared by the adapters: JSON in and out, the provider's own error
/// message kept (short), never the request (it may hold the key).
abstract base class _JsonHttp {
  static const _timeout = Duration(seconds: 180);

  Uri uri(String baseUrl, String path) {
    final base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    return Uri.parse(base).resolve(path);
  }

  Future<Map<String, Object?>> send(
    String method,
    Uri uri,
    Map<String, String> headers, [
    Object? body,
  ]) async {
    final http = HttpClient()..connectionTimeout = const Duration(seconds: 15);
    try {
      final req = await http.openUrl(method, uri).timeout(_timeout);
      req.headers.contentType = ContentType.json;
      headers.forEach(req.headers.set);
      if (body != null) req.write(jsonEncode(body));
      final res = await req.close().timeout(_timeout);
      final text = await res.transform(utf8.decoder).join().timeout(_timeout);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        final why = providerError(text);
        throw AiUnavailable(
          why == null
              ? 'HTTP ${res.statusCode}'
              : 'HTTP ${res.statusCode}: $why',
        );
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
}

/// The message of a provider's error answer (OpenAI, Gemini and Claude all
/// use `{"error": {"message": …}}`; Gemini sometimes a list of them), at
/// most 200 characters.
String? providerError(String body) {
  Object? json;
  try {
    json = jsonDecode(body);
  } on FormatException {
    return null;
  }
  if (json is List && json.isNotEmpty) json = json.first;
  final error = json is Map ? json['error'] : null;
  final message = error is Map ? error['message'] : error;
  if (message is! String || message.trim().isEmpty) return null;
  final m = message.trim().replaceAll(RegExp(r'\s+'), ' ');
  return m.length > 200 ? '${m.substring(0, 200)}…' : m;
}

/// Model ids as users pick them: Gemini lists `models/gemini-…`, and the big
/// catalogues hold models that cannot chat (embeddings, images, speech…).
List<String> chatModelIds(Iterable<String> ids) {
  const notChat = [
    'embed',
    'tts',
    'whisper',
    'dall-e',
    'image',
    'imagen',
    'veo',
    'audio',
    'realtime',
    'moderation',
    'transcribe',
    'aqa',
    'babbage',
    'davinci',
  ];
  return {
    for (final id in ids)
      if (!notChat.any(id.toLowerCase().contains))
        id.startsWith('models/') ? id.substring('models/'.length) : id,
  }.toList()..sort();
}

/// The usual chat models among [ids] (chatModelIds first): without
/// previews, experiments, dated snapshots or specialised variants, newest
/// first, at most [max]. A local server (Ollama) keeps all its models: the
/// administrator installed them on purpose.
List<String> commonModelIds(Iterable<String> ids, {int max = 12}) {
  const special = [
    'preview',
    'exp',
    'live',
    'search',
    'instruct',
    'computer-use',
    'codex',
    'nano-banana',
    'robotics',
    'learnlm',
    'gemma',
  ];
  final dated = RegExp(r'-(\d{4}-\d{2}-\d{2}|\d{8}|\d{3,4})$');
  final kept = [
    for (final id in chatModelIds(ids))
      if (!special.any(id.toLowerCase().contains) && !dated.hasMatch(id)) id,
  ];
  // Newest first: the version numbers in the name, compared as numbers.
  List<int> version(String id) => [
    for (final m in RegExp(r'\d+').allMatches(id)) int.parse(m[0]!),
  ];
  int compare(String a, String b) {
    final va = version(a), vb = version(b);
    for (var i = 0; i < va.length && i < vb.length; i++) {
      if (va[i] != vb[i]) return vb[i].compareTo(va[i]);
    }
    if (va.length != vb.length) return vb.length.compareTo(va.length);
    return a.compareTo(b);
  }

  kept.sort(compare);
  return kept.take(max).toList();
}

/// Any API compatible with OpenAI's chat completions: OpenAI (ChatGPT),
/// Google Gemini (`…/v1beta/openai/`), Mistral, OpenRouter… and Ollama
/// (`http://host:11434/v1`), which speaks the same.
final class OpenAiCompatibleAdapter extends _JsonHttp implements AiAdapter {
  Map<String, String> _auth(String? apiKey) => {
    if (apiKey != null && apiKey.isNotEmpty)
      HttpHeaders.authorizationHeader: 'Bearer $apiKey',
  };

  /// Tools as every compatible API accepts them: Gemini refuses an object
  /// schema without properties, so a function without parameters has none.
  static List<Map<String, Object?>> wireTools(
    List<Map<String, Object?>> tools,
  ) => [
    for (final t in tools)
      () {
        final f = Map<String, Object?>.of(
          t['function']! as Map<String, Object?>,
        );
        final params = f['parameters'];
        if (params is Map) {
          final props = params['properties'];
          if (props is! Map || props.isEmpty) {
            f.remove('parameters');
          } else if (params['required'] case final List r when r.isEmpty) {
            f['parameters'] = Map.of(params)..remove('required');
          }
        }
        return {...t, 'function': f};
      }(),
  ];

  /// Messages without what only another adapter needs.
  static List<Map<String, Object?>> wireMessages(
    List<Map<String, Object?>> messages,
  ) => [
    for (final m in messages)
      {
        for (final e in m.entries)
          if (!e.key.startsWith('_')) e.key: e.value,
      },
  ];

  @override
  Future<Map<String, Object?>> chat({
    required String baseUrl,
    required String? apiKey,
    required String model,
    required List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  }) async {
    final json = await send(
      'POST',
      uri(baseUrl, 'chat/completions'),
      _auth(apiKey),
      {
        'model': model,
        'messages': wireMessages(messages),
        if (tools != null && tools.isNotEmpty) 'tools': wireTools(tools),
        // No temperature: recent models (OpenAI's reasoning models, Gemini 3)
        // refuse or advise against anything but their default.
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
    final json = await send('GET', uri(baseUrl, 'models'), _auth(apiKey));
    final data = json['data'];
    if (data is! List) return const [];
    return chatModelIds([
      for (final m in data)
        if (m is Map && m['id'] is String) m['id'] as String,
    ]);
  }
}

/// Claude, by Anthropic's own Messages API (`https://api.anthropic.com/v1`):
/// there is no official Dart SDK, so plain HTTP. The conversation is kept
/// in OpenAI's format by the gateway and translated here both ways; Claude's
/// own answer blocks are kept to be sent back unchanged on the next round.
/// No automatic fallback to another model (décision 0008).
final class AnthropicAdapter extends _JsonHttp implements AiAdapter {
  static const version = '2026-10-21';
  static const _maxTokens = 16000;

  Map<String, String> _headers(String? apiKey) => {
    'anthropic-version': version,
    if (apiKey != null && apiKey.isNotEmpty) 'x-api-key': apiKey,
  };

  /// The request body for [messages] (OpenAI format) and [tools].
  static Map<String, Object?> request(
    String model,
    List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  ) {
    final system = <String>[];
    final out = <Map<String, Object?>>[];
    void add(String role, List<Map<String, Object?>> blocks) {
      if (blocks.isEmpty) return;
      if (out.isNotEmpty && out.last['role'] == role) {
        (out.last['content']! as List).addAll(blocks);
      } else {
        out.add({
          'role': role,
          'content': [...blocks],
        });
      }
    }

    for (final m in messages) {
      switch (m['role']) {
        case 'system':
          if (m['content'] case final String s) system.add(s);
        case 'assistant':
          final kept = m['_anthropic_content'];
          if (kept is List) {
            add('assistant', [for (final b in kept) (b as Map).cast()]);
            continue;
          }
          add('assistant', [
            if (m['content'] case final String s when s.isNotEmpty)
              {'type': 'text', 'text': s},
            for (final c in (m['tool_calls'] as List?) ?? const [])
              {
                'type': 'tool_use',
                'id': c['id'],
                'name': c['function']['name'],
                'input': _arguments(c['function']['arguments']),
              },
          ]);
        case 'tool':
          add('user', [
            {
              'type': 'tool_result',
              'tool_use_id': m['tool_call_id'],
              'content': '${m['content'] ?? ''}',
            },
          ]);
        default:
          add('user', _userBlocks(m['content']));
      }
    }
    return {
      'model': model,
      'max_tokens': _maxTokens,
      if (system.isNotEmpty) 'system': system.join('\n\n'),
      'messages': out,
      if (tools != null && tools.isNotEmpty)
        'tools': [
          for (final t in tools)
            {
              'name': (t['function'] as Map)['name'],
              'description': (t['function'] as Map)['description'],
              'input_schema':
                  (t['function'] as Map)['parameters'] ??
                  {'type': 'object', 'properties': <String, Object?>{}},
            },
        ],
    };
  }

  static Map<String, Object?> _arguments(Object? raw) {
    try {
      final v = raw is String ? jsonDecode(raw) : raw;
      return v is Map<String, Object?> ? v : {};
    } on FormatException {
      return {};
    }
  }

  static List<Map<String, Object?>> _userBlocks(Object? content) {
    if (content is String) {
      return content.isEmpty
          ? []
          : [
              {'type': 'text', 'text': content},
            ];
    }
    if (content is! List) return [];
    return [
      for (final part in content)
        if (part is Map && part['type'] == 'text')
          {'type': 'text', 'text': part['text']}
        else if (part is Map && part['type'] == 'image_url')
          ?_image('${(part['image_url'] as Map?)?['url'] ?? ''}'),
    ];
  }

  /// A `data:` URL as a base64 image (or PDF document) block.
  static Map<String, Object?>? _image(String url) {
    final m = RegExp(
      r'^data:([^;]+);base64,(.*)$',
      dotAll: true,
    ).firstMatch(url);
    if (m == null) return null;
    return {
      // Claude reads PDF documents as well as images.
      'type': m[1] == 'application/pdf' ? 'document' : 'image',
      'source': {'type': 'base64', 'media_type': m[1], 'data': m[2]},
    };
  }

  /// Claude's answer as an OpenAI assistant message, its blocks kept.
  static Map<String, Object?> answer(Map<String, Object?> json) {
    final content = json['content'];
    final blocks = content is List ? content : const [];
    final text = [
      for (final b in blocks)
        if (b is Map && b['type'] == 'text') '${b['text'] ?? ''}',
    ].join();
    final calls = [
      for (final b in blocks)
        if (b is Map && b['type'] == 'tool_use')
          {
            'id': b['id'],
            'type': 'function',
            'function': {
              'name': b['name'],
              'arguments': jsonEncode(b['input'] ?? const {}),
            },
          },
    ];
    return {
      'role': 'assistant',
      'content': text,
      if (calls.isNotEmpty) 'tool_calls': calls,
      '_anthropic_content': blocks,
    };
  }

  @override
  Future<Map<String, Object?>> chat({
    required String baseUrl,
    required String? apiKey,
    required String model,
    required List<Map<String, Object?>> messages,
    List<Map<String, Object?>>? tools,
  }) async => answer(
    await send(
      'POST',
      uri(baseUrl, 'messages'),
      _headers(apiKey),
      request(model, messages, tools),
    ),
  );

  @override
  Future<List<String>> models({required String baseUrl, String? apiKey}) async {
    final json = await send(
      'GET',
      uri(baseUrl, 'models?limit=1000'),
      _headers(apiKey),
    );
    final data = json['data'];
    if (data is! List) return const [];
    return chatModelIds([
      for (final m in data)
        if (m is Map && m['id'] is String) m['id'] as String,
    ]);
  }
}
