import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';

class AssistantProfileSection extends StatelessWidget {
  const AssistantProfileSection({
    required this.scrollController,
    required this.conciseReplies,
    required this.onConciseRepliesChanged,
    super.key,
  });

  final ScrollController scrollController;
  final bool conciseReplies;
  final ValueChanged<bool> onConciseRepliesChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: <Widget>[
        const _ProfileHeader(),
        const SizedBox(height: 24),
        const Row(
          children: <Widget>[
            Expanded(
              child: _ProfileMetric(value: '18', label: 'Chats'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ProfileMetric(value: '7', label: 'Saved prompts'),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          'SYSTEM PREFERENCES',
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          value: conciseReplies,
          onChanged: onConciseRepliesChanged,
          tileColor: colors.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colors.outlineVariant),
            borderRadius: AiAssistantAppTheme.controlRadius,
          ),
          secondary: const Icon(Icons.short_text_rounded, color: AiAssistantAppTheme.aqua),
          title: const Text('Concise replies', style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: const Text('Prefer focused answers by default.'),
        ),
        const SizedBox(height: 12),
        const _PreferenceTile(icon: Icons.palette_outlined, title: 'Appearance', detail: 'Midnight aurora'),
        const SizedBox(height: 12),
        const _PreferenceTile(icon: Icons.shield_outlined, title: 'Privacy', detail: 'Local sample data only'),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: AiAssistantAppTheme.panelRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            DecoratedBox(
              decoration: const BoxDecoration(color: AiAssistantAppTheme.primary, shape: BoxShape.circle),
              child: SizedBox.square(
                dimension: 70,
                child: Center(
                  child: Text(
                    'AR',
                    style: TextStyle(color: colors.onPrimary, fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'IDENTITY / BUILDER',
                    style: TextStyle(color: colors.secondary, fontSize: 8, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  const Text('Alex Rivera', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text('Curious builder', style: TextStyle(color: colors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: AiAssistantAppTheme.controlRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: colors.primary),
          ),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({required this.icon, required this.title, required this.detail});

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      tileColor: colors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: AiAssistantAppTheme.controlRadius,
      ),
      leading: Icon(icon, color: colors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
