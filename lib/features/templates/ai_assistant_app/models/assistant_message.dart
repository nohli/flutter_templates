enum AssistantMessageRole { assistant, user }

class AssistantMessage {
  const AssistantMessage({required this.id, required this.role, required this.text});

  final String id;
  final AssistantMessageRole role;
  final String text;

  static const welcome = AssistantMessage(
    id: 'welcome',
    role: AssistantMessageRole.assistant,
    text: 'Tell me what you want to make, understand, or plan.',
  );
}
