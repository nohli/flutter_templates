import 'package:flutter/material.dart';
import '../../../../l10n/localizations.dart';

class PrivateConversation {
  const PrivateConversation({
    required this.name,
    required this.preview,
    required this.time,
    required this.initials,
    required this.colors,
    this.unread = 0,
    this.sent = false,
    this.group = false,
  });

  final String name;
  final String preview;
  final String time;
  final String initials;
  final List<Color> colors;
  final int unread;
  final bool sent;
  final bool group;

  static List<PrivateConversation> samples(AppLocalizations l10n) => <PrivateConversation>[
    PrivateConversation(
      name: 'Jules',
      preview: l10n.theGardenTableIsBooked,
      time: l10n.clock(18, 36),
      initials: 'JU',
      colors: <Color>[const Color(0xFFFFA070), const Color(0xFFFFCE8A)],
      unread: 2,
    ),
    PrivateConversation(
      name: l10n.sundayHikers,
      preview: l10n.noraIllBringEnoughWater,
      time: l10n.clock(17, 50),
      initials: 'SH',
      colors: <Color>[const Color(0xFF68C99E), const Color(0xFF279776)],
      group: true,
    ),
    PrivateConversation(
      name: l10n.dad,
      preview: l10n.thatPhotoMadeMyDay,
      time: l10n.clock(16, 12),
      initials: 'DA',
      colors: <Color>[const Color(0xFF7797F7), const Color(0xFFB9C7FF)],
      sent: true,
    ),
    PrivateConversation(
      name: 'Lea',
      preview: l10n.voiceMessage009,
      time: l10n.yesterday,
      initials: 'LE',
      colors: <Color>[const Color(0xFFB78AF3), const Color(0xFFE4C1FF)],
    ),
    PrivateConversation(
      name: l10n.dinnerClub,
      preview: l10n.youFridayWorksForMe,
      time: l10n.yesterday,
      initials: 'DC',
      colors: <Color>[const Color(0xFFFF7B8F), const Color(0xFFFFB0B9)],
      sent: true,
      group: true,
    ),
  ];
}
