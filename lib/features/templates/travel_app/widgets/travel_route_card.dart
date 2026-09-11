import 'package:flutter/material.dart';

import '../travel_app_theme.dart';

class TravelRouteCard extends StatelessWidget {
  const TravelRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.textScalerOf(context).scale(1) >= 2) {
      return const _AccessibleRouteCard();
    }

    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final mapInk = dark ? const Color(0xFF8AD8CA) : TravelAppTheme.ocean;

    return SizedBox(
      height: 274,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF173B36) : TravelAppTheme.seaGlass,
          border: Border.all(color: mapInk, width: 1.5),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _AtlasPainter(ink: mapInk)),
            ),
            Positioned(
              left: 14,
              top: 12,
              child: Text(
                'ISLAND ROUTE / 03 DAYS',
                style: TextStyle(color: mapInk, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.1),
              ),
            ),
            const Positioned(
              right: 12,
              top: 11,
              child: DecoratedBox(
                decoration: BoxDecoration(color: TravelAppTheme.sun),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    '18–21 OCT',
                    style: TextStyle(color: TravelAppTheme.ink, fontSize: 8, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            Positioned(right: 72, top: 60, child: Icon(Icons.flight_rounded, color: mapInk, size: 24)),
            Positioned(left: 12, right: 12, bottom: 12, child: _BoardingPass(colors: colors)),
          ],
        ),
      ),
    );
  }
}

class _BoardingPass extends StatelessWidget {
  const _BoardingPass({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.onSurface, width: 1.5),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x3317352F), offset: Offset(5, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 11),
        child: Column(
          children: <Widget>[
            const Row(
              children: <Widget>[
                _Airport(code: 'LIS', city: 'Lisbon'),
                Expanded(child: _TicketRoute()),
                _Airport(code: 'FNC', city: 'Madeira', alignEnd: true),
              ],
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: colors.outlineVariant),
            const SizedBox(height: 8),
            const Row(
              children: <Widget>[
                Expanded(
                  child: _RouteDetail(label: 'DEPART', value: '18 Oct · 07:05'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _RouteDetail(label: 'STAY', value: 'Funchal · Room 4'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessibleRouteCard extends StatelessWidget {
  const _AccessibleRouteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: TravelAppTheme.ink),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ISLAND ROUTE / 03 DAYS',
            style: TextStyle(color: TravelAppTheme.sun, fontSize: 9, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 14),
          Text(
            'Lisbon to Madeira',
            style: TextStyle(color: TravelAppTheme.surface, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 18),
          _RouteDetail(label: 'DEPART', value: '18 Oct · 07:05', light: true),
          SizedBox(height: 14),
          _RouteDetail(label: 'STAY', value: 'Funchal · Room 4', light: true),
        ],
      ),
    );
  }
}

class _Airport extends StatelessWidget {
  const _Airport({required this.code, required this.city, this.alignEnd = false});

  final String code;
  final String city;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(code, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, height: 0.9)),
        Text(city, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 9)),
      ],
    );
  }
}

class _TicketRoute extends StatelessWidget {
  const _TicketRoute();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider(color: color)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(Icons.flight_rounded, color: color, size: 17),
          ),
          Expanded(child: Divider(color: color)),
        ],
      ),
    );
  }
}

class _RouteDetail extends StatelessWidget {
  const _RouteDetail({required this.label, required this.value, this.light = false});

  final String label;
  final String value;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final foreground = light ? TravelAppTheme.surface : colors.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: light ? TravelAppTheme.sun : colors.primary,
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: foreground, fontSize: 11),
        ),
      ],
    );
  }
}

class _AtlasPainter extends CustomPainter {
  const _AtlasPainter({required this.ink});

  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = ink.withValues(alpha: 0.13)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final island = Path()
      ..moveTo(size.width * 0.2, size.height * 0.42)
      ..cubicTo(
        size.width * 0.34,
        size.height * 0.24,
        size.width * 0.62,
        size.height * 0.22,
        size.width * 0.78,
        size.height * 0.34,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.5,
        size.width * 0.42,
        size.height * 0.56,
        size.width * 0.2,
        size.height * 0.42,
      )
      ..close();
    canvas.drawPath(island, Paint()..color = ink.withValues(alpha: 0.2));
    canvas.drawPath(
      island,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final route = Path()
      ..moveTo(size.width * 0.28, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.53, size.height * 0.2, size.width * 0.73, size.height * 0.38);
    canvas.drawPath(
      route,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    for (final point in <Offset>[
      Offset(size.width * 0.28, size.height * 0.4),
      Offset(size.width * 0.73, size.height * 0.38),
    ]) {
      canvas.drawCircle(point, 5, Paint()..color = TravelAppTheme.sun);
      canvas.drawCircle(
        point,
        5,
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AtlasPainter oldDelegate) => ink != oldDelegate.ink;
}
