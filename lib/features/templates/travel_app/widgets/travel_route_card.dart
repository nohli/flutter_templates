import 'package:flutter/material.dart';

import '../travel_app_theme.dart';

class TravelRouteCard extends StatelessWidget {
  const TravelRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (MediaQuery.textScalerOf(context).scale(1) >= 2) {
      return const _AccessibleRouteCard();
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF0C5557), TravelAppTheme.ocean, Color(0xFF238584)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0x33146B6A), blurRadius: 24, offset: Offset(0, 12))],
      ),
      child: Stack(
        children: <Widget>[
          const Positioned(right: -35, top: -52, child: _RouteGlow(size: 142, color: Color(0x22FFFFFF))),
          const Positioned(left: 88, bottom: -72, child: _RouteGlow(size: 160, color: Color(0x16F2C14E))),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 21, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.flight_takeoff_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 9),
                    Text(
                      'NEXT ESCAPE',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: const BorderRadius.all(Radius.circular(99)),
                      ),
                      child: const Text(
                        '3 days',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const _RouteCities(),
                const SizedBox(height: 24),
                Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: _RouteDetail(label: 'DEPART', value: '18 Oct · 07:05'),
                    ),
                    Container(width: 1, height: 34, color: Colors.white.withValues(alpha: 0.2)),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: _RouteDetail(label: 'STAY', value: 'Funchal · Room 4'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 18,
            bottom: 15,
            child: Icon(Icons.waves_rounded, color: colors.secondaryContainer.withValues(alpha: 0.36), size: 34),
          ),
        ],
      ),
    );
  }
}

class _AccessibleRouteCard extends StatelessWidget {
  const _AccessibleRouteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Color(0xFF0C5557), TravelAppTheme.ocean]),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.flight_takeoff_rounded, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Lisbon to Madeira',
            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 18),
          _RouteDetail(label: 'DEPART', value: '18 Oct · 07:05'),
          SizedBox(height: 14),
          _RouteDetail(label: 'STAY', value: 'Funchal · Room 4'),
        ],
      ),
    );
  }
}

class _RouteCities extends StatelessWidget {
  const _RouteCities();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        _Airport(code: 'LIS', city: 'Lisbon'),
        Expanded(child: _FlightPath()),
        _Airport(code: 'FNC', city: 'Madeira', alignEnd: true),
      ],
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
        Text(
          code,
          style: const TextStyle(color: Colors.white, fontSize: 31, fontWeight: FontWeight.w700, letterSpacing: -1.2),
        ),
        Text(city, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
      ],
    );
  }
}

class _FlightPath extends StatelessWidget {
  const _FlightPath();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          Expanded(child: Container(height: 1, color: Colors.white54)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(Icons.flight_rounded, color: TravelAppTheme.sun, size: 20),
          ),
          Expanded(child: Container(height: 1, color: Colors.white54)),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class _RouteDetail extends StatelessWidget {
  const _RouteDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class _RouteGlow extends StatelessWidget {
  const _RouteGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
