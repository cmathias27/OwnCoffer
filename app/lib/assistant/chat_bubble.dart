import 'package:flutter/material.dart';
import 'package:owncoffer_client/owncoffer_client.dart';

import '../client.dart';
import '../l10n/app_localizations.dart';
import '../l10n/error_messages.dart';
import '../screens/advisor_screen.dart';
import '../screens/assistant_screen.dart';
import '../util/file_pick.dart';
import 'chat_controller.dart';

/// Above every page: the assistant's bubble at the bottom right and, once
/// opened, the conversation in a small window (a whole screen on a phone),
/// like a messenger. It stays as it is when the user changes page.
class ChatLayer extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigator;
  const ChatLayer({super.key, required this.child, required this.navigator});

  /// Bottom bar of a phone, then room for a page's floating button.
  static double bubbleBottom(double width) => (width < 600 ? 80 : 0) + 84;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      // Its own overlay: tooltips and text fields need one, and the pages'
      // one is under this layer. Where it shows nothing, taps go through.
      Positioned.fill(
        child: Overlay(
          initialEntries: [
            OverlayEntry(builder: (_) => _Floating(navigator: navigator)),
          ],
        ),
      ),
    ],
  );
}

class _Floating extends StatelessWidget {
  final GlobalKey<NavigatorState> navigator;
  const _Floating({required this.navigator});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: chat,
    builder: (context, _) {
      if (!chat.available) return const SizedBox.shrink();
      final size = MediaQuery.sizeOf(context);
      final padding = MediaQuery.paddingOf(context);
      final phone = size.width < 600;
      return Stack(
        children: [
          if (chat.open)
            Positioned(
              right: phone ? 0 : 16,
              left: phone ? 0 : null,
              top: phone ? 0 : null,
              bottom: phone ? 0 : 16 + padding.bottom,
              width: phone ? null : 400,
              height: phone ? null : (size.height - 96).clamp(320, 600),
              child: ChatPanel(navigator: navigator),
            )
          else
            Positioned(
              right: 16,
              bottom: ChatLayer.bubbleBottom(size.width) + padding.bottom,
              child: const _Bubble(),
            ),
        ],
      );
    },
  );
}

