import 'package:flutter/material.dart';

import '../smart_home_app_theme.dart';

class SmartHomeGalleryPreview extends StatelessWidget {
  const SmartHomeGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(width: 214, height: 143, child: _SmartHomePreviewCanvas()),
    );
  }
}

class _SmartHomePreviewCanvas extends StatelessWidget {
  const _SmartHomePreviewCanvas();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: SmartHomeAppTheme.background,
      child: Padding(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('HOMELINE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
            SizedBox(height: 7),
            Text('Everything feels just right.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _PreviewDevice(icon: Icons.lightbulb_rounded, color: SmartHomeAppTheme.mint),
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: _PreviewDevice(icon: Icons.thermostat_rounded, color: SmartHomeAppTheme.sky),
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: _PreviewDevice(icon: Icons.speaker_rounded, color: SmartHomeAppTheme.amber),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewDevice extends StatelessWidget {
  const _PreviewDevice({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SmartHomeAppTheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 11,
              backgroundColor: color,
              child: Icon(icon, size: 13, color: SmartHomeAppTheme.deepGreen),
            ),
            const Spacer(),
            const SizedBox(width: 30, child: Divider(height: 3, thickness: 3, color: SmartHomeAppTheme.ink)),
            const SizedBox(height: 3),
            const SizedBox(width: 22, child: Divider(height: 2, thickness: 2, color: SmartHomeAppTheme.divider)),
          ],
        ),
      ),
    );
  }
}
