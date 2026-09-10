import 'package:flutter/material.dart';

import 'messenger_app_theme.dart';
import 'models/chat_message.dart';
import 'models/conversation.dart';
import 'widgets/contact_avatar.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({required this.conversation, super.key});

  final Conversation conversation;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = ChatMessage.sampleThread.toList();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MessengerAppTheme.build(),
      child: PrimaryScrollController(
        controller: _scrollController,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MessengerAppTheme.background,
            surfaceTintColor: Colors.transparent,
            titleSpacing: 0,
            title: Row(
              children: <Widget>[
                ContactAvatar(
                  initials: widget.conversation.initials,
                  tone: widget.conversation.tone,
                  isOnline: widget.conversation.isOnline,
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.conversation.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.conversation.isOnline ? 'Online' : 'Away',
                        style: const TextStyle(fontSize: 11, color: MessengerAppTheme.mutedInk),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                tooltip: 'Start sample call',
                onPressed: () => _showMessage('Calls are not connected in this template.'),
                icon: const Icon(Icons.call_outlined),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  itemCount: _messages.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final message = _messages[_messages.length - index - 1];
                    return _MessageBubble(message: message);
                  },
                ),
              ),
              _MessageComposer(controller: _messageController, onSend: _sendMessage),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _messages.add(ChatMessage(id: 'local-${_messages.length}', text: text, timeLabel: 'Now', isMine: true));
      _messageController.clear();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
        decoration: BoxDecoration(
          color: message.isMine ? MessengerAppTheme.primary : MessengerAppTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isMine ? 18 : 5),
            bottomRight: Radius.circular(message.isMine ? 5 : 18),
          ),
          boxShadow: message.isMine ? null : MessengerAppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              message.text,
              style: TextStyle(color: message.isMine ? Colors.white : MessengerAppTheme.ink, height: 1.35),
            ),
            const SizedBox(height: 4),
            Text(
              message.timeLabel,
              style: TextStyle(
                color: message.isMine ? const Color(0xFFDCD5FF) : MessengerAppTheme.mutedInk,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Material(
        color: MessengerAppTheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        child: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 4,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => onSend(),
          decoration: InputDecoration(
            hintText: 'Message',
            prefixIcon: const Icon(Icons.add_circle_outline_rounded),
            suffixIcon: IconButton.filled(
              tooltip: 'Send message',
              onPressed: onSend,
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
