import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'dating_app_theme.dart';
import 'dating_chat_screen.dart';
import 'models/dating_conversation.dart';
import 'widgets/dating_conversation_avatar.dart';
import 'widgets/dating_conversation_tile.dart';
import '../../../l10n/localizations.dart';

class DatingInboxScreen extends StatefulWidget {
  const DatingInboxScreen({required this.appearance, super.key});

  final AppAppearance appearance;

  @override
  State<DatingInboxScreen> createState() => _DatingInboxScreenState();
}

class _DatingInboxScreenState extends State<DatingInboxScreen> {
  final _readConversationIds = <String>{};

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: DatingAppTheme.build,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: _InboxAppBar(onNewMessage: () => _showPreview(context)),
          body: TemplateEntrance(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 34),
                  sliver: SliverList.list(
                    children: <Widget>[
                      const _InboxIntro(),
                      const SizedBox(height: 24),
                      _NewMatches(onOpen: (DatingConversation conversation) => _openChat(context, conversation)),
                      const SizedBox(height: 28),
                      const _ConversationHeading(),
                      const SizedBox(height: 12),
                      for (final (index, conversation) in DatingConversation.samples(context.l10n).indexed) ...<Widget>[
                        _ConversationEntrance(
                          index: index,
                          child: DatingConversationTile(
                            conversation: _visibleConversation(conversation),
                            onTap: () => _openChat(context, conversation),
                          ),
                        ),
                        if (index != DatingConversation.samples(context.l10n).length - 1) const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openChat(BuildContext context, DatingConversation conversation) {
    setState(() {
      _readConversationIds.add(conversation.id);
    });
    final route = MaterialPageRoute<void>(
      builder: (context) => DatingChatScreen(
        appearance: widget.appearance,
        conversation: DatingConversation.samples(context.l10n).firstWhere((sample) => sample.id == conversation.id),
      ),
    );
    unawaited(Navigator.of(context).push<void>(route));
  }

  DatingConversation _visibleConversation(DatingConversation conversation) {
    return _readConversationIds.contains(conversation.id) ? conversation.copyWith(unreadCount: 0) : conversation;
  }

  void _showPreview(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.newConversationsAreReadyToConnect)));
  }
}

class _InboxAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _InboxAppBar({required this.onNewMessage});

  final VoidCallback onNewMessage;

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
          tooltip: context.l10n.backToDiscovery,
          onPressed: () => Navigator.of(context).pop(),
          style: IconButton.styleFrom(
            side: BorderSide(color: colors.outlineVariant),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      titleSpacing: 0,
      title: Text(
        context.l10n.messages,
        style: const TextStyle(fontFamily: DatingAppTheme.displayFontName, fontSize: 28, fontWeight: FontWeight.w600),
      ),
      actions: <Widget>[
        IconButton(
          tooltip: context.l10n.startAConversation,
          onPressed: onNewMessage,
          style: IconButton.styleFrom(
            side: BorderSide(color: colors.outlineVariant),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.edit_outlined),
        ),
        const SizedBox(width: 10),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: colors.outlineVariant),
      ),
    );
  }
}

class _InboxIntro extends StatelessWidget {
  const _InboxIntro();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.connectionsThisWeek,
          style: TextStyle(color: colors.primary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.aLittleCloser,
          style: const TextStyle(
            fontFamily: DatingAppTheme.displayFontName,
            fontSize: 39,
            height: 0.95,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          context.l10n.valueConversationsNoPressurePickUpWhereverItFeelsNatural(
            DatingConversation.samples(context.l10n).length,
          ),
          style: TextStyle(color: colors.onSurfaceVariant, height: 1.35),
        ),
      ],
    );
  }
}

class _NewMatches extends StatelessWidget {
  const _NewMatches({required this.onOpen});

  final ValueChanged<DatingConversation> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.newMatches,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final (index, conversation) in DatingConversation.samples(context.l10n).indexed) ...<Widget>[
                _MatchShortcut(conversation: conversation, onTap: () => onOpen(conversation)),
                if (index != DatingConversation.samples(context.l10n).length - 1) const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MatchShortcut extends StatelessWidget {
  const _MatchShortcut({required this.conversation, required this.onTap});

  final DatingConversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: context.l10n.openNewMatchValue(conversation.name),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          child: Column(
            children: <Widget>[
              DatingConversationAvatar(conversation: conversation, size: 64),
              const SizedBox(height: 7),
              Text(conversation.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationHeading extends StatelessWidget {
  const _ConversationHeading();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            context.l10n.conversations,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.1),
          ),
        ),
        Text(
          context.l10n.valueActive(
            context.l10n.number(DatingConversation.samples(context.l10n).length, minimumIntegerDigits: 2),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ConversationEntrance extends StatelessWidget {
  const _ConversationEntrance({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + index * 70),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 12 * (1 - value)), child: child),
        );
      },
    );
  }
}
