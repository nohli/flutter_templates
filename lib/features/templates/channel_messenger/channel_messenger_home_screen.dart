import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'channel_detail_screen.dart';
import 'channel_messenger_theme.dart';
import 'models/channel_conversation.dart';
import 'widgets/channel_conversation_tile.dart';
import '../../../l10n/localizations.dart';

class ChannelMessengerHomeScreen extends StatelessWidget {
  const ChannelMessengerHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: appearance,
      themeBuilder: ChannelMessengerTheme.build,
      builder: (BuildContext context) => const _ChannelMessengerHome(),
    );
  }
}

class _ChannelMessengerHome extends StatefulWidget {
  const _ChannelMessengerHome();

  @override
  State<_ChannelMessengerHome> createState() => _ChannelMessengerHomeState();
}

class _ChannelMessengerHomeState extends State<_ChannelMessengerHome> {
  final _scrollController = ScrollController();
  var _folder = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = switch (_folder) {
      1 => ChannelConversation.samples(context.l10n).where((conversation) => conversation.unread > 0).toList(),
      2 => ChannelConversation.samples(
        context.l10n,
      ).where((conversation) => conversation.kind == ChannelConversationKind.channel).toList(),
      _ => ChannelConversation.samples(context.l10n),
    };
    return PrimaryScrollController(
      controller: _scrollController,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: context.l10n.newMessage,
          onPressed: () => _showNewMessage(context),
          child: const Icon(Icons.edit_rounded),
        ),
        body: SafeArea(
          bottom: false,
          child: TemplateEntrance(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _MessengerHeader(
                    folder: _folder,
                    onFolderChanged: (int value) => setState(() => _folder = value),
                  ),
                ),
                const SliverToBoxAdapter(child: _ArchiveRow()),
                SliverList.builder(
                  itemCount: conversations.length,
                  itemBuilder: (BuildContext context, int index) => ChannelConversationTile(
                    conversation: conversations[index],
                    onTap: () => _openConversation(conversations[index]),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 90)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openConversation(ChannelConversation conversation) {
    unawaited(
      Navigator.of(context).push<void>(
        templatePageRoute<void>(
          context: context,
          builder: (context) => ChannelDetailScreen(
            conversation: ChannelConversation.samples(
              context.l10n,
            ).firstWhere((sample) => sample.initials == conversation.initials),
          ),
        ),
      ),
    );
  }

  void _showNewMessage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(context.l10n.startAConversation, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.group_add_rounded)),
                title: Text(context.l10n.newGroup),
                subtitle: Text(context.l10n.bringAProjectTeamTogether),
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.campaign_rounded)),
                title: Text(context.l10n.newChannel),
                subtitle: Text(context.l10n.broadcastUpdatesToAnAudience),
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_add_alt_rounded)),
                title: Text(context.l10n.newMessage),
                subtitle: Text(context.l10n.findSomeoneByNameOrUsername),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessengerHeader extends StatelessWidget {
  const _MessengerHeader({required this.folder, required this.onFolderChanged});

  final int folder;
  final ValueChanged<int> onFolderChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final folders = <String>[context.l10n.all, context.l10n.unread, context.l10n.channels];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                tooltip: context.l10n.backToTemplateGallery,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  context.l10n.channels,
                  style: const TextStyle(
                    fontFamily: ChannelMessengerTheme.displayFontName,
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.searchMessages,
                onPressed: () {},
                icon: const Icon(Icons.search_rounded),
              ),
              IconButton(
                tooltip: context.l10n.messengerSettings,
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 46,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: colors.surface, borderRadius: const BorderRadius.all(Radius.circular(18))),
            child: Row(
              children: <Widget>[
                for (var index = 0; index < folders.length; index++)
                  Expanded(
                    child: InkWell(
                      onTap: () => onFolderChanged(index),
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 170),
                        decoration: BoxDecoration(
                          color: folder == index ? colors.primary : Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(14)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          folders[index],
                          style: TextStyle(
                            color: folder == index ? colors.onPrimary : colors.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveRow extends StatelessWidget {
  const _ArchiveRow();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.09),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.archive_outlined, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(context.l10n.archivedChats, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          Text(
            context.l10n.number(8),
            style: TextStyle(color: colors.primary, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
