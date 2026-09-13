import 'package:flutter/material.dart';

import 'models/private_conversation.dart';
import 'private_messenger_theme.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({required this.conversation, super.key});

  final PrivateConversation conversation;

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final _controller = TextEditingController();
  final _messages = <String>[];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 19,
              backgroundColor: widget.conversation.colors.first,
              child: Text(
                widget.conversation.initials,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.conversation.name),
                Text(
                  'online',
                  style: TextStyle(
                    color: colors.primary,
                    fontFamily: PrivateMessengerTheme.fontName,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(tooltip: 'Video call', onPressed: () {}, icon: const Icon(Icons.videocam_outlined)),
          IconButton(tooltip: 'Voice call', onPressed: () {}, icon: const Icon(Icons.call_outlined)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: CustomPaint(painter: _ChatWallpaperPainter(colors.outlineVariant))),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                  children: <Widget>[
                    const _DayMarker(),
                    const SizedBox(height: 18),
                    const _MessageBubble(
                      message: 'Still good for dinner on the garden terrace?',
                      mine: false,
                      time: '18:30',
                    ),
                    const _MessageBubble(message: 'Absolutely. Seven?', mine: true, time: '18:32'),
                    const _MessageBubble(message: 'The garden table is booked 🌿', mine: false, time: '18:36'),
                    for (final message in _messages) _MessageBubble(message: message, mine: true, time: 'Now'),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 7, 10, 9),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          key: const ValueKey<String>('private-chat-composer'),
                          controller: _controller,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            prefixIcon: IconButton(
                              tooltip: 'Add attachment',
                              onPressed: () {},
                              icon: const Icon(Icons.add_rounded),
                            ),
                            suffixIcon: IconButton(
                              tooltip: 'Add emoji',
                              onPressed: () {},
                              icon: const Icon(Icons.sentiment_satisfied_alt_rounded),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (BuildContext context, TextEditingValue value, Widget? child) => IconButton.filled(
                          tooltip: 'Send message',
                          onPressed: _send,
                          icon: Icon(value.text.trim().isEmpty ? Icons.mic_rounded : Icons.send_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _send() {
    final message = _controller.text.trim();
    if (message.isEmpty) {
      return;
    }
    setState(() {
      _messages.add(message);
      _controller.clear();
    });
  }
}

class _DayMarker extends StatelessWidget {
  const _DayMarker();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const Text('TODAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.7)),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.mine, required this.time});

  final String message;
  final bool mine;
  final String time;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 7),
        decoration: BoxDecoration(
          color: mine ? colors.primary : colors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(mine ? 20 : 5),
            topRight: Radius.circular(mine ? 5 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 8,
          children: <Widget>[
            Text(
              message,
              style: TextStyle(color: mine ? colors.onPrimary : colors.onSurface, fontSize: 15, height: 1.3),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  time,
                  style: TextStyle(
                    color: mine ? colors.onPrimary.withValues(alpha: 0.7) : colors.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
                if (mine) ...<Widget>[
                  const SizedBox(width: 3),
                  Icon(Icons.done_all_rounded, color: colors.onPrimary.withValues(alpha: 0.8), size: 13),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatWallpaperPainter extends CustomPainter {
  const _ChatWallpaperPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var y = 28.0; y < size.height; y += 76) {
      for (var x = 24.0; x < size.width; x += 82) {
        final offset = Offset(x + ((y ~/ 76).isEven ? 0 : 22), y);
        canvas.drawCircle(offset, 7, paint);
        canvas.drawLine(offset + const Offset(11, -5), offset + const Offset(18, 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChatWallpaperPainter oldDelegate) => oldDelegate.color != color;
}
