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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
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
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    if (largeText) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: AiAssistantAppTheme.raisedSurface),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'NOVA / CREATIVE ORBIT',
                style: TextStyle(color: AiAssistantAppTheme.aqua, fontSize: 8, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 14),
              Text(
                'Ideas have gravity.',
                style: TextStyle(
                  color: AiAssistantAppTheme.ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                ),
              ),
              SizedBox(height: 12),
              Text('What can I help you create?', style: TextStyle(color: AiAssistantAppTheme.mutedInk, fontSize: 11)),
            ],
          ),
        ),
      );
    }

    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return SizedBox(
      height: 212,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AiAssistantAppTheme.raisedSurface,
          boxShadow: AiAssistantAppTheme.softShadow,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -20,
              top: -18,
              width: 210,
              height: 210,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: -0.12, end: 0),
                duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.rotate(angle: value, child: child);
                },
                child: const CustomPaint(painter: _OrbitPainter()),
              ),
            ),
            const Positioned(
              left: 17,
              top: 15,
              child: Text(
                'NOVA / CREATIVE ORBIT',
                style: TextStyle(
                  color: AiAssistantAppTheme.aqua,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Positioned(
              left: 17,
              bottom: 53,
              child: Text(
                'IDEAS HAVE\nGRAVITY.',
                style: TextStyle(
                  color: AiAssistantAppTheme.ink,
                  fontFamily: AiAssistantAppTheme.displayFontName,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  height: 0.9,
                ),
              ),
            ),
            const Positioned(
              left: 17,
              bottom: 18,
              child: Text(
                'What can I help you create?',
                style: TextStyle(color: AiAssistantAppTheme.mutedInk, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.54, size.height * 0.48);
    final orbit = Paint()
      ..color = AiAssistantAppTheme.aqua.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final radius in <double>[34, 58, 82]) {
      canvas.drawOval(Rect.fromCenter(center: center, width: radius * 2, height: radius * 1.1), orbit);
    }
    canvas.drawCircle(center, 20, Paint()..color = AiAssistantAppTheme.primary);
    canvas.drawCircle(Offset(center.dx + 70, center.dy), 7, Paint()..color = AiAssistantAppTheme.pink);
    canvas.drawCircle(Offset(center.dx - 42, center.dy - 24), 5, Paint()..color = AiAssistantAppTheme.aqua);
    canvas.drawCircle(Offset(center.dx + 20, center.dy + 42), 4, Paint()..color = AiAssistantAppTheme.lavender);
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) => false;
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
              shape: const RoundedRectangleBorder(),
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
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
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
            border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
            suffixIcon: IconButton.filled(
              tooltip: 'Send message',
              onPressed: onSend,
              style: IconButton.styleFrom(shape: const RoundedRectangleBorder()),
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
