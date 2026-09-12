import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import 'dating_app_theme.dart';
import 'models/dating_conversation.dart';
import 'models/dating_message.dart';
import 'widgets/dating_conversation_avatar.dart';
import 'widgets/dating_message_bubble.dart';

class DatingChatScreen extends StatefulWidget {
  const DatingChatScreen({required this.appearance, required this.conversation, super.key});

  final AppAppearance appearance;
  final DatingConversation conversation;

  @override
  State<DatingChatScreen> createState() => _DatingChatScreenState();
}

class _DatingChatScreenState extends State<DatingChatScreen> {
  final _composer = TextEditingController();
  final _scrollController = ScrollController();
  late final _messages = <DatingMessage>[...widget.conversation.messages];

  @override
  void initState() {
    super.initState();
    _composer.addListener(_composerChanged);
  }

  @override
  void dispose() {
    _composer
      ..removeListener(_composerChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: DatingAppTheme.build,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: _ChatAppBar(conversation: widget.conversation),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                  children: <Widget>[
                    _MatchNote(conversation: widget.conversation),
                    const SizedBox(height: 26),
                    for (final message in _messages)
                      DatingMessageBubble(key: ValueKey<String>(message.id), message: message),
                  ],
                ),
              ),
              _MessageComposer(
                conversationName: widget.conversation.name,
                controller: _composer,
                canSend: _composer.text.trim().isNotEmpty,
                onSend: _send,
              ),
            ],
          ),
        );
      },
    );
  }

  void _composerChanged() => setState(() {});

  void _send() {
    final text = _composer.text.trim();
    if (text.isEmpty) {
      return;
    }

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    setState(() {
      _messages.add(
        DatingMessage(id: 'you-${_messages.length}', author: DatingMessageAuthor.user, text: text, time: 'NOW'),
      );
    });
    _composer.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      final target = _scrollController.position.maxScrollExtent;
      if (reduceMotion) {
        _scrollController.jumpTo(target);
      } else {
        unawaited(
          _scrollController.animateTo(target, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic),
        );
      }
    });
  }
}

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({required this.conversation});

  final DatingConversation conversation;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 62,
      leading: Center(
        child: IconButton(
          tooltip: 'Back to conversations',
          onPressed: () => Navigator.of(context).pop(),
          style: IconButton.styleFrom(
            side: BorderSide(color: colors.outlineVariant),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          DatingConversationAvatar(conversation: conversation, size: 46),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  conversation.name,
                  style: const TextStyle(
                    fontFamily: DatingAppTheme.displayFontName,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  conversation.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.secondary,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          tooltip: 'Conversation details',
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Conversation details are ready to connect.')));
          },
          icon: const Icon(Icons.more_horiz_rounded),
        ),
        const SizedBox(width: 6),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: colors.outlineVariant),
      ),
    );
  }
}

class _MatchNote extends StatelessWidget {
  const _MatchNote({required this.conversation});

  final DatingConversation conversation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      label: 'You and ${conversation.name} matched',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          border: Border.all(color: colors.secondary),
          borderRadius: DatingAppTheme.cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(color: colors.secondary.withValues(alpha: 0.2), blurRadius: 22, offset: const Offset(0, 10)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'A GOOD BEGINNING / 01',
                style: TextStyle(
                  color: colors.onSecondaryContainer,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'You and ${conversation.name} found a little common ground.',
                style: TextStyle(
                  color: colors.onSecondaryContainer,
                  fontFamily: DatingAppTheme.displayFontName,
                  fontSize: 26,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(conversation.connection, style: TextStyle(color: colors.onSecondaryContainer)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.conversationName,
    required this.controller,
    required this.canSend,
    required this.onSend,
  });

  final String conversationName;
  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.primary, width: 2)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.shadow.withValues(alpha: 0.14), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (!largeText) ...<Widget>[
              IconButton.outlined(
                tooltip: 'Add attachment',
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(content: Text('Attachments are ready to connect.')));
                },
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(50),
                  side: BorderSide(color: colors.outlineVariant),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.add_rounded),
              ),
              const SizedBox(width: 9),
            ],
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: largeText ? 1 : 3,
                textInputAction: TextInputAction.send,
                onSubmitted: canSend ? (_) => onSend() : null,
                decoration: InputDecoration(
                  hintText: 'Message $conversationName',
                  filled: true,
                  fillColor: colors.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
                  border: const OutlineInputBorder(
                    borderRadius: DatingAppTheme.controlRadius,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: DatingAppTheme.controlRadius,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: DatingAppTheme.controlRadius,
                    borderSide: BorderSide(color: colors.primary, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            AnimatedScale(
              scale: canSend ? 1 : 0.92,
              duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: IconButton(
                tooltip: 'Send message',
                onPressed: canSend ? onSend : null,
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll<Size>(Size.square(50)),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                    return states.contains(WidgetState.disabled) ? colors.surfaceContainerHighest : colors.primary;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                    return states.contains(WidgetState.disabled) ? colors.onSurfaceVariant : colors.onPrimary;
                  }),
                  side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
                    return BorderSide(
                      color: states.contains(WidgetState.disabled) ? colors.outlineVariant : colors.primary,
                    );
                  }),
                  shape: const WidgetStatePropertyAll<OutlinedBorder>(CircleBorder()),
                ),
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
