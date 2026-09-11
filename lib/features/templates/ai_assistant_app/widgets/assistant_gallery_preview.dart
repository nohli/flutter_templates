import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';

class AssistantGalleryPreview extends StatelessWidget {
  const AssistantGalleryPreview({this.brightness = Brightness.dark, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Nova assistant workspace preview',
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? const <Color>[Color(0xFF0B0E20), Color(0xFF17142F), Color(0xFF0D2630)]
                : const <Color>[Color(0xFFF3EFFB), Color(0xFFE6E0FF), Color(0xFFDDF8F2)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _AuroraBackdropPainter(dark: dark)),
            ),
            Positioned(left: 13, top: 11, child: _NovaHeader(dark: dark)),
            Positioned(left: 13, top: 40, right: 68, child: _AssistantAnswer(dark: dark)),
            Positioned(right: 12, top: 30, child: _PromptStack(dark: dark)),
            Positioned(left: 13, right: 13, bottom: 11, child: _PreviewComposer(dark: dark)),
          ],
        ),
      ),
    );
  }
}

class _NovaHeader extends StatelessWidget {
  const _NovaHeader({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[AiAssistantAppTheme.primary, AiAssistantAppTheme.aqua]),
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: SizedBox.square(
            dimension: 22,
            child: Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.background, size: 12),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          'Nova',
          style: TextStyle(
            color: dark ? AiAssistantAppTheme.ink : const Color(0xFF171521),
            fontFamily: AiAssistantAppTheme.displayFontName,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AssistantAnswer extends StatelessWidget {
  const _AssistantAnswer({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: dark ? AiAssistantAppTheme.surface.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
        border: Border.all(color: dark ? const Color(0xFF353A5A) : const Color(0xFFCBC4DE)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Let’s shape the idea.',
            style: TextStyle(
              color: dark ? AiAssistantAppTheme.ink : const Color(0xFF171521),
              fontFamily: AiAssistantAppTheme.fontName,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _AnswerLine(width: 92, dark: dark),
          const SizedBox(height: 4),
          _AnswerLine(width: 76, dark: dark),
          const SizedBox(height: 4),
          _AnswerLine(width: 58, dark: dark),
          const SizedBox(height: 9),
          const Row(
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
  const _AnswerLine({required this.width, required this.dark});

  final double width;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF596078) : const Color(0xFF918AA4),
        borderRadius: const BorderRadius.all(Radius.circular(99)),
      ),
    );
  }
}

class _PromptStack extends StatelessWidget {
  const _PromptStack({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _PromptCard(icon: Icons.draw_outlined, color: AiAssistantAppTheme.pink, dark: dark),
        const SizedBox(height: 6),
        _PromptCard(icon: Icons.code_rounded, color: AiAssistantAppTheme.aqua, dark: dark),
        const SizedBox(height: 6),
        _PromptCard(icon: Icons.lightbulb_outline_rounded, color: AiAssistantAppTheme.lavender, dark: dark),
      ],
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.icon, required this.color, required this.dark});

  final IconData icon;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 25,
      decoration: BoxDecoration(
        color: dark ? const Color(0xCC202744) : const Color(0xE6FFFFFF),
        borderRadius: const BorderRadius.all(Radius.circular(9)),
      ),
      child: Icon(icon, color: color, size: 12),
    );
  }
}

class _PreviewComposer extends StatelessWidget {
  const _PreviewComposer({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
      decoration: BoxDecoration(
        color: dark ? AiAssistantAppTheme.raisedSurface : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Message Nova',
              style: TextStyle(color: dark ? AiAssistantAppTheme.mutedInk : const Color(0xFF706F7B), fontSize: 5.5),
            ),
          ),
          const CircleAvatar(
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
  const _AuroraBackdropPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final violet = Path()
      ..moveTo(-20, size.height * 0.18)
      ..cubicTo(size.width * 0.28, -20, size.width * 0.48, size.height * 0.5, size.width + 20, size.height * 0.18)
      ..lineTo(size.width + 20, -20)
      ..lineTo(-20, -20)
      ..close();
    canvas.drawPath(violet, Paint()..color = dark ? const Color(0x338C7CFF) : const Color(0x556247D6));

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
    canvas.drawPath(aqua, Paint()..color = dark ? const Color(0x2866E0D2) : const Color(0x445CF1D4));
  }

  @override
  bool shouldRepaint(covariant _AuroraBackdropPainter oldDelegate) => dark != oldDelegate.dark;
}
