import 'package:flutter/material.dart';
import '../../../../l10n/localizations.dart';

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

  static List<SocialPost> samples(AppLocalizations l10n) => <SocialPost>[
    SocialPost(
      author: 'Mara Chen',
      handle: '@maracodes',
      initials: 'MC',
      body: l10n.smallInterfacesBecomeMemorableWhenEveryMotionExplainsWhereThe,
      time: l10n.sample4m,
      topic: l10n.designSystems,
      replies: 18,
      reposts: 42,
      likes: 386,
      avatarColors: <Color>[const Color(0xFFFFB86B), const Color(0xFFFF5E87)],
    ),
    SocialPost(
      author: 'Field Notes',
      handle: '@fieldnotes',
      initials: 'FN',
      body: l10n.theNightTrainIsQuietThePrototypeIsFinallyBehaving,
      time: l10n.sample27m,
      topic: l10n.liveFromCopenhagen,
      replies: 31,
      reposts: 77,
      likes: 924,
      avatarColors: <Color>[const Color(0xFF466DFF), const Color(0xFF7DE3FF)],
    ),
    SocialPost(
      author: 'Noah Williams',
      handle: '@northbound',
      initials: 'NW',
      body: l10n.aGoodCommunityFeelsLessLikeAnAudienceAndMore,
      time: l10n.sample1h,
      replies: 12,
      reposts: 24,
      likes: 201,
      avatarColors: <Color>[const Color(0xFF80D6A3), const Color(0xFF1A936F)],
    ),
  ];
}
