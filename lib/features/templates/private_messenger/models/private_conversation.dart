import 'package:flutter/material.dart';

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

  static const samples = <PrivateConversation>[
    PrivateConversation(
      name: 'Jules',
      preview: 'The garden table is booked 🌿',
      time: '18:36',
      initials: 'JU',
      colors: <Color>[Color(0xFFFFA070), Color(0xFFFFCE8A)],
      unread: 2,
    ),
    PrivateConversation(
      name: 'Sunday hikers',
      preview: 'Nora: I’ll bring enough water',
      time: '17:50',
      initials: 'SH',
      colors: <Color>[Color(0xFF68C99E), Color(0xFF279776)],
      group: true,
    ),
    PrivateConversation(
      name: 'Dad',
      preview: 'That photo made my day',
      time: '16:12',
      initials: 'DA',
      colors: <Color>[Color(0xFF7797F7), Color(0xFFB9C7FF)],
      sent: true,
    ),
    PrivateConversation(
      name: 'Lea',
      preview: 'Voice message · 0:09',
      time: 'Yesterday',
      initials: 'LE',
      colors: <Color>[Color(0xFFB78AF3), Color(0xFFE4C1FF)],
    ),
    PrivateConversation(
      name: 'Dinner club',
      preview: 'You: Friday works for me',
      time: 'Yesterday',
      initials: 'DC',
      colors: <Color>[Color(0xFFFF7B8F), Color(0xFFFFB0B9)],
      sent: true,
      group: true,
    ),
  ];
}
