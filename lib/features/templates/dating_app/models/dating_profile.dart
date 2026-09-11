enum DatingProfilePalette { sunset, violet, lagoon, citrus }

class DatingProfile {
  const DatingProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.distance,
    required this.prompt,
    required this.answer,
    required this.interests,
    required this.palette,
  });

  final String id;
  final String name;
  final int age;
  final String distance;
  final String prompt;
  final String answer;
  final List<String> interests;
  final DatingProfilePalette palette;

  static const samples = <DatingProfile>[
    DatingProfile(
      id: 'mina',
      name: 'Mina',
      age: 29,
      distance: '2 km away',
      prompt: 'The quickest way to my heart',
      answer: 'A long table, shared plates, and choosing dessert first.',
      interests: <String>['Ceramics', 'Night swims', 'Jazz'],
      palette: DatingProfilePalette.sunset,
    ),
    DatingProfile(
      id: 'noah',
      name: 'Noah',
      age: 31,
      distance: '4 km away',
      prompt: 'A perfect slow Sunday',
      answer: 'Coffee outside, a second-hand bookshop, then nowhere to be.',
      interests: <String>['Architecture', 'Vinyl', 'Baking'],
      palette: DatingProfilePalette.violet,
    ),
    DatingProfile(
      id: 'eli',
      name: 'Eli',
      age: 28,
      distance: '6 km away',
      prompt: 'Let’s make time for',
      answer: 'Sunrise hikes that end with a very unnecessary breakfast.',
      interests: <String>['Trails', 'Film', 'Coffee'],
      palette: DatingProfilePalette.lagoon,
    ),
    DatingProfile(
      id: 'zoe',
      name: 'Zoë',
      age: 30,
      distance: '8 km away',
      prompt: 'I’ll always say yes to',
      answer: 'A tiny concert, a train somewhere new, or fresh pasta.',
      interests: <String>['Live music', 'Travel', 'Cooking'],
      palette: DatingProfilePalette.citrus,
    ),
  ];
}
