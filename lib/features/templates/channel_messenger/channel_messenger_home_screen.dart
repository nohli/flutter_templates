import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'channel_detail_screen.dart';
import 'channel_messenger_theme.dart';
import 'models/channel_conversation.dart';
import 'widgets/channel_conversation_tile.dart';

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
      1 => ChannelConversation.samples.where((conversation) => conversation.unread > 0).toList(),
      2 =>
        ChannelConversation.samples
            .where((conversation) => conversation.kind == ChannelConversationKind.channel)
            .toList(),
      _ => ChannelConversation.samples,
    };
    return PrimaryScrollController(
      controller: _scrollController,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'New message',
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
      Navigator.of(
        context,
      ).push<void>(MaterialPageRoute<void>(builder: (_) => ChannelDetailScreen(conversation: conversation))),
    );
  }

  void _showNewMessage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) => const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Start a conversation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              SizedBox(height: 18),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.group_add_rounded)),
                title: Text('New group'),
                subtitle: Text('Bring a project team together'),
              ),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.campaign_rounded)),
                title: Text('New channel'),
                subtitle: Text('Broadcast updates to an audience'),
              ),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person_add_alt_rounded)),
                title: Text('New message'),
                subtitle: Text('Find someone by name or username'),
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
    const folders = <String>['All', 'Unread', 'Channels'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                tooltip: 'Back to template gallery',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Aero',
                  style: TextStyle(
                    fontFamily: ChannelMessengerTheme.displayFontName,
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(tooltip: 'Search messages', onPressed: () {}, icon: const Icon(Icons.search_rounded)),
              IconButton(tooltip: 'Messenger settings', onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
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
          const Expanded(
            child: Text('Archived chats', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          Text(
            '8',
            style: TextStyle(color: colors.primary, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
