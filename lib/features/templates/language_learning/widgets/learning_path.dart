import 'package:flutter/material.dart';

class LearningPath extends StatelessWidget {
  const LearningPath({required this.onLessonPressed, super.key});

  final VoidCallback onLessonPressed;

  @override
  Widget build(BuildContext context) {
    const nodes = <({Alignment alignment, IconData icon, bool active, String label})>[
      (alignment: Alignment(-0.15, 0), icon: Icons.check_rounded, active: true, label: 'Greetings complete'),
      (alignment: Alignment(0.32, 0), icon: Icons.chat_bubble_rounded, active: true, label: 'Start ordering food'),
      (alignment: Alignment(0.08, 0), icon: Icons.auto_stories_rounded, active: false, label: 'Read a short story'),
      (alignment: Alignment(-0.36, 0), icon: Icons.headphones_rounded, active: false, label: 'Listen and repeat'),
      (alignment: Alignment(-0.08, 0), icon: Icons.lock_rounded, active: false, label: 'Checkpoint locked'),
    ];

    return Column(
      children: <Widget>[
        for (var index = 0; index < nodes.length; index++) ...<Widget>[
          Align(
            alignment: nodes[index].alignment,
            child: _LessonNode(
              icon: nodes[index].icon,
              active: nodes[index].active,
              current: index == 1,
              label: nodes[index].label,
              onPressed: index == 1 ? onLessonPressed : null,
            ),
          ),
          if (index != nodes.length - 1)
            SizedBox(
              height: index == 1 ? 34 : 22,
              child: const Center(child: _DottedConnector()),
            ),
        ],
      ],
    );
  }
}

class _LessonNode extends StatelessWidget {
  const _LessonNode({
    required this.icon,
    required this.active,
    required this.current,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final bool active;
  final bool current;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fill = active ? colors.primary : colors.surface;
    final shadow = active ? colors.primary.withValues(alpha: 0.42) : colors.outlineVariant;
    final node = Semantics(
      label: label,
      button: onPressed != null,
      child: GestureDetector(
        key: current ? const ValueKey<String>('language-current-lesson') : null,
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: current ? 82 : 68,
          height: current ? 72 : 60,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: const BorderRadius.all(Radius.circular(26)),
            border: Border.all(color: active ? colors.primary : colors.outlineVariant, width: 2),
            boxShadow: <BoxShadow>[BoxShadow(color: shadow, offset: const Offset(0, 7), blurRadius: 0)],
          ),
          child: Icon(icon, color: active ? colors.onPrimary : colors.outline, size: current ? 34 : 28),
        ),
      ),
    );

    if (!current) {
      return Padding(padding: const EdgeInsets.only(bottom: 7), child: node);
    }
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: colors.onSurface, borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: Text(
            'START HERE',
            style: TextStyle(color: colors.surface, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
        ),
        const SizedBox(height: 10),
        node,
      ],
    );
  }
}

class _DottedConnector extends StatelessWidget {
  const _DottedConnector();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(2, 30), painter: _DottedConnectorPainter(Theme.of(context).dividerColor));
  }
}

class _DottedConnectorPainter extends CustomPainter {
  const _DottedConnectorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var y = 1.0; y < size.height; y += 7) {
      canvas.drawCircle(Offset(size.width / 2, y), 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DottedConnectorPainter oldDelegate) => oldDelegate.color != color;
}
