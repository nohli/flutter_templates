import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';

class AssistantIdeaConstellation extends StatefulWidget {
  const AssistantIdeaConstellation({required this.onPromptSelected, super.key});

  final ValueChanged<String> onPromptSelected;

  @override
  State<AssistantIdeaConstellation> createState() => _AssistantIdeaConstellationState();
}

class _AssistantIdeaConstellationState extends State<AssistantIdeaConstellation> {
  static const _ideas = <_IdeaNodeData>[
    _IdeaNodeData(
      label: 'STORY',
      detail: 'Shape the narrative',
      prompt: 'Help me shape a memorable product story',
      icon: Icons.auto_stories_outlined,
      color: AiAssistantAppTheme.pink,
      alignment: Alignment(-0.88, -0.55),
    ),
    _IdeaNodeData(
      label: 'SYSTEM',
      detail: 'Connect the pieces',
      prompt: 'Turn my idea into a clear product system',
      icon: Icons.hub_outlined,
      color: AiAssistantAppTheme.aqua,
      alignment: Alignment(0.92, -0.25),
    ),
    _IdeaNodeData(
      label: 'LAUNCH',
      detail: 'Find the first move',
      prompt: 'Plan the smallest convincing product launch',
      icon: Icons.rocket_launch_outlined,
      color: AiAssistantAppTheme.lavender,
      alignment: Alignment(-0.68, 0.78),
    ),
  ];

  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    if (textScale >= 2) {
      return _AccessibleIdeaList(ideas: _ideas, onSelected: _selectIdea);
    }

    final colors = Theme.of(context).colorScheme;
    final selectedIdea = _ideas[_selectedIndex];
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      key: const Key('idea-constellation'),
      container: true,
      label: 'Interactive idea constellation',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: AiAssistantAppTheme.panelRadius,
          boxShadow: AiAssistantAppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ConstellationHeader(
              selectedColor: selectedIdea.color,
              selectedIndex: _selectedIndex,
              ideaCount: _ideas.length,
            ),
            SizedBox(
              height: 218,
              child: _ConstellationMap(
                ideas: _ideas,
                selectedIndex: _selectedIndex,
                reduceMotion: reduceMotion,
                onSelected: _selectIdea,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectIdea(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onPromptSelected(_ideas[index].prompt);
  }
}

class _ConstellationHeader extends StatelessWidget {
  const _ConstellationHeader({required this.selectedColor, required this.selectedIndex, required this.ideaCount});

  final Color selectedColor;
  final int selectedIndex;
  final int ideaCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Row(
        children: <Widget>[
          Text(
            'THOUGHT MAP / LIVE',
            style: TextStyle(color: colors.secondary, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
          const Spacer(),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: selectedColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '${selectedIndex + 1} / $ideaCount',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ConstellationMap extends StatelessWidget {
  const _ConstellationMap({
    required this.ideas,
    required this.selectedIndex,
    required this.reduceMotion,
    required this.onSelected,
  });

  final List<_IdeaNodeData> ideas;
  final int selectedIndex;
  final bool reduceMotion;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selectedIdea = ideas[selectedIndex];

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned.fill(
          child: CustomPaint(
            painter: _ConstellationPainter(
              lineColor: colors.outlineVariant,
              accentColor: selectedIdea.color,
              selectedIndex: selectedIndex,
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.12, 0.08),
          child: _IdeaFocusCard(data: selectedIdea, reduceMotion: reduceMotion),
        ),
        for (var index = 0; index < ideas.length; index++)
          Align(
            alignment: ideas[index].alignment,
            child: _IdeaNode(
              data: ideas[index],
              selected: index == selectedIndex,
              reduceMotion: reduceMotion,
              onPressed: () => onSelected(index),
            ),
          ),
      ],
    );
  }
}

class _IdeaFocusCard extends StatelessWidget {
  const _IdeaFocusCard({required this.data, required this.reduceMotion});

  final _IdeaNodeData data;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: 126,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        border: Border.all(color: data.color, width: 1.5),
        borderRadius: AiAssistantAppTheme.controlRadius,
        boxShadow: <BoxShadow>[BoxShadow(color: data.color.withValues(alpha: 0.18), blurRadius: 22)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data.label,
            key: const Key('selected-idea-label'),
            style: TextStyle(
              color: data.color,
              fontFamily: AiAssistantAppTheme.displayFontName,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(data.detail, style: TextStyle(color: colors.onSurface, fontSize: 11, height: 1.2)),
          const SizedBox(height: 9),
          Text(
            'TAP A SIGNAL',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 7,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdeaNode extends StatelessWidget {
  const _IdeaNode({required this.data, required this.selected, required this.reduceMotion, required this.onPressed});

  final _IdeaNodeData data;
  final bool selected;
  final bool reduceMotion;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: selected ? 1.06 : 1,
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      child: Semantics(
        key: Key('idea-node-${data.label.toLowerCase()}'),
        button: true,
        selected: selected,
        label: '${data.label}: ${data.detail}',
        child: Material(
          color: selected ? data.color : colors.surfaceContainerHighest,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 58,
              height: 58,
              child: Icon(data.icon, color: selected ? AiAssistantAppTheme.background : colors.onSurface, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessibleIdeaList extends StatelessWidget {
  const _AccessibleIdeaList({required this.ideas, required this.onSelected});

  final List<_IdeaNodeData> ideas;
  final ValueChanged<int> onSelected;

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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'THOUGHT MAP',
              style: TextStyle(color: colors.secondary, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < ideas.length; index++) ...<Widget>[
              OutlinedButton(
                onPressed: () => onSelected(index),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(14),
                  shape: const RoundedRectangleBorder(borderRadius: AiAssistantAppTheme.controlRadius),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(ideas[index].icon, color: ideas[index].color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(ideas[index].label, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text(ideas[index].detail, style: TextStyle(color: colors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index != ideas.length - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  const _ConstellationPainter({required this.lineColor, required this.accentColor, required this.selectedIndex});

  final Color lineColor;
  final Color accentColor;
  final int selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.56, size.height * 0.53);
    final nodes = <Offset>[
      Offset(size.width * 0.1, size.height * 0.225),
      Offset(size.width * 0.96, size.height * 0.375),
      Offset(size.width * 0.2, size.height * 0.89),
    ];
    final routePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final activePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    for (var index = 0; index < nodes.length; index++) {
      final control = Offset(
        (center.dx + nodes[index].dx) / 2 + math.sin(index * 2.2) * 22,
        (center.dy + nodes[index].dy) / 2 - 18,
      );
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..quadraticBezierTo(control.dx, control.dy, nodes[index].dx, nodes[index].dy);
      canvas.drawPath(path, index == selectedIndex ? activePaint : routePaint);
    }

    final dust = Paint()..color = lineColor.withValues(alpha: 0.75);
    for (final point in <Offset>[
      Offset(size.width * 0.35, size.height * 0.18),
      Offset(size.width * 0.78, size.height * 0.76),
      Offset(size.width * 0.42, size.height * 0.83),
      Offset(size.width * 0.86, size.height * 0.12),
    ]) {
      canvas.drawCircle(point, 1.5, dust);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

class _IdeaNodeData {
  const _IdeaNodeData({
    required this.label,
    required this.detail,
    required this.prompt,
    required this.icon,
    required this.color,
    required this.alignment,
  });

  final String label;
  final String detail;
  final String prompt;
  final IconData icon;
  final Color color;
  final Alignment alignment;
}
