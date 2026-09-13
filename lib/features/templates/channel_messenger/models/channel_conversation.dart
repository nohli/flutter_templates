import 'package:flutter/material.dart';

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

  static const samples = <ChannelConversation>[
    ChannelConversation(
      title: 'Design Dispatch',
      preview: 'New: Interfaces that move with purpose',
      time: '18:42',
      initials: 'DD',
      colors: <Color>[Color(0xFF506CF0), Color(0xFF63CFF4)],
      kind: ChannelConversationKind.channel,
      unread: 4,
      pinned: true,
    ),
    ChannelConversation(
      title: 'Studio Crew',
      preview: 'Maya: The prototype is ready to try ✨',
      time: '18:21',
      initials: 'SC',
      colors: <Color>[Color(0xFFFF9C66), Color(0xFFFFD166)],
      kind: ChannelConversationKind.group,
      unread: 2,
      pinned: true,
    ),
    ChannelConversation(
      title: 'Nora',
      preview: 'Voice message · 0:18',
      time: '17:55',
      initials: 'NO',
      colors: <Color>[Color(0xFF6ED6A0), Color(0xFF28A87B)],
      kind: ChannelConversationKind.private,
    ),
    ChannelConversation(
      title: 'City Signals',
      preview: 'Five exhibitions worth seeing this weekend',
      time: '16:04',
      initials: 'CS',
      colors: <Color>[Color(0xFFB48CFF), Color(0xFF7453DA)],
      kind: ChannelConversationKind.channel,
      muted: true,
    ),
    ChannelConversation(
      title: 'Product Circle',
      preview: 'Jon: Sharing the notes now',
      time: '14:31',
      initials: 'PC',
      colors: <Color>[Color(0xFFFF7395), Color(0xFFC94F78)],
      kind: ChannelConversationKind.group,
    ),
  ];
}
