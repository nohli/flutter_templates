import 'package:flutter/material.dart';

import '../../shared/template_gallery_preview.dart';
import '../planner_app_theme.dart';

class PlannerGalleryPreview extends StatelessWidget {
  const PlannerGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateGalleryPreviewFrame(
      background: PlannerAppTheme.background,
      accent: PlannerAppTheme.primary,
      surface: PlannerAppTheme.surface,
      primary: _PlannerTodayPreview(),
      secondary: _PlannerFocusPreview(),
    );
  }
}

class _PlannerTodayPreview extends StatelessWidget {
  const _PlannerTodayPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('DAYMARK', style: TextStyle(fontSize: 6.5, fontWeight: FontWeight.w800, letterSpacing: 0.7)),
          SizedBox(height: 4),
          _TodayCard(),
          SizedBox(height: 4),
          Text('Today', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800)),
          SizedBox(height: 3),
          _PreviewTask(icon: Icons.auto_awesome_rounded, color: PlannerAppTheme.peach, width: 42),
          SizedBox(height: 3),
          _PreviewTask(icon: Icons.manage_search_rounded, color: PlannerAppTheme.sky, width: 36),
          SizedBox(height: 3),
          _PreviewTask(icon: Icons.edit_note_rounded, color: Color(0xFFE1D8F7), width: 40),
        ],
      ),
    );
  }
}

class _PlannerFocusPreview extends StatelessWidget {
  const _PlannerFocusPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 3),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Focus', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          ),
          Spacer(),
          SizedBox.square(
            dimension: 62,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  value: 0.72,
                  strokeWidth: 7,
                  color: PlannerAppTheme.lime,
                  backgroundColor: Color(0xFFE6EAF3),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('18:24', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                    Text('Deep work', style: TextStyle(fontSize: 4.5, color: PlannerAppTheme.mutedInk)),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          _FocusButton(),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[PlannerAppTheme.navy, Color(0xFF334996)]),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'SEP 11',
                  maxLines: 1,
                  style: TextStyle(color: PlannerAppTheme.lime, fontSize: 4, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Focus day',
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.w800),
                ),
                Text('1 / 4 done', maxLines: 1, style: TextStyle(color: Color(0xFFCBD3F5), fontSize: 4)),
              ],
            ),
          ),
          SizedBox(width: 3),
          SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              value: 0.25,
              strokeWidth: 5,
              color: PlannerAppTheme.lime,
              backgroundColor: Color(0x33FFFFFF),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewTask extends StatelessWidget {
  const _PreviewTask({required this.icon, required this.color, required this.width});

  final IconData icon;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Row(
        children: <Widget>[
          PreviewIconTile(icon: icon, background: color, foreground: PlannerAppTheme.navy, size: 12),
          const SizedBox(width: 4),
          PreviewLine(width: width, height: 2.5, color: PlannerAppTheme.ink),
        ],
      ),
    );
  }
}

class _FocusButton extends StatelessWidget {
  const _FocusButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 19,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: PlannerAppTheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'PAUSE',
        style: TextStyle(color: Colors.white, fontSize: 5, fontWeight: FontWeight.w800),
      ),
    );
  }
}
