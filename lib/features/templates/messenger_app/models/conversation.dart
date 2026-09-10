enum ConversationTone { aqua, lavender, rose, gold }

class Conversation {
  const Conversation({
    required this.id,
    required this.name,
    required this.initials,
    required this.preview,
    required this.timeLabel,
    required this.tone,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String initials;
  final String preview;
  final String timeLabel;
  final ConversationTone tone;
  final int unreadCount;
  final bool isOnline;

  static const samples = <Conversation>[
    Conversation(
      id: 'maya',
      name: 'Maya Chen',
      initials: 'MC',
      preview: 'The new direction feels exactly right ✨',
      timeLabel: '2m',
      tone: ConversationTone.rose,
      unreadCount: 2,
      isOnline: true,
    ),
    Conversation(
      id: 'product-team',
      name: 'Product team',
      initials: 'PT',
      preview: 'Jon shared a prototype',
      timeLabel: '18m',
      tone: ConversationTone.lavender,
      unreadCount: 1,
    ),
    Conversation(
      id: 'sam',
      name: 'Sam Okafor',
      initials: 'SO',
      preview: 'Coffee tomorrow?',
      timeLabel: '1h',
      tone: ConversationTone.aqua,
      isOnline: true,
    ),
    Conversation(
      id: 'studio',
      name: 'Design studio',
      initials: 'DS',
      preview: 'You: Added the final notes',
      timeLabel: 'Tue',
      tone: ConversationTone.gold,
    ),
  ];
}
