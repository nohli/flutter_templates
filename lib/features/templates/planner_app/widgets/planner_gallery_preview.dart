import 'package:flutter/material.dart';

import '../planner_app_theme.dart';

class PlannerGalleryPreview extends StatelessWidget {
  const PlannerGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(width: 214, height: 143, child: _PlannerPreviewCanvas()),
    );
  }
}

class _PlannerPreviewCanvas extends StatelessWidget {
  const _PlannerPreviewCanvas();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PlannerAppTheme.background,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'DAYMARK',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                  ),
                ),
                CircleAvatar(
                  radius: 8,
                  backgroundColor: PlannerAppTheme.lime,
                  child: Icon(Icons.check_rounded, size: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[PlannerAppTheme.navy, Color(0xFF334996)]),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: const Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'TODAY',
                            style: TextStyle(color: PlannerAppTheme.lime, fontSize: 7, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Make it count.',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          _PreviewTask(width: 74),
                          SizedBox(height: 4),
                          _PreviewTask(width: 54),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox.square(
                      dimension: 44,
                      child: CircularProgressIndicator(
                        value: 0.5,
                        strokeWidth: 6,
                        color: PlannerAppTheme.lime,
                        backgroundColor: Color(0x33FFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewTask extends StatelessWidget {
  const _PreviewTask({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: const BoxDecoration(color: Color(0x99FFFFFF), borderRadius: BorderRadius.all(Radius.circular(3))),
    );
  }
}
