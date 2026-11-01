import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/secret_box.dart';
import 'ai_adapter.dart';
import 'ai_context.dart';

/// The only way to an AI (décision 0008): the user's chosen provider and
/// model, never another one; the monthly cap; the engine's functions as
/// the only access to data (AiContext). Nothing is logged of the
/// conversation itself, only that a request was made.
abstract final class AiGateway {
  /// Set in tests: no network there.
  static AiAdapter? adapter;

  /// Claude by its own API; everything else speaks OpenAI's.
  static AiAdapter adapterFor(AiProvider p) =>
      adapter ??
      (p.kind == 'anthropic' ? AnthropicAdapter() : OpenAiCompatibleAdapter());

  static const _maxRounds = 6;
  static const _maxHistory = 20;
  static const _maxMessage = 4000;

  static SecretBox get _box => SecretBox.derive(
    Serverpod.instance.getPassword('serviceSecret') ??
        (throw StateError('serviceSecret missing: needed for AI keys')),
    'owncoffer-ai-key-v1',
  );

  static String encryptKey(String key) => _box.encrypt(utf8.encode(key));

  static String? _key(AiProvider p) =>
      p.apiKeyBox == null ? null : utf8.decode(_box.decrypt(p.apiKeyBox!));

  /// Whether [baseUrl] points outside this machine and the local network:
  /// then what leaves the server is shown to the user.
  static bool isExternal(String baseUrl) {
    final host = Uri.tryParse(baseUrl)?.host ?? '';
    if (host == 'localhost' || host.endsWith('.local') || !host.contains('.')) {
      return false;
    }
    final parts = host.split('.').map(int.tryParse).toList();
    if (parts.length == 4 && parts.every((p) => p != null)) {
      final [a, b, _, _] = parts.cast<int>();
      return !(a == 10 ||
          a == 127 ||
          (a == 192 && b == 168) ||
          (a == 172 && b >= 16 && b <= 31));
    }
    return true;
  }

  static int _month(DateTime d) => d.year * 100 + d.month;

  static Future<int> usedThisMonth(
    Session session,
    UuidValue user,
    int providerId,
  ) async =>
      (await AiUsage.db.findFirstRow(
        session,
        where: (u) =>
            u.authUserId.equals(user) &
            u.providerId.equals(providerId) &
            u.month.equals(_month(DateTime.now().toUtc())),
      ))?.requests ??
      0;

  static Future<void> _count(Session session, UuidValue user, int id) async {
    final month = _month(DateTime.now().toUtc());
    final row = await AiUsage.db.findFirstRow(
      session,
      where: (u) =>
          u.authUserId.equals(user) &
          u.providerId.equals(id) &
          u.month.equals(month),
    );
    if (row == null) {
      await AiUsage.db.insertRow(
        session,
        AiUsage(authUserId: user, providerId: id, month: month, requests: 1),
      );
    } else {
      await AiUsage.db.updateRow(
        session,
        row.copyWith(requests: row.requests + 1),
      );
    }
  }

