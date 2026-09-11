import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';
import '../models/assistant_message.dart';
import '../widgets/assistant_message_bubble.dart';

class AssistantChatSection extends StatelessWidget {
  const AssistantChatSection({
    required this.messages,
    required this.composer,
    required this.scrollController,
    required this.onPromptSelected,
    required this.onSend,
    super.key,
  });

  final List<AssistantMessage> messages;
  final TextEditingController composer;
  final ScrollController scrollController;
  final ValueChanged<String> onPromptSelected;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            children: <Widget>[
              const _AssistantHero(),
              const SizedBox(height: 20),
              _PromptSuggestions(onSelected: onPromptSelected),
              const SizedBox(height: 24),
              ...messages.map((AssistantMessage message) => AssistantMessageBubble(message: message)),
            ],
          ),
        ),
        _Composer(controller: composer, onSend: onSend),
      ],
    );
  }
}

class _AssistantHero extends StatelessWidget {
  const _AssistantHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF503FBB), Color(0xFF1C6673)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: AiAssistantAppTheme.softShadow,
      ),
      child: const Stack(
        children: <Widget>[
          Positioned(right: -22, top: -30, child: _GlowOrb(size: 126, color: Color(0x3366E0D2))),
          Positioned(left: 96, bottom: -54, child: _GlowOrb(size: 110, color: Color(0x338C7CFF))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _NovaMark(),
              SizedBox(height: 28),
              Text(
                'What can I help you create?',
                style: TextStyle(fontSize: 32, height: 1.05, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12),
              Text('A thoughtful local interface preview.', style: TextStyle(color: Color(0xFFD8DAEF))),
            ],
          ),
        ],
      ),
    );
  }
}

class _NovaMark extends StatelessWidget {
  const _NovaMark();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          radius: 18,
          backgroundColor: Color(0x33FFFFFF),
          child: Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.aqua),
        ),
        SizedBox(width: 10),
        Text('Nova', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.2)),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: SizedBox.square(dimension: size),
  );
}

class _PromptSuggestions extends StatelessWidget {
  const _PromptSuggestions({required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _prompts = <({IconData icon, String label, Color color})>[
    (icon: Icons.draw_outlined, label: 'Sketch a launch plan', color: AiAssistantAppTheme.pink),
    (icon: Icons.code_rounded, label: 'Explain a code sample', color: AiAssistantAppTheme.aqua),
    (icon: Icons.travel_explore_rounded, label: 'Research an idea', color: AiAssistantAppTheme.lavender),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: _prompts
          .map(
            (({Color color, IconData icon, String label}) prompt) => ActionChip(
              avatar: Icon(prompt.icon, color: prompt.color, size: 18),
              label: Text(prompt.label),
              onPressed: () => onSelected(prompt.label),
              backgroundColor: colors.surface,
              side: BorderSide(color: colors.outlineVariant),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: 4,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => onSend(),
        decoration: InputDecoration(
          hintText: 'Message Nova',
          prefixIcon: const Icon(Icons.add_circle_outline_rounded),
          suffixIcon: IconButton.filled(
            tooltip: 'Send message',
            onPressed: onSend,
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
        ),
      ),
    );
  }
}
