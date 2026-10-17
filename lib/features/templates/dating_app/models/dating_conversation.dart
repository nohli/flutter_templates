import 'dating_message.dart';
import 'dating_profile.dart';
import '../../../../l10n/localizations.dart';

class DatingConversation {
  const DatingConversation({
    required this.id,
    required this.name,
    required this.palette,
    required this.status,
    required this.connection,
    required this.messages,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final DatingProfilePalette palette;
  final String status;
  final String connection;
  final List<DatingMessage> messages;
  final int unreadCount;
  final bool isOnline;

  DatingMessage get latestMessage => messages.last;

  DatingConversation copyWith({int? unreadCount}) {
    return DatingConversation(
      id: id,
      name: name,
      palette: palette,
      status: status,
      connection: connection,
      messages: messages,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline,
    );
  }

  static List<DatingConversation> samples(AppLocalizations l10n) => <DatingConversation>[
    DatingConversation(
      id: 'ari',
      name: 'Ari',
      palette: DatingProfilePalette.lagoon,
      status: l10n.onlineMatchedTuesday,
      connection: l10n.jazzAfterDarkCeramicsTinyRestaurants,
      unreadCount: 2,
      isOnline: true,
      messages: <DatingMessage>[
        DatingMessage(
          id: 'ari-1',
          author: DatingMessageAuthor.match,
          text: l10n.youHadMeAtChoosingDessertFirstTinyJazzBar,
          time: l10n.clock(18, 42),
        ),
        DatingMessage(
          id: 'you-1',
          author: DatingMessageAuthor.user,
          text: l10n.onlyIfWeOrderSomethingWeCannotPronounce,
          time: l10n.clock(18, 47),
        ),
        DatingMessage(
          id: 'ari-2',
          author: DatingMessageAuthor.match,
          text: l10n.dealIKnowExactlyThePlace,
          time: l10n.clock(18, 49),
        ),
      ],
    ),
    DatingConversation(
      id: 'mina',
      name: 'Mina',
      palette: DatingProfilePalette.sunset,
      status: l10n.active12MinAgoMatchedToday,
      connection: l10n.nightSwimsSmallPlatesAnalogueCameras,
      unreadCount: 1,
      messages: <DatingMessage>[
        DatingMessage(
          id: 'mina-1',
          author: DatingMessageAuthor.user,
          text: l10n.youMentionedTheSeaSunriseSwimOrMidnightDip,
          time: l10n.clock(19, 8),
        ),
        DatingMessage(
          id: 'mina-2',
          author: DatingMessageAuthor.match,
          text: l10n.midnightObviouslyIllBringTheTowels,
          time: l10n.clock(19, 12),
        ),
      ],
    ),
    DatingConversation(
      id: 'noah',
      name: 'Noah',
      palette: DatingProfilePalette.violet,
      status: l10n.activeThisAfternoonMatchedMonday,
      connection: l10n.architectureVinylVerySlowSundays,
      messages: <DatingMessage>[
        DatingMessage(
          id: 'noah-1',
          author: DatingMessageAuthor.match,
          text: l10n.iFoundThatRecordShopIToldYouAbout,
          time: l10n.mon,
        ),
        DatingMessage(
          id: 'you-2',
          author: DatingMessageAuthor.user,
          text: l10n.saveMeTheWeirdestSleeveInTheWindow,
          time: l10n.mon,
        ),
      ],
    ),
    DatingConversation(
      id: 'zoe',
      name: 'Zoë',
      palette: DatingProfilePalette.citrus,
      status: l10n.activeYesterdayMatchedFriday,
      connection: l10n.tinyConcertsTrainWindowsFreshPasta,
      messages: <DatingMessage>[
        DatingMessage(
          id: 'zoe-1',
          author: DatingMessageAuthor.match,
          text: l10n.theresAThreeSongSetInTheCourtyardTomorrow,
          time: l10n.fri,
        ),
      ],
    ),
  ];
}
