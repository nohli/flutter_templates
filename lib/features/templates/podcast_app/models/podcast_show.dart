enum PodcastCategory { all, design, culture, science }

enum PodcastTone { coral, cobalt, sky, sage }

class PodcastShow {
  const PodcastShow({
    required this.id,
    required this.title,
    required this.author,
    required this.episodeTitle,
    required this.durationMinutes,
    required this.category,
    required this.tone,
  });

  final String id;
  final String title;
  final String author;
  final String episodeTitle;
  final int durationMinutes;
  final PodcastCategory category;
  final PodcastTone tone;

  String get durationLabel => '$durationMinutes min';

  static const samples = <PodcastShow>[
    PodcastShow(
      id: 'small-wonders',
      title: 'Small Wonders',
      author: 'Mira Cole',
      episodeTitle: 'Designing a life with room to notice',
      durationMinutes: 32,
      category: PodcastCategory.design,
      tone: PodcastTone.coral,
    ),
    PodcastShow(
      id: 'after-hours',
      title: 'After Hours',
      author: 'Jon Bell',
      episodeTitle: 'Why cities come alive after dark',
      durationMinutes: 41,
      category: PodcastCategory.culture,
      tone: PodcastTone.cobalt,
    ),
    PodcastShow(
      id: 'field-notes',
      title: 'Field Notes',
      author: 'Dr. Lena Park',
      episodeTitle: 'The hidden language of urban birds',
      durationMinutes: 27,
      category: PodcastCategory.science,
      tone: PodcastTone.sky,
    ),
    PodcastShow(
      id: 'material-world',
      title: 'Material World',
      author: 'Ari Soto',
      episodeTitle: 'What everyday objects teach us',
      durationMinutes: 36,
      category: PodcastCategory.design,
      tone: PodcastTone.sage,
    ),
  ];
}