class _Bubble extends StatelessWidget {
  const _Bubble();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: l.chatOpen,
      child: Material(
        color: scheme.primary,
        shape: const CircleBorder(),
        elevation: 6,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => chat.setOpen(true),
          child: SizedBox.square(
            dimension: 56,
            child: Badge(
              isLabelVisible: chat.unread || chat.sending,
              smallSize: 12,
              child: Icon(
                chat.sending ? Icons.more_horiz : Icons.chat_bubble_outline,
                color: scheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The conversation: header, messages, and the field to write.
class ChatPanel extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  const ChatPanel({super.key, required this.navigator});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  PickedFile? _image;
  String? _error;

  /// The past conversations, when shown instead of the current one.
  List<AiConversation>? _history;

  Future<void> _showHistory() async {
    final l = AppLocalizations.of(context);
    try {
      final list = await client.ai.conversations(chat.membership!.group.id!);
      if (mounted) setState(() => _history = list);
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(l, e));
    }
  }

  @override
  void initState() {
    super.initState();
    chat.addListener(_toEnd);
  }

  @override
  void dispose() {
    chat.removeListener(_toEnd);
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toEnd() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scroll.hasClients) {
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    }
  });

  Future<void> _send([String? text]) async {
    final l = AppLocalizations.of(context);
    final message = text ?? _input.text;
    if (message.trim().isEmpty || chat.sending) return;
    final image = _image;
    setState(() => (_image = null, _error = null));
    _input.clear();
    final error = await chat.send(message, image: image);
    if (error != null && mounted) {
      setState(() => _error = errorText(l, error));
      _input.text = message;
    }
  }

  void _push(Widget page) {
    final m = chat.membership;
    if (m == null) return;
    if (MediaQuery.sizeOf(context).width < 600) chat.setOpen(false);
    widget.navigator.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final provider = chat.provider;
    final phone = MediaQuery.sizeOf(context).width < 600;
    return SafeArea(
      top: phone,
      bottom: phone,
      child: Material(
        elevation: 12,
        color: scheme.surface,
        borderRadius: phone ? null : BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Material(
              color: scheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: scheme.onPrimaryContainer),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.assistantTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                          if (provider != null)
                            Text(
                              '${provider.name} · ${chat.status?.model ?? ''}',
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l.chatHistory,
                      icon: Icon(
                        _history == null ? Icons.history : Icons.chat_outlined,
                      ),
                      onPressed: () => _history == null
                          ? _showHistory()
                          : setState(() => _history = null),
                    ),
                    IconButton(
                      tooltip: l.chatNew,
                      icon: const Icon(Icons.add_comment_outlined),
                      onPressed: chat.talk.isEmpty || chat.sending
                          ? null
                          : chat.clear,
                    ),
                    IconButton(
                      tooltip: l.chatSettings,
                      icon: const Icon(Icons.tune),
                      onPressed: () =>
                          _push(AssistantScreen(membership: chat.membership!)),
                    ),
                    IconButton(
                      tooltip: l.chatClose,
                      icon: const Icon(Icons.close),
                      onPressed: () => chat.setOpen(false),
                    ),
                  ],
                ),
              ),
            ),
            if (_history != null)
              Expanded(child: _historyList(l))
            else
              Expanded(
                child: ListView(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  children: [
                    if (chat.talk.isEmpty) ...[
                      Text(l.chatIntro, style: theme.textTheme.bodySmall),
                      if (provider != null && provider.kind != 'ollama')
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            l.assistantExternalWarning(provider.name),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.tertiary,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.rule),
                            label: Text(l.assistantClassifyChip),
                            onPressed: chat.sending
                                ? null
                                : () => _send(l.assistantClassifyPrompt),
                          ),
                        ],
                      ),
                    ],
                    for (final (m, r) in chat.talk) ..._exchange(l, m, r),
                  ],
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: scheme.error),
                ),
              ),
            _composer(l, provider?.vision ?? false),
          ],
        ),
      ),
    );
  }

  Widget _historyList(AppLocalizations l) {
    final list = _history!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      children: [
        Text(l.chatHistoryHelp, style: Theme.of(context).textTheme.bodySmall),
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l.chatHistoryNone),
          ),
        for (final c in list)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.chat_bubble_outline),
            title: Text(c.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              MaterialLocalizations.of(context).formatMediumDate(
                c.updatedAt.toLocal(),
              ),
            ),
            selected: c.id == chat.conversationId,
            onTap: () {
              chat.resume(c);
              setState(() => _history = null);
            },
            trailing: IconButton(
              tooltip: l.chatHistoryDelete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await client.ai.deleteConversation(c.id!);
                if (c.id == chat.conversationId) chat.conversationId = null;
                await _showHistory();
              },
            ),
          ),
      ],
    );
  }

  List<Widget> _exchange(AppLocalizations l, AiMessage m, AiReply? r) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    Widget bubble(Widget child, {required bool mine}) => Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: mine ? scheme.primary : scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(mine ? 20 : 4),
              bottomRight: Radius.circular(mine ? 4 : 20),
            ),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: mine ? scheme.onPrimary : null),
            child: child,
          ),
        ),
      ),
    );
    return [
      bubble(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (m.imageBase64 != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, size: 16, color: scheme.onPrimary),
                  const SizedBox(width: 4),
                  Text(l.assistantImageSent),
                ],
              ),
            SelectableText(m.content),
          ],
        ),
        mine: true,
      ),
      bubble(
        r == null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox.square(
                    dimension: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(l.assistantThinking),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(r.text.isEmpty ? l.assistantNoAnswer : r.text),
                  if (r.tools.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        l.assistantUsedTools(r.tools.toSet().join(', ')),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  if (r.isExternal)
                    Text(
                      l.assistantSentTo(r.provider, r.model),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.tertiary,
                      ),
                    ),
                  if (r.proposals.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: FilledButton.tonalIcon(
                        icon: const Icon(Icons.lightbulb_outline),
                        label: Text(l.assistantProposals(r.proposals.length)),
                        onPressed: () => _push(
                          AdvisorScreen(membership: chat.membership!),
                        ),
                      ),
                    ),
                ],
              ),
        mine: false,
      ),
    ];
  }

  Widget _composer(AppLocalizations l, bool vision) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
    child: Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(28),
      child: Row(
        children: [
          if (vision)
            IconButton(
              tooltip: _image == null
                  ? l.assistantAttach
                  : l.assistantImageReady(_image!.name),
              icon: Icon(
                _image == null
                    ? Icons.add_photo_alternate_outlined
                    : Icons.image,
              ),
              onPressed: () async {
                final f = await pickFile(
                  extensions: const ['png', 'jpg', 'jpeg', 'webp'],
                );
                if (f != null && mounted) setState(() => _image = f);
              },
            )
          else
            const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _input,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              decoration: InputDecoration(
                hintText: l.assistantHint,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            tooltip: l.assistantSend,
            icon: chat.sending
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            onPressed: chat.sending ? null : _send,
          ),
        ],
      ),
    ),
  );
}
