import 'package:flutter/material.dart';

import 'finance_entrance.dart';

class FinanceQuickActions extends StatelessWidget {
  const FinanceQuickActions({required this.animation, required this.onSelected, super.key});

  final Animation<double> animation;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return FinanceEntrance(
      animation: animation,
      index: 2,
      child: usesLargeText ? _AccessibleActions(onSelected: onSelected) : _TransferOrbit(onSelected: onSelected),
    );
  }
}

class _TransferOrbit extends StatelessWidget {
  const _TransferOrbit({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 154,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(flex: 5, child: _PrimaryOrbitAction(onSelected: onSelected)),
          const SizedBox(width: 9),
          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _SatelliteAction(
                    label: 'Add money',
                    code: '02 / FUND',
                    icon: Icons.add_rounded,
                    accent: colors.primary,
                    onSelected: onSelected,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _SatelliteAction(
                          label: 'Request',
                          code: '03',
                          icon: Icons.south_west_rounded,
                          accent: colors.secondary,
                          compact: true,
                          onSelected: onSelected,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SatelliteAction(
                          label: 'More',
                          code: '04',
                          icon: Icons.more_horiz_rounded,
                          accent: colors.onSurfaceVariant,
                          compact: true,
                          onSelected: onSelected,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryOrbitAction extends StatelessWidget {
  const _PrimaryOrbitAction({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: 'Send',
      onTap: () => onSelected('Send'),
      child: ExcludeSemantics(
        child: Material(
          color: colors.onSurface,
          borderRadius: const BorderRadius.all(Radius.circular(9)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onSelected('Send'),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(painter: _OrbitActionPainter(accent: colors.secondary)),
                ),
                Positioned(
                  left: 12,
                  top: 10,
                  child: Text(
                    '01 / TRANSFER',
                    style: TextStyle(
                      color: colors.surface.withValues(alpha: 0.62),
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(color: colors.secondary, shape: BoxShape.circle),
                    child: Icon(Icons.arrow_outward_rounded, color: colors.onSecondary, size: 28),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 10,
                  child: Text(
                    'SEND',
                    style: TextStyle(
                      color: colors.surface,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SatelliteAction extends StatelessWidget {
  const _SatelliteAction({
    required this.label,
    required this.code,
    required this.icon,
    required this.accent,
    required this.onSelected,
    this.compact = false,
  });

  final String label;
  final String code;
  final IconData icon;
  final Color accent;
  final ValueChanged<String> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: label,
      onTap: () => onSelected(label),
      child: ExcludeSemantics(
        child: Material(
          color: colors.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onSelected(label),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(code, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 7)),
                            const Spacer(),
                            Icon(icon, color: accent, size: 18),
                          ],
                        ),
                        Text(
                          label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(color: colors.onSurface, fontSize: 8, fontWeight: FontWeight.w900),
                        ),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Icon(icon, color: accent, size: 21),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(code, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 7)),
                              const SizedBox(height: 3),
                              Text(
                                label.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(color: colors.onSurface, fontSize: 9, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: accent, size: 16),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessibleActions extends StatelessWidget {
  const _AccessibleActions({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const actions = <({String label, IconData icon})>[
      (label: 'Send', icon: Icons.arrow_outward_rounded),
      (label: 'Add money', icon: Icons.add_rounded),
      (label: 'Request', icon: Icons.south_west_rounded),
      (label: 'More', icon: Icons.more_horiz_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final action in actions) ...<Widget>[
          OutlinedButton.icon(
            onPressed: () => onSelected(action.label),
            icon: Icon(action.icon),
            label: Text(action.label),
          ),
          if (action != actions.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _OrbitActionPainter extends CustomPainter {
  const _OrbitActionPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.56, size.height * 0.5);
    final orbit = Paint()
      ..color = accent.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final radius in <double>[38, 55, 72]) {
      canvas.drawOval(Rect.fromCenter(center: center, width: radius * 2, height: radius * 1.15), orbit);
    }
    canvas.drawCircle(Offset(center.dx - 52, center.dy - 22), 3.5, Paint()..color = accent);
    canvas.drawCircle(Offset(center.dx + 48, center.dy + 28), 2.5, Paint()..color = accent.withValues(alpha: 0.65));
  }

  @override
  bool shouldRepaint(covariant _OrbitActionPainter oldDelegate) => oldDelegate.accent != accent;
}
