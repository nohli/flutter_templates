import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';

class AssistantDiscoverSection extends StatelessWidget {
  const AssistantDiscoverSection({required this.scrollController, required this.onOpen, super.key});

  final ScrollController scrollController;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: <Widget>[
        const Text(
          'A specialist for every idea.',
          style: TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        const Text(
          'Reusable cards, filters, and responsive layouts for an assistant marketplace.',
          style: TextStyle(color: AiAssistantAppTheme.mutedInk, height: 1.4),
        ),
        const SizedBox(height: 24),
        const _FeaturedAssistant(),
        const SizedBox(height: 28),
        const Text('Explore assistants', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        ..._assistants.map(
          (({Color color, IconData icon, String subtitle, String title}) assistant) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AssistantCard(
              title: assistant.title,
              subtitle: assistant.subtitle,
              icon: assistant.icon,
              color: assistant.color,
              onTap: () => onOpen(assistant.title),
            ),
          ),
        ),
      ],
    );
  }
}

const _assistants = <({Color color, IconData icon, String subtitle, String title})>[
  (
    title: 'Product partner',
    subtitle: 'Turn rough ideas into clear product briefs.',
    icon: Icons.lightbulb_outline_rounded,
    color: AiAssistantAppTheme.pink,
  ),
  (
    title: 'Code guide',
    subtitle: 'Reason through architecture and implementation.',
    icon: Icons.terminal_rounded,
    color: AiAssistantAppTheme.aqua,
  ),
  (
    title: 'Study coach',
    subtitle: 'Break complex topics into memorable lessons.',
    icon: Icons.school_outlined,
    color: AiAssistantAppTheme.lavender,
  ),
];

class _FeaturedAssistant extends StatelessWidget {
  const _FeaturedAssistant();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Color(0xFF392F83), Color(0xFF165D63)]),
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: AiAssistantAppTheme.softShadow,
      ),
      child: const Row(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0x24FFFFFF),
            child: Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.aqua, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Featured',
                  style: TextStyle(color: AiAssistantAppTheme.aqua, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 5),
                Text('Creative studio', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('Words, concepts, and visual directions.', style: TextStyle(color: Color(0xFFD8DAEF))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantCard extends StatelessWidget {
  const _AssistantCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AiAssistantAppTheme.surface,
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.16),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: AiAssistantAppTheme.mutedInk, height: 1.3)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: AiAssistantAppTheme.mutedInk),
            ],
          ),
        ),
      ),
    );
  }
}
