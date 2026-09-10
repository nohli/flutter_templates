class ChatMessage {
  const ChatMessage({required this.id, required this.text, required this.timeLabel, required this.isMine});

  final String id;
  final String text;
  final String timeLabel;
  final bool isMine;

  static const sampleThread = <ChatMessage>[
    ChatMessage(id: '1', text: 'I explored the calmer layout direction.', timeLabel: '10:24', isMine: false),
    ChatMessage(
      id: '2',
      text: 'Nice. The extra space makes the content much clearer.',
      timeLabel: '10:26',
      isMine: true,
    ),
    ChatMessage(id: '3', text: 'The new direction feels exactly right ✨', timeLabel: '10:28', isMine: false),
  ];
}
