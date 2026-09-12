enum DatingMessageAuthor { match, user }

class DatingMessage {
  const DatingMessage({required this.id, required this.author, required this.text, required this.time});

  final String id;
  final DatingMessageAuthor author;
  final String text;
  final String time;
}
