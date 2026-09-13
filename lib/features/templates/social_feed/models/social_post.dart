import 'package:flutter/material.dart';

class SocialPost {
  const SocialPost({
    required this.author,
    required this.handle,
    required this.initials,
    required this.body,
    required this.time,
    required this.replies,
    required this.reposts,
    required this.likes,
    required this.avatarColors,
    this.topic,
  });

  final String author;
  final String handle;
  final String initials;
  final String body;
  final String time;
  final String? topic;
  final int replies;
  final int reposts;
  final int likes;
  final List<Color> avatarColors;

  static const samples = <SocialPost>[
    SocialPost(
      author: 'Mara Chen',
      handle: '@maracodes',
      initials: 'MC',
      body: 'Small interfaces become memorable when every motion explains where the content came from.',
      time: '4m',
      topic: 'Design systems',
      replies: 18,
      reposts: 42,
      likes: 386,
      avatarColors: <Color>[Color(0xFFFFB86B), Color(0xFFFF5E87)],
    ),
    SocialPost(
      author: 'Field Notes',
      handle: '@fieldnotes',
      initials: 'FN',
      body: 'The night train is quiet, the prototype is finally behaving, and the city is turning blue outside.',
      time: '27m',
      topic: 'Live from Copenhagen',
      replies: 31,
      reposts: 77,
      likes: 924,
      avatarColors: <Color>[Color(0xFF466DFF), Color(0xFF7DE3FF)],
    ),
    SocialPost(
      author: 'Noah Williams',
      handle: '@northbound',
      initials: 'NW',
      body: 'A good community feels less like an audience and more like a table with one chair left open.',
      time: '1h',
      replies: 12,
      reposts: 24,
      likes: 201,
      avatarColors: <Color>[Color(0xFF80D6A3), Color(0xFF1A936F)],
    ),
  ];
}
