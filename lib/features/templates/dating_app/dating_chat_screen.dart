import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import 'dating_app_theme.dart';
import 'models/dating_message.dart';
import 'models/dating_profile.dart';
import 'widgets/dating_message_bubble.dart';
import 'widgets/dating_profile_artwork.dart';

class DatingChatScreen extends StatefulWidget {
  const DatingChatScreen({required this.appearance, super.key});

  final AppAppearance appearance;

  @override
  State<DatingChatScreen> createState() => _DatingChatScreenState();
}

class _DatingChatScreenState extends State<DatingChatScreen> {
  final _composer = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <DatingMessage>[...DatingMessage.conversation];

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
          appBar: const _ChatAppBar(),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                  children: <Widget>[
                    const _MatchNote(),
                    const SizedBox(height: 26),
                    for (final message in _messages)
                      DatingMessageBubble(key: ValueKey<String>(message.id), message: message),
                  ],
                ),
              ),
              _MessageComposer(controller: _composer, canSend: _composer.text.trim().isNotEmpty, onSend: _send),
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
  const _ChatAppBar();

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
          tooltip: 'Back to discovery',
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
          const _ChatAvatar(),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Ari',
                  style: TextStyle(
                    fontFamily: DatingAppTheme.displayFontName,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'ONLINE / MATCHED TUESDAY',
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

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Ari profile portrait',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: DatingAppTheme.mint, width: 2),
        ),
        width: 46,
        height: 46,
        child: const DatingProfileArtwork(palette: DatingProfilePalette.lagoon),
      ),
    );
  }
}

class _MatchNote extends StatelessWidget {
  const _MatchNote();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      label: 'You and Ari matched on Tuesday',
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
                'You and Ari found a little common ground.',
                style: TextStyle(
                  color: colors.onSecondaryContainer,
                  fontFamily: DatingAppTheme.displayFontName,
                  fontSize: 26,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Jazz after dark · ceramics · tiny restaurants',
                style: TextStyle(color: colors.onSecondaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({required this.controller, required this.canSend, required this.onSend});

  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
        child: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 3,
          textInputAction: TextInputAction.send,
          onSubmitted: canSend ? (_) => onSend() : null,
          decoration: InputDecoration(
            hintText: 'Message Ari',
            prefixIcon: const Icon(Icons.sentiment_satisfied_alt_rounded),
            border: const OutlineInputBorder(borderRadius: DatingAppTheme.controlRadius),
            suffixIcon: IconButton.filled(
              tooltip: 'Send message',
              onPressed: canSend ? onSend : null,
              style: IconButton.styleFrom(shape: const CircleBorder()),
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
