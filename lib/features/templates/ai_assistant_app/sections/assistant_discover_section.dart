import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';

class AssistantDiscoverSection extends StatelessWidget {
  const AssistantDiscoverSection({required this.scrollController, required this.onOpen, super.key});

  final ScrollController scrollController;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: <Widget>[
        const Text(
          'CHOOSE A\nNEW MIND.',
          style: TextStyle(
            fontFamily: AiAssistantAppTheme.displayFontName,
            fontSize: 33,
            height: 0.9,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A modular assistant constellation for every kind of work.',
          style: TextStyle(color: colors.onSurfaceVariant, height: 1.4),
        ),
        const SizedBox(height: 24),
        const _FeaturedAssistant(),
        const SizedBox(height: 28),
        const Text(
          'AVAILABLE MODULES / 03',
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
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
        color: AiAssistantAppTheme.raisedSurface,
        border: Border.fromBorderSide(BorderSide(color: AiAssistantAppTheme.aqua)),
        boxShadow: AiAssistantAppTheme.softShadow,
      ),
      child: const Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(color: AiAssistantAppTheme.primary),
            child: SizedBox.square(
              dimension: 60,
              child: Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.ink, size: 28),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'FEATURED / 00',
                  style: TextStyle(color: AiAssistantAppTheme.aqua, fontSize: 8, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 5),
                Text(
                  'Creative studio',
                  style: TextStyle(
                    color: AiAssistantAppTheme.ink,
                    fontFamily: AiAssistantAppTheme.displayFontName,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
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
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(side: BorderSide(color: colors.outlineVariant)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  border: Border.all(color: color),
                ),
                child: SizedBox.square(dimension: 48, child: Icon(icon, color: color)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: colors.onSurfaceVariant, height: 1.3)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
