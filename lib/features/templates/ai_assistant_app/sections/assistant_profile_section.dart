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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
        const Text('Preferences', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          value: conciseReplies,
          onChanged: onConciseRepliesChanged,
          tileColor: colors.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
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

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 38,
          backgroundColor: colors.primaryContainer,
          child: Text(
            'AR',
            style: TextStyle(color: colors.onPrimaryContainer, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Alex Rivera', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Curious builder', style: TextStyle(color: colors.onSurfaceVariant)),
            ],
          ),
        ),
      ],
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
      decoration: BoxDecoration(color: colors.surface, borderRadius: const BorderRadius.all(Radius.circular(22))),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      leading: Icon(icon, color: colors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
