import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../util/file_pick.dart';

/// The conversation with the assistant, kept while the user moves from page
/// to page (the chat bubble shows it above every page). One per signed-in
/// household; forgotten on sign-out or when another household is opened.
class ChatController extends ChangeNotifier {
  GroupMembership? _membership;
  AiStatus? _status;
  final List<(AiMessage, AiReply?)> talk = [];
  var open = false;
  var sending = false;

  /// A reply arrived while the panel was closed.
  var unread = false;

  GroupMembership? get membership => _membership;
  AiStatus? get status => _status;

  AiProvider? get provider {
    final s = _status;
    return s?.providers.where((p) => p.id == s.providerId).firstOrNull;
  }

  /// Whether the bubble is shown: a household, the assistant on, a model.
  bool get available =>
      _membership != null &&
      (_status?.enabled ?? false) &&
      provider != null &&
      _status?.model != null;

  /// The household shown by the app; a different one starts afresh.
  void attach(GroupMembership? m) {
    if (m?.group.id == _membership?.group.id) return;
    _membership = m;
    talk.clear();
    open = false;
    unread = false;
    _status = null;
    notifyListeners();
    if (m != null) refreshStatus();
  }

  /// Tests: a household and a status without the server.
  @visibleForTesting
  void debugSet(GroupMembership? m, AiStatus? s) {
    _membership = m;
    _status = s;
    talk.clear();
    open = false;
    notifyListeners();
  }

  /// After a sign-out.
  void detach() => attach(null);

  Future<void> refreshStatus() async {
    if (_membership == null) return;
    try {
      _status = await client.ai.status();
    } on Object {
      _status = null;
    }
    if (!available) open = false;
    notifyListeners();
  }

  void setOpen(bool value) {
    if (!available && value) return;
    open = value;
    if (value) unread = false;
    notifyListeners();
  }

  void clear() {
    talk.clear();
    notifyListeners();
  }

  /// Sends [text] (and an image for a model that reads them). Returns the
  /// error, if any; the message is then taken back.
  Future<Object?> send(String text, {PickedFile? image}) async {
    final m = _membership;
    if (m == null || sending || text.trim().isEmpty) return null;
    final message = AiMessage(
      role: 'user',
      content: text.trim(),
      imageBase64: image == null ? null : base64Encode(image.bytes),
      imageMimeType: image == null
          ? null
          : image.name.toLowerCase().endsWith('.png')
          ? 'image/png'
          : 'image/jpeg',
    );
    final history = [
      for (final (q, r) in talk) ...[
        q.copyWith(imageBase64: null),
        if (r != null) AiMessage(role: 'assistant', content: r.text),
      ],
    ];
    talk.add((message, null));
    sending = true;
    notifyListeners();
    Object? error;
    try {
      final reply = await client.ai.chat(m.group.id!, history, message);
      talk[talk.length - 1] = (message, reply);
      if (!open) unread = true;
    } on Object catch (e) {
      talk.removeLast();
      error = e;
    } finally {
      sending = false;
      notifyListeners();
    }
    await refreshStatus();
    return error;
  }
}

/// The app's one conversation.
final chat = ChatController();
