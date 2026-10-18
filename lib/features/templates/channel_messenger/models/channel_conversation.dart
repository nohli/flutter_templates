import 'package:flutter/material.dart';
import '../../../../l10n/localizations.dart';

enum ChannelConversationKind { private, group, channel }

class ChannelConversation {
  const ChannelConversation({
    required this.title,
    required this.preview,
    required this.time,
    required this.initials,
    required this.colors,
    required this.kind,
    this.unread = 0,
    this.muted = false,
    this.pinned = false,
  });

  final String title;
  final String preview;
  final String time;
  final String initials;
  final List<Color> colors;
  final ChannelConversationKind kind;
  final int unread;
  final bool muted;
  final bool pinned;

  static List<ChannelConversation> samples(AppLocalizations l10n) => <ChannelConversation>[
    ChannelConversation(
      title: l10n.designDispatch,
      preview: l10n.newInterfacesThatMoveWithPurpose,
      time: l10n.clock(18, 42),
      initials: 'DD',
      colors: <Color>[const Color(0xFF506CF0), const Color(0xFF63CFF4)],
      kind: ChannelConversationKind.channel,
      unread: 4,
      pinned: true,
    ),
    ChannelConversation(
      title: l10n.studioCrew,
      preview: l10n.mayaThePrototypeIsReadyToTry,
      time: l10n.clock(18, 21),
      initials: 'SC',
      colors: <Color>[const Color(0xFFFF9C66), const Color(0xFFFFD166)],
      kind: ChannelConversationKind.group,
      unread: 2,
      pinned: true,
    ),
    ChannelConversation(
      title: 'Nora',
      preview: l10n.voiceMessage018,
      time: l10n.clock(17, 55),
      initials: 'NO',
      colors: <Color>[const Color(0xFF6ED6A0), const Color(0xFF28A87B)],
      kind: ChannelConversationKind.private,
    ),
    ChannelConversation(
      title: l10n.citySignals,
      preview: l10n.fiveExhibitionsWorthSeeingThisWeekend,
      time: l10n.clock(16, 4),
      initials: 'CS',
      colors: <Color>[const Color(0xFFB48CFF), const Color(0xFF7453DA)],
      kind: ChannelConversationKind.channel,
      muted: true,
    ),
    ChannelConversation(
      title: l10n.productCircle,
      preview: l10n.jonSharingTheNotesNow,
      time: l10n.clock(14, 31),
      initials: 'PC',
      colors: <Color>[const Color(0xFFFF7395), const Color(0xFFC94F78)],
      kind: ChannelConversationKind.group,
    ),
  ];
}
