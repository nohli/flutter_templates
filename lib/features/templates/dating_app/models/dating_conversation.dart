import 'dating_message.dart';
import 'dating_profile.dart';

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

  static const samples = <DatingConversation>[
    DatingConversation(
      id: 'ari',
      name: 'Ari',
      palette: DatingProfilePalette.lagoon,
      status: 'ONLINE / MATCHED TUESDAY',
      connection: 'Jazz after dark · ceramics · tiny restaurants',
      unreadCount: 2,
      isOnline: true,
      messages: <DatingMessage>[
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
      ],
    ),
    DatingConversation(
      id: 'mina',
      name: 'Mina',
      palette: DatingProfilePalette.sunset,
      status: 'ACTIVE 12 MIN AGO / MATCHED TODAY',
      connection: 'Night swims · small plates · analogue cameras',
      unreadCount: 1,
      messages: <DatingMessage>[
        DatingMessage(
          id: 'mina-1',
          author: DatingMessageAuthor.user,
          text: 'You mentioned the sea. Sunrise swim or midnight dip?',
          time: '19:08',
        ),
        DatingMessage(
          id: 'mina-2',
          author: DatingMessageAuthor.match,
          text: 'Midnight, obviously. I’ll bring the towels.',
          time: '19:12',
        ),
      ],
    ),
    DatingConversation(
      id: 'noah',
      name: 'Noah',
      palette: DatingProfilePalette.violet,
      status: 'ACTIVE THIS AFTERNOON / MATCHED MONDAY',
      connection: 'Architecture · vinyl · very slow Sundays',
      messages: <DatingMessage>[
        DatingMessage(
          id: 'noah-1',
          author: DatingMessageAuthor.match,
          text: 'I found that record shop I told you about.',
          time: 'MON',
        ),
        DatingMessage(
          id: 'you-2',
          author: DatingMessageAuthor.user,
          text: 'Save me the weirdest sleeve in the window.',
          time: 'MON',
        ),
      ],
    ),
    DatingConversation(
      id: 'zoe',
      name: 'Zoë',
      palette: DatingProfilePalette.citrus,
      status: 'ACTIVE YESTERDAY / MATCHED FRIDAY',
      connection: 'Tiny concerts · train windows · fresh pasta',
      messages: <DatingMessage>[
        DatingMessage(
          id: 'zoe-1',
          author: DatingMessageAuthor.match,
          text: 'There’s a three-song set in the courtyard tomorrow.',
          time: 'FRI',
        ),
      ],
    ),
  ];
}
