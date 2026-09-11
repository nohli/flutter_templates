import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';

class AssistantGalleryPreview extends StatelessWidget {
  const AssistantGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Nova assistant workspace preview',
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF0B0E20), Color(0xFF17142F), Color(0xFF0D2630)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: CustomPaint(painter: _AuroraBackdropPainter())),
            Positioned(left: 13, top: 11, child: _NovaHeader()),
            Positioned(left: 13, top: 40, right: 68, child: _AssistantAnswer()),
            Positioned(right: 12, top: 30, child: _PromptStack()),
            Positioned(left: 13, right: 13, bottom: 11, child: _PreviewComposer()),
          ],
        ),
      ),
    );
  }
}

class _NovaHeader extends StatelessWidget {
  const _NovaHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[AiAssistantAppTheme.primary, AiAssistantAppTheme.aqua]),
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: SizedBox.square(
            dimension: 22,
            child: Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.background, size: 12),
          ),
        ),
        SizedBox(width: 7),
        Text(
          'Nova',
          style: TextStyle(color: AiAssistantAppTheme.ink, fontSize: 10, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _AssistantAnswer extends StatelessWidget {
  const _AssistantAnswer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AiAssistantAppTheme.surface.withValues(alpha: 0.9),
        border: Border.all(color: const Color(0xFF353A5A)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Let’s shape the idea.',
            style: TextStyle(color: AiAssistantAppTheme.ink, fontSize: 8, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6),
          _AnswerLine(width: 92),
          SizedBox(height: 4),
          _AnswerLine(width: 76),
          SizedBox(height: 4),
          _AnswerLine(width: 58),
          SizedBox(height: 9),
          Row(
            children: <Widget>[
              Icon(Icons.copy_all_outlined, color: AiAssistantAppTheme.mutedInk, size: 8),
              SizedBox(width: 7),
              Icon(Icons.thumb_up_alt_outlined, color: AiAssistantAppTheme.mutedInk, size: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: const BoxDecoration(color: Color(0xFF596078), borderRadius: BorderRadius.all(Radius.circular(99))),
    );
  }
}

class _PromptStack extends StatelessWidget {
  const _PromptStack();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _PromptCard(icon: Icons.draw_outlined, color: AiAssistantAppTheme.pink),
        SizedBox(height: 6),
        _PromptCard(icon: Icons.code_rounded, color: AiAssistantAppTheme.aqua),
        SizedBox(height: 6),
        _PromptCard(icon: Icons.lightbulb_outline_rounded, color: AiAssistantAppTheme.lavender),
      ],
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 25,
      decoration: const BoxDecoration(color: Color(0xCC202744), borderRadius: BorderRadius.all(Radius.circular(9))),
      child: Icon(icon, color: color, size: 12),
    );
  }
}

class _PreviewComposer extends StatelessWidget {
  const _PreviewComposer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
      decoration: const BoxDecoration(
        color: AiAssistantAppTheme.raisedSurface,
        borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: Text('Message Nova', style: TextStyle(color: AiAssistantAppTheme.mutedInk, fontSize: 5.5)),
          ),
          CircleAvatar(
            radius: 10,
            backgroundColor: AiAssistantAppTheme.primary,
            child: Icon(Icons.arrow_upward_rounded, size: 11, color: AiAssistantAppTheme.background),
          ),
        ],
      ),
    );
  }
}

class _AuroraBackdropPainter extends CustomPainter {
  const _AuroraBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final violet = Path()
      ..moveTo(-20, size.height * 0.18)
      ..cubicTo(size.width * 0.28, -20, size.width * 0.48, size.height * 0.5, size.width + 20, size.height * 0.18)
      ..lineTo(size.width + 20, -20)
      ..lineTo(-20, -20)
      ..close();
    canvas.drawPath(violet, Paint()..color = const Color(0x338C7CFF));

    final aqua = Path()
      ..moveTo(-20, size.height * 0.82)
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.48,
        size.width * 0.66,
        size.height * 1.08,
        size.width + 20,
        size.height * 0.62,
      )
      ..lineTo(size.width + 20, size.height + 20)
      ..lineTo(-20, size.height + 20)
      ..close();
    canvas.drawPath(aqua, Paint()..color = const Color(0x2866E0D2));
  }

  @override
  bool shouldRepaint(covariant _AuroraBackdropPainter oldDelegate) => false;
}