  /// The user's provider and model, or why there is none.
  static Future<(AiProvider, String)> _choice(Session session) async {
    final user = Access.userId(session);
    final pref = await AiPreference.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(user),
    );
    if (pref == null || !pref.enabled || pref.providerId == null) {
      throw InvalidInputException(code: 'ai_off');
    }
    final p = await AiProvider.db.findById(session, pref.providerId!);
    final models = p == null ? const <String>[] : modelsOf(p);
    if (p == null || !p.enabled || !models.contains(pref.model)) {
      throw InvalidInputException(code: 'ai_provider_unavailable');
    }
    if (p.monthlyCap > 0 &&
        await usedThisMonth(session, user, p.id!) >= p.monthlyCap) {
      throw InvalidInputException(code: 'ai_cap_reached');
    }
    return (p, pref.model!);
  }

  static List<String> modelsOf(AiProvider p) => [
    for (final m in p.models.split(','))
      if (m.trim().isNotEmpty) m.trim(),
  ];

  static const _system =
      'You are the assistant of OwnCoffer, a personal finance application. '
      'Answer in the language of the user, briefly and plainly. Rules: '
      '(1) every figure comes from the functions you call; never compute, '
      'estimate or invent an amount yourself, and say when something is '
      'unknown; (2) you only see the accounts this user may see; never '
      'attribute a spending to a member of the household without explicit '
      'information; (3) you never change data: to suggest a change, call a '
      'propose_ function; the user accepts it or not in "Mon conseiller"; '
      '(4) amounts are in cents in the functions: show them in euros; '
      '(5) never suggest a real bank operation (transfer, payment).';

  /// One turn of the conversation: [history] (oldest first) then
  /// [message], with an optional image. The model may call the engine's
  /// functions up to a few rounds.
  static Future<AiReply> chat(
    Session session,
    int groupId,
    List<AiMessage> history,
    AiMessage message,
  ) async {
    await Access.requireMember(session, groupId);
    final (provider, model) = await _choice(session);
    if (message.content.length > _maxMessage) {
      throw InvalidInputException(code: 'ai_message_too_long');
    }
    if (message.imageBase64 != null && !provider.vision) {
      throw InvalidInputException(code: 'ai_no_vision');
    }
    final user = Access.userId(session);
    await _count(session, user, provider.id!);
    await Audit.log(
      session,
      groupId: groupId,
      action: 'ai_request',
      entity: 'ai',
      rowId: provider.id,
    );
    Map<String, Object?> wire(AiMessage m) => {
      'role': m.role == 'assistant' ? 'assistant' : 'user',
      'content': m.imageBase64 == null
          ? m.content
          : [
              {'type': 'text', 'text': m.content},
              {
                'type': 'image_url',
                'image_url': {
                  'url':
                      'data:${m.imageMimeType ?? 'image/jpeg'};base64,${m.imageBase64}',
                },
              },
            ],
    };
    final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final messages = <Map<String, Object?>>[
      {'role': 'system', 'content': '$_system Today is $today.'},
      for (final m
          in history.length > _maxHistory
              ? history.sublist(history.length - _maxHistory)
              : history)
        wire(m.copyWith(imageBase64: null)),
      wire(message),
    ];
    final context = AiContext(
      session,
      groupId,
      provider: provider.name,
      model: model,
    );
    final used = <String>[];
    final key = _key(provider);
    for (var round = 0; round < _maxRounds; round++) {
      final answer = await adapterFor(provider).chat(
        baseUrl: provider.baseUrl,
        apiKey: key,
        model: model,
        messages: messages,
        tools: provider.toolCalling ? AiContext.tools : null,
      );
      final calls = answer['tool_calls'];
      if (calls is! List || calls.isEmpty) {
        return AiReply(
          text: (answer['content'] as String?)?.trim() ?? '',
          tools: used,
          provider: provider.name,
          model: model,
          isExternal: isExternal(provider.baseUrl),
          proposals: context.proposals,
        );
      }
      messages.add({
        'role': 'assistant',
        'content': answer['content'],
        'tool_calls': calls,
        // Claude's own blocks, sent back unchanged on the next round.
        if (answer['_anthropic_content'] != null)
          '_anthropic_content': answer['_anthropic_content'],
      });
      for (final c in calls) {
        if (c is! Map) continue;
        final f = c['function'];
        final name = f is Map ? f['name'] as String? ?? '' : '';
        Map<String, Object?> args;
        try {
          final raw = f is Map ? f['arguments'] : null;
          final decoded = raw is String ? jsonDecode(raw) : raw;
          args = decoded is Map<String, Object?> ? decoded : {};
        } on FormatException {
          args = {};
        }
        used.add(name);
        messages.add({
          'role': 'tool',
          'tool_call_id': c['id'],
          'content': AiContext.names.contains(name)
              ? await context.call(name, args)
              : jsonEncode({'error': 'unknown function'}),
        });
      }
    }
    return AiReply(
      text: '',
      tools: used,
      provider: provider.name,
      model: model,
      isExternal: isExternal(provider.baseUrl),
      proposals: context.proposals,
    );
  }

  static const _maxDocumentBytes = 8 * 1024 * 1024;

  /// Reads one document (image, or PDF for Claude) with the user's own
  /// provider and model: the model only reports what is written, through
  /// the one function [tool] (OpenAI format); its arguments are returned
  /// for the engine to check. Nothing else is sent: no account, no other
  /// operation, only [context] (what the document is about) and the file.
  static Future<
    ({Map<String, Object?> fields, AiProvider provider, String model})
  >
  readDocument(
    Session session,
    int groupId, {
    required List<int> bytes,
    required String mimeType,
    required String instructions,
    required Map<String, Object?> tool,
  }) async {
    await Access.requireMember(session, groupId, min: MemberRole.user);
    final (provider, model) = await _choice(session);
    if (!provider.vision) throw InvalidInputException(code: 'ai_no_vision');
    final mime = mimeType.toLowerCase();
    final image = mime.startsWith('image/');
    final pdf = mime == 'application/pdf' && provider.kind == 'anthropic';
    if (!image && !pdf) {
      throw InvalidInputException(code: 'ai_document_not_image');
    }
    if (bytes.length > _maxDocumentBytes) {
      throw InvalidInputException(code: 'ai_document_too_large');
    }
    final user = Access.userId(session);
    await _count(session, user, provider.id!);
    await Audit.log(
      session,
      groupId: groupId,
      action: 'read_document',
      entity: 'ai',
      rowId: provider.id,
    );
    final name = (tool['function'] as Map)['name'] as String;
    final answer = await adapterFor(provider).chat(
      baseUrl: provider.baseUrl,
      apiKey: _key(provider),
      model: model,
      messages: [
        {
          'role': 'system',
          'content':
              'You read documents for OwnCoffer, a personal finance app. '
              'Report only what is written in the document, by calling the '
              'function $name once. Never compute, estimate or invent a '
              'value: leave out what you cannot read. Amounts in cents.',
        },
        {
          'role': 'user',
          'content': [
            {'type': 'text', 'text': instructions},
            {
              'type': 'image_url',
              'image_url': {
                'url': 'data:$mime;base64,${base64Encode(bytes)}',
              },
            },
          ],
        },
      ],
      tools: [tool],
    );
    final calls = answer['tool_calls'];
    final call = calls is List
        ? calls
              .whereType<Map>()
              .where(
                (c) => (c['function'] as Map?)?['name'] == name,
              )
              .firstOrNull
        : null;
    if (call == null) throw const AiUnavailable('nothing read');
    final raw = (call['function'] as Map)['arguments'];
    Object? decoded;
    try {
      decoded = raw is String ? jsonDecode(raw) : raw;
    } on FormatException {
      decoded = null;
    }
    if (decoded is! Map<String, Object?>) {
      throw const AiUnavailable('nothing read');
    }
    return (fields: decoded, provider: provider, model: model);
  }

  static Future<List<String>> testProvider(AiProvider p) =>
      adapterFor(p).models(baseUrl: p.baseUrl, apiKey: _key(p));

  /// The models of a provider being set up, with the key just typed.
  static Future<List<String>> modelsWith(AiProvider p, String? apiKey) =>
      adapterFor(p).models(baseUrl: p.baseUrl, apiKey: apiKey ?? _key(p));
}
