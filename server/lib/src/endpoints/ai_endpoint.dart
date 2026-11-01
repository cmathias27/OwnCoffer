import 'package:serverpod/serverpod.dart';

import '../ai/ai_adapter.dart';
import '../ai/ai_gateway.dart';
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

  static const _kinds = {'openai', 'ollama'};

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
    final clean = provider.copyWith(
      name: name,
      baseUrl: url.toString(),
      models: [
        for (final m in provider.models.split(','))
          if (m.trim().isNotEmpty) m.trim(),
      ].join(','),
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
    } on AiUnavailable {
      throw InvalidInputException(code: 'ai_unavailable');
    }
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
    } on AiUnavailable {
      throw InvalidInputException(code: 'ai_unavailable');
    }
  }
}
