enum AssistantSection { chat, discover, profile }

extension AssistantSectionLabel on AssistantSection {
  String get label => switch (this) {
    AssistantSection.chat => 'Chat',
    AssistantSection.discover => 'Discover',
    AssistantSection.profile => 'Profile',
  };
}
