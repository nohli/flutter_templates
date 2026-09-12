enum DatingMessageAuthor { match, user }

class DatingMessage {
  const DatingMessage({required this.id, required this.author, required this.text, required this.time});

  final String id;
  final DatingMessageAuthor author;
  final String text;
  final String time;

  static const conversation = <DatingMessage>[
    DatingMessage(
      id: 'ari-1',
      author: DatingMessageAuthor.match,
      text: 'You had me at choosing dessert first. Tiny jazz bar this Thursday?',
      time: '18:42',
    ),
    DatingMessage(
      id: 'you-1',
      author: DatingMessageAuthor.user,
      text: 'Only if we order something we cannot pronounce.',
      time: '18:47',
    ),
    DatingMessage(
      id: 'ari-2',
      author: DatingMessageAuthor.match,
      text: 'Deal. I know exactly the place.',
      time: '18:49',
    ),
  ];
}
