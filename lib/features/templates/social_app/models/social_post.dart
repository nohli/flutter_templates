enum SocialPostArtwork { sunset, coast, studio }

class SocialPost {
  const SocialPost({
    required this.id,
    required this.author,
    required this.initials,
    required this.caption,
    required this.location,
    required this.likes,
    required this.artwork,
  });

  final String id;
  final String author;
  final String initials;
  final String caption;
  final String location;
  final int likes;
  final SocialPostArtwork artwork;

  static const samples = <SocialPost>[
    SocialPost(
      id: 'quiet-morning',
      author: 'Maya Chen',
      initials: 'MC',
      caption: 'A quiet morning, a clear table, and room for one good idea.',
      location: 'Lisbon, Portugal',
      likes: 284,
      artwork: SocialPostArtwork.sunset,
    ),
    SocialPost(
      id: 'coastal-walk',
      author: 'Sam Okafor',
      initials: 'SO',
      caption: 'Taking the long route home.',
      location: 'Cape Town, South Africa',
      likes: 193,
      artwork: SocialPostArtwork.coast,
    ),
    SocialPost(
      id: 'studio-notes',
      author: 'Ana Rivera',
      initials: 'AR',
      caption: 'Today’s palette came from old paper, citrus, and late light.',
      location: 'Mexico City, Mexico',
      likes: 347,
      artwork: SocialPostArtwork.studio,
    ),
  ];
}
