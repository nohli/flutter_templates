enum SocialSection { feed, discover, profile }

extension SocialSectionLabel on SocialSection {
  String get label => switch (this) {
    SocialSection.feed => 'Feed',
    SocialSection.discover => 'Discover',
    SocialSection.profile => 'Profile',
  };
}
