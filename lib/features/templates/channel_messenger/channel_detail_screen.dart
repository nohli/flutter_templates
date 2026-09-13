import 'package:flutter/material.dart';

import 'channel_messenger_theme.dart';
import 'models/channel_conversation.dart';

class ChannelDetailScreen extends StatefulWidget {
  const ChannelDetailScreen({required this.conversation, super.key});

  final ChannelConversation conversation;

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  var _subscribed = true;
  var _reaction = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.conversation.title),
            Text(
              widget.conversation.kind == ChannelConversationKind.channel
                  ? '12.8K subscribers'
                  : '5 members · 3 online',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontFamily: ChannelMessengerTheme.fontName,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(tooltip: 'Search conversation', onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(tooltip: 'More options', onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
              children: <Widget>[
                const _DayPill(),
                const SizedBox(height: 18),
                _ChannelPost(
                  channel: widget.conversation.kind == ChannelConversationKind.channel,
                  reacted: _reaction,
                  onReact: () => setState(() => _reaction = !_reaction),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: widget.conversation.kind == ChannelConversationKind.channel
                  ? FilledButton.icon(
                      onPressed: () => setState(() => _subscribed = !_subscribed),
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      icon: Icon(_subscribed ? Icons.notifications_active_rounded : Icons.notifications_none_rounded),
                      label: Text(_subscribed ? 'Subscribed' : 'Subscribe'),
                    )
                  : TextField(
                      decoration: InputDecoration(
                        hintText: 'Message',
                        prefixIcon: const Icon(Icons.attach_file_rounded),
                        suffixIcon: IconButton(
                          tooltip: 'Send message',
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_upward_rounded),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: const Text('TODAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
      ),
    );
  }
}

class _ChannelPost extends StatelessWidget {
  const _ChannelPost({required this.channel, required this.reacted, required this.onReact});

  final bool channel;
  final bool reacted;
  final VoidCallback onReact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 230,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF1867C0), Color(0xFF62D8F0), Color(0xFFF6D46B)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: const Stack(
              children: <Widget>[
                Positioned(
                  left: 22,
                  top: 22,
                  child: Text(
                    'FIELD\nNOTES\n/ 08',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: ChannelMessengerTheme.displayFontName,
                      fontSize: 31,
                      fontWeight: FontWeight.w800,
                      height: 0.9,
                    ),
                  ),
                ),
                Positioned(right: 22, bottom: 22, child: Icon(Icons.north_east_rounded, color: Colors.white, size: 48)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            channel ? 'Interfaces that move with purpose' : 'The prototype is ready to try',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            channel
                ? 'A five-minute read on transitions that orient people instead of distracting them.'
                : 'I added the final motion pass. Tell me what feels too slow.',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 15, height: 1.35),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              ActionChip(
                onPressed: onReact,
                avatar: Icon(
                  reacted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 17,
                  color: reacted ? ChannelMessengerTheme.blue : colors.onSurfaceVariant,
                ),
                label: Text('${reacted ? 128 : 127}'),
              ),
              const SizedBox(width: 8),
              const ActionChip(
                onPressed: null,
                avatar: Icon(Icons.chat_bubble_outline_rounded, size: 16),
                label: Text('24'),
              ),
              const Spacer(),
              Text('18:42', style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
