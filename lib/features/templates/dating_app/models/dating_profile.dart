import '../../../../l10n/localizations.dart';

enum DatingProfilePalette { sunset, violet, lagoon, citrus }

class DatingProfile {
  const DatingProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.distanceKm,
    required this.prompt,
    required this.answer,
    required this.interests,
    required this.palette,
  });

  final String id;
  final String name;
  final int age;
  final int distanceKm;
  final String prompt;
  final String answer;
  final List<String> interests;
  final DatingProfilePalette palette;

  static List<DatingProfile> samples(AppLocalizations l10n) => <DatingProfile>[
    DatingProfile(
      id: 'mina',
      name: 'Mina',
      age: 29,
      distanceKm: 2,
      prompt: l10n.theQuickestWayToMyHeart,
      answer: l10n.aLongTableSharedPlatesAndChoosingDessertFirst,
      interests: <String>[l10n.ceramics, l10n.nightSwims, l10n.jazz],
      palette: DatingProfilePalette.sunset,
    ),
    DatingProfile(
      id: 'noah',
      name: 'Noah',
      age: 31,
      distanceKm: 4,
      prompt: l10n.aPerfectSlowSunday,
      answer: l10n.coffeeOutsideASecondHandBookshopThenNowhereToBe,
      interests: <String>[l10n.architecture, l10n.vinyl, l10n.baking],
      palette: DatingProfilePalette.violet,
    ),
    DatingProfile(
      id: 'eli',
      name: 'Eli',
      age: 28,
      distanceKm: 6,
      prompt: l10n.letsMakeTimeFor,
      answer: l10n.sunriseHikesThatEndWithAVeryUnnecessaryBreakfast,
      interests: <String>[l10n.trails, l10n.film, l10n.coffee],
      palette: DatingProfilePalette.lagoon,
    ),
    DatingProfile(
      id: 'zoe',
      name: 'Zoë',
      age: 30,
      distanceKm: 8,
      prompt: l10n.illAlwaysSayYesTo,
      answer: l10n.aTinyConcertATrainSomewhereNewOrFreshPasta,
      interests: <String>[l10n.liveMusic, l10n.travel, l10n.cooking],
      palette: DatingProfilePalette.citrus,
    ),
  ];
}
