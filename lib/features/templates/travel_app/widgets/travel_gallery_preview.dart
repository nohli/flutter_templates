import 'package:flutter/material.dart';

import '../travel_app_theme.dart';

class TravelGalleryPreview extends StatelessWidget {
  const TravelGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Roam travel itinerary preview',
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFF7F0E2), Color(0xFFD6E9E2)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(left: -25, bottom: -34, child: _MapIsland(width: 150, height: 104)),
            Positioned(left: 72, top: 24, child: _MapIsland(width: 92, height: 62)),
            Positioned.fill(child: CustomPaint(painter: _TravelRoutePainter())),
            Positioned(
              left: 13,
              top: 12,
              child: Text(
                'Roam',
                style: TextStyle(color: TravelAppTheme.ink, fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ),
            Positioned(left: 13, top: 30, child: _RouteBadge()),
            Positioned(right: 12, top: 14, bottom: 12, width: 78, child: _MiniItinerary()),
          ],
        ),
      ),
    );
  }
}

class _MapIsland extends StatelessWidget {
  const _MapIsland({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.18,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: TravelAppTheme.seaGlass,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(width * 0.36),
            topRight: Radius.circular(width * 0.18),
            bottomLeft: Radius.circular(width * 0.14),
            bottomRight: Radius.circular(width * 0.42),
          ),
        ),
      ),
    );
  }
}

class _RouteBadge extends StatelessWidget {
  const _RouteBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const BoxDecoration(color: TravelAppTheme.ocean, borderRadius: BorderRadius.all(Radius.circular(99))),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'LIS',
            style: TextStyle(color: Colors.white, fontSize: 5.5, fontWeight: FontWeight.w800),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.flight_rounded, color: TravelAppTheme.sun, size: 8),
          ),
          Text(
            'FNC',
            style: TextStyle(color: Colors.white, fontSize: 5.5, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _MiniItinerary extends StatelessWidget {
  const _MiniItinerary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 10, 8, 8),
      decoration: const BoxDecoration(
        color: TravelAppTheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0x22152B2D), blurRadius: 9, offset: Offset(0, 4))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Friday, 18', style: TextStyle(fontSize: 6.5, fontWeight: FontWeight.w800)),
          SizedBox(height: 9),
          _MiniStop(color: TravelAppTheme.coral, width: 42),
          _MiniStop(color: TravelAppTheme.sun, width: 34),
          _MiniStop(color: TravelAppTheme.ocean, width: 46),
          Spacer(),
          Row(
            children: <Widget>[
              Icon(Icons.near_me_rounded, size: 7, color: TravelAppTheme.primary),
              SizedBox(width: 3),
              Text('4 stops', style: TextStyle(fontSize: 4.5, color: TravelAppTheme.mutedInk)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStop extends StatelessWidget {
  const _MiniStop({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Container(
            width: width,
            height: 3,
            decoration: const BoxDecoration(color: Color(0xFFD4DEDB)),
          ),
        ],
      ),
    );
  }
}

class _TravelRoutePainter extends CustomPainter {
  const _TravelRoutePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.44, size.height * 0.32, size.width * 0.66, size.height * 0.58);
    canvas.drawPath(
      path,
      Paint()
        ..color = TravelAppTheme.primary.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    final pointPaint = Paint()..color = TravelAppTheme.primary;
    canvas.drawCircle(Offset(size.width * 0.18, size.height * 0.72), 3.2, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.66, size.height * 0.58), 3.2, pointPaint);
  }

  @override
  bool shouldRepaint(covariant _TravelRoutePainter oldDelegate) => false;
}
