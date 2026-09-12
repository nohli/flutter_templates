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
        decoration: BoxDecoration(color: dark ? AiAssistantAppTheme.background : const Color(0xFFF3EFFB)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _SpatialBackdropPainter(dark: dark)),
            ),
            Positioned(left: 13, top: 11, child: _NovaHeader(dark: dark)),
            Positioned(left: 13, top: 38, right: 13, bottom: 44, child: _IdeaMapPreview(dark: dark)),
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
        Text(
          'Nova',
          style: TextStyle(
            color: dark ? AiAssistantAppTheme.ink : const Color(0xFF171521),
            fontFamily: AiAssistantAppTheme.displayFontName,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 7),
        const Text(
          'SPATIAL / 01',
          style: TextStyle(color: AiAssistantAppTheme.aqua, fontSize: 4.5, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _IdeaMapPreview extends StatelessWidget {
  const _IdeaMapPreview({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final surface = dark ? AiAssistantAppTheme.surface : Colors.white;
    final ink = dark ? AiAssistantAppTheme.ink : const Color(0xFF171521);
    final divider = dark ? const Color(0xFF30384C) : const Color(0xFFD9D3E5);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: divider),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x26000000), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(painter: _IdeaRoutesPainter(color: divider)),
          ),
          const Positioned(
            left: 8,
            top: 7,
            child: Text(
              'THOUGHT MAP / LIVE',
              style: TextStyle(color: AiAssistantAppTheme.aqua, fontSize: 4.5, fontWeight: FontWeight.w900),
            ),
          ),
          Positioned(
            left: 15,
            top: 35,
            child: _SignalNode(color: AiAssistantAppTheme.pink, icon: Icons.auto_stories_outlined, dark: dark),
          ),
          Positioned(
            right: 15,
            top: 47,
            child: _SignalNode(color: AiAssistantAppTheme.aqua, icon: Icons.hub_outlined, dark: dark),
          ),
          Positioned(
            left: 50,
            bottom: 9,
            child: _SignalNode(color: AiAssistantAppTheme.lavender, icon: Icons.rocket_launch_outlined, dark: dark),
          ),
          Center(
            child: Container(
              width: 72,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: surface,
                border: Border.all(color: AiAssistantAppTheme.pink),
                borderRadius: const BorderRadius.all(Radius.circular(7)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'STORY',
                    style: TextStyle(color: AiAssistantAppTheme.pink, fontSize: 7, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text('Shape the narrative', style: TextStyle(color: ink, fontSize: 5.5, height: 1.1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalNode extends StatelessWidget {
  const _SignalNode({required this.color, required this.icon, required this.dark});

  final Color color;
  final IconData icon;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: SizedBox.square(
        dimension: 25,
        child: Icon(icon, color: dark ? AiAssistantAppTheme.background : const Color(0xFF171521), size: 12),
      ),
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
        border: Border.all(color: dark ? AiAssistantAppTheme.divider : const Color(0xFFD9D3E5)),
        borderRadius: const BorderRadius.all(Radius.circular(9)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Message Nova',
              style: TextStyle(color: dark ? AiAssistantAppTheme.mutedInk : const Color(0xFF706F7B), fontSize: 5.5),
            ),
          ),
          const SizedBox.square(
            dimension: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AiAssistantAppTheme.primary, shape: BoxShape.circle),
              child: Icon(Icons.arrow_upward_rounded, size: 11, color: AiAssistantAppTheme.background),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpatialBackdropPainter extends CustomPainter {
  const _SpatialBackdropPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (dark ? AiAssistantAppTheme.aqua : const Color(0xFF6247D6)).withValues(alpha: 0.08)
      ..strokeWidth = 0.5;
    for (var x = 0.0; x < size.width; x += 22) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpatialBackdropPainter oldDelegate) => dark != oldDelegate.dark;
}

class _IdeaRoutesPainter extends CustomPainter {
  const _IdeaRoutesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    final center = Offset(size.width * 0.5, size.height * 0.53);
    for (final target in <Offset>[
      Offset(size.width * 0.14, size.height * 0.46),
      Offset(size.width * 0.86, size.height * 0.56),
      Offset(size.width * 0.31, size.height * 0.88),
    ]) {
      canvas.drawLine(center, target, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IdeaRoutesPainter oldDelegate) => color != oldDelegate.color;
}
