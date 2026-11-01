import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../ai/ai_adapter.dart';
import '../ai/ai_gateway.dart';
import '../ai/document_reader.dart';
import '../generated/protocol.dart';
import '../onboarding/onboarding.dart';
import '../security/access.dart';
import '../security/audit.dart';
import '../security/scopes.dart';

/// The AI, optional (décision 0006): providers set up by the server
/// administrator (décision 0017), each user's choice, and the assistant.
class AiEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {accessScope};

  static const _kinds = {'openai', 'ollama', 'anthropic'};

  static const _maxModels = 40;

  static AiProvider _public(AiProvider p) =>
      p.copyWith(apiKeyBox: null, hasKey: p.apiKeyBox != null);

  Future<bool> _isAdmin(Session session) =>
      Onboarding.isServerAdmin(session, Access.userId(session));

  Future<void> _requireAdmin(Session session) async {
    if (!await _isAdmin(session)) {
      throw AccessDeniedException(code: 'server_admin_only');
    }
  }

  Future<AiStatus> status(Session session) async {
    final user = Access.userId(session);
    final admin = await _isAdmin(session);
    final pref = await AiPreference.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(user),
    );
    final providers = await AiProvider.db.find(
      session,
      where: admin ? null : (p) => p.enabled.equals(true),
      orderBy: (p) => p.name,
    );
    return AiStatus(
      providers: [for (final p in providers) _public(p)],
      providerId: pref?.providerId,
      model: pref?.model,
      enabled: pref?.enabled ?? false,
      usedThisMonth: pref?.providerId == null
          ? 0
          : await AiGateway.usedThisMonth(session, user, pref!.providerId!),
      canConfigure: admin,
    );
  }

  /// Creates or changes a provider. [apiKey]: null keeps the current key,
  /// empty removes it.
  Future<AiProvider> saveProvider(
    Session session,
    AiProvider provider,
    String? apiKey,
  ) async {
    await _requireAdmin(session);
    final name = provider.name.trim();
    final url = Uri.tryParse(provider.baseUrl.trim());
    if (name.isEmpty || name.length > 60) {
      throw InvalidInputException(code: 'invalid_name', field: 'name');
    }
    if (!_kinds.contains(provider.kind)) {
      throw InvalidInputException(code: 'ai_invalid_kind', field: 'kind');
    }
    if (url == null ||
        !(url.scheme == 'http' || url.scheme == 'https') ||
        url.host.isEmpty ||
        url.userInfo.isNotEmpty) {
      throw InvalidInputException(code: 'ai_invalid_url', field: 'baseUrl');
    }
    if (provider.monthlyCap < 0 || provider.monthlyCap > 100000) {
      throw InvalidInputException(code: 'amount_out_of_range');
    }
    final current = provider.id == null
        ? null
        : await AiProvider.db.findById(session, provider.id!);
    if (provider.id != null && current == null) {
      throw InvalidInputException(code: 'ai_provider_unavailable');
    }
    final box = apiKey == null
        ? current?.apiKeyBox
        : apiKey.trim().isEmpty
        ? null
        : AiGateway.encryptKey(apiKey.trim());
    var models = [
      for (final m in provider.models.split(','))
        if (m.trim().isNotEmpty) m.trim(),
    ];
    if (models.isEmpty) {
      // Only the key typed: the provider says which models it offers (this
      // also checks the address and the key before anything is saved).
      try {
        models = (await AiGateway.modelsWith(
          provider.copyWith(baseUrl: url.toString(), apiKeyBox: box),
          apiKey?.trim().isEmpty ?? true ? null : apiKey!.trim(),
        )).take(_maxModels).toList();
      } on AiUnavailable catch (e) {
        throw InvalidInputException(code: 'ai_unavailable', field: e.reason);
      }
      if (models.isEmpty) {
        throw InvalidInputException(code: 'ai_no_models', field: 'models');
      }
    }
    final clean = provider.copyWith(
      name: name,
      baseUrl: url.toString(),
      models: models.join(','),
      apiKeyBox: box,
      hasKey: null,
    );
    final saved = current == null
        ? await AiProvider.db.insertRow(session, clean.copyWith(id: null))
        : await AiProvider.db.updateRow(session, clean);
    // The key is never written to the log.
    await Audit.log(
      session,
      groupId: null,
      action: current == null ? 'create' : 'update',
      entity: 'ai_provider',
      rowId: saved.id,
      after: _public(saved),
    );
    return _public(saved);
  }

  Future<void> deleteProvider(Session session, int providerId) async {
    await _requireAdmin(session);
    await AiProvider.db.deleteWhere(
      session,
      where: (p) => p.id.equals(providerId),
    );
    await Audit.log(
      session,
      groupId: null,
      action: 'delete',
      entity: 'ai_provider',
      rowId: providerId,
    );
  }

  /// Asks the provider for its models: checks the address and the key.
  Future<List<String>> testProvider(Session session, int providerId) async {
    await _requireAdmin(session);
    final p = await AiProvider.db.findById(session, providerId);
    if (p == null) throw InvalidInputException(code: 'ai_provider_unavailable');
    try {
      return await AiGateway.testProvider(p);
    } on AiUnavailable catch (e) {
      // The provider's own reason (never the key): shown to the user.
      throw InvalidInputException(code: 'ai_unavailable', field: e.reason);
    }
  }

  /// Reads a receipt or invoice with the user's AI: a split (joined to an
  /// operation) or its amount, date and merchant (waiting) are proposed in
  /// "Mon conseiller". Nothing is changed here.
  Future<AiReply> readInvoice(Session session, int invoiceId) =>
      _reading(() => DocumentReader.readInvoice(session, invoiceId));

  /// Reads a loan document with the user's AI: the terms it states are
  /// proposed for the loan in "Mon conseiller".
  Future<AiReply> readLoanDocument(Session session, int documentId) =>
      _reading(() => DocumentReader.readLoanDocument(session, documentId));

  static Future<AiReply> _reading(Future<AiReply> Function() read) async {
    try {
      return await read();
    } on AiUnavailable catch (e) {
      throw InvalidInputException(code: 'ai_unavailable', field: e.reason);
    }
  }

  static const _maxMemories = 20;
  static const _maxConversations = 30;

  /// What the user asked the assistant to keep in mind, oldest first.
  Future<List<AiMemory>> memories(Session session, int groupId) async {
    await Access.requireMember(session, groupId);
    return AiMemory.db.find(
      session,
      where: (m) =>
          m.authUserId.equals(Access.userId(session)) &
          m.groupId.equals(groupId),
      orderBy: (m) => m.id,
    );
  }

  Future<AiMemory> addMemory(Session session, int groupId, String text) async {
    await Access.requireMember(session, groupId);
    final clean = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (clean.isEmpty || clean.length > 300) {
      throw InvalidInputException(code: 'invalid_name', field: 'text');
    }
    if ((await memories(session, groupId)).length >= _maxMemories) {
      throw InvalidInputException(code: 'ai_memory_full');
    }
    return AiMemory.db.insertRow(
      session,
      AiMemory(
        authUserId: Access.userId(session),
        groupId: groupId,
        text: clean,
      ),
    );
  }

  Future<void> deleteMemory(Session session, int memoryId) async {
    await AiMemory.db.deleteWhere(
      session,
      where: (m) =>
          m.id.equals(memoryId) & m.authUserId.equals(Access.userId(session)),
    );
  }

  /// The user's past conversations in this household, newest first.
  Future<List<AiConversation>> conversations(
    Session session,
    int groupId,
  ) async {
    await Access.requireMember(session, groupId);
    return AiConversation.db.find(
      session,
      where: (c) =>
          c.authUserId.equals(Access.userId(session)) &
          c.groupId.equals(groupId),
      orderByList: (c) => [c.updatedAt.desc(), c.id.desc()],
      limit: _maxConversations,
    );
  }

  /// Keeps a conversation (text only); [conversationId] goes on with one.
  /// Only the latest 30 are kept.
  Future<AiConversation> saveConversation(
    Session session,
    int groupId,
    int? conversationId,
    List<AiMessage> messages,
  ) async {
    await Access.requireMember(session, groupId);
    final user = Access.userId(session);
    final kept = [
      for (final m in messages.take(200))
        {
          'role': m.role == 'assistant' ? 'assistant' : 'user',
          'content': m.content.length > 8000
              ? m.content.substring(0, 8000)
              : m.content,
        },
    ];
    final first = messages
        .where((m) => m.role != 'assistant')
        .firstOrNull
        ?.content
        .trim();
    final title = first == null || first.isEmpty
        ? '…'
        : first.length > 80
        ? '${first.substring(0, 80)}…'
        : first;
    final now = DateTime.now().toUtc();
    final current = conversationId == null
        ? null
        : await AiConversation.db.findFirstRow(
            session,
            where: (c) =>
                c.id.equals(conversationId) &
                c.authUserId.equals(user) &
                c.groupId.equals(groupId),
          );
    if (conversationId != null && current == null) {
      throw AccessDeniedException(code: 'ai_conversation_access_denied');
    }
    final saved = current == null
        ? await AiConversation.db.insertRow(
            session,
            AiConversation(
              authUserId: user,
              groupId: groupId,
              title: title,
              messages: jsonEncode(kept),
            ),
          )
        : await AiConversation.db.updateRow(
            session,
            current.copyWith(messages: jsonEncode(kept), updatedAt: now),
          );
    final all = await AiConversation.db.find(
      session,
      where: (c) => c.authUserId.equals(user) & c.groupId.equals(groupId),
      orderByList: (c) => [c.updatedAt.desc(), c.id.desc()],
    );
    for (final old in all.skip(_maxConversations)) {
      await AiConversation.db.deleteRow(session, old);
    }
    return saved;
  }

  Future<void> deleteConversation(Session session, int conversationId) async {
    await AiConversation.db.deleteWhere(
      session,
      where: (c) =>
          c.id.equals(conversationId) &
          c.authUserId.equals(Access.userId(session)),
    );
  }

  /// The user's choice: a provider set up by the administrator and one of
  /// its models, on or off.
  Future<AiStatus> setPreference(
    Session session,
    int? providerId,
    String? model,
    bool enabled,
  ) async {
    final user = Access.userId(session);
    if (enabled || providerId != null) {
      final p = providerId == null
          ? null
          : await AiProvider.db.findById(session, providerId);
      if (p == null || !p.enabled || !AiGateway.modelsOf(p).contains(model)) {
        throw InvalidInputException(code: 'ai_provider_unavailable');
      }
    }
    final current = await AiPreference.db.findFirstRow(
      session,
      where: (p) => p.authUserId.equals(user),
    );
    final row = AiPreference(
      id: current?.id,
      authUserId: user,
      providerId: providerId,
      model: model,
      enabled: enabled,
    );
    if (current == null) {
      await AiPreference.db.insertRow(session, row);
    } else {
      await AiPreference.db.updateRow(session, row);
    }
    return status(session);
  }

  /// One turn with the assistant, on the accounts of [groupId] the user may
  /// see. A provider that does not answer is said so: never another one.
  Future<AiReply> chat(
    Session session,
    int groupId,
    List<AiMessage> history,
    AiMessage message,
  ) async {
    try {
      return await AiGateway.chat(session, groupId, history, message);
    } on AiUnavailable catch (e) {
      // The provider's own reason (never the key): shown to the user.
      throw InvalidInputException(code: 'ai_unavailable', field: e.reason);
    }
  }
}
