import 'package:flutter/material.dart';

import '../../shared/template_gallery_preview.dart';
import '../finance_app_theme.dart';

class FinanceGalleryPreview extends StatelessWidget {
  const FinanceGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateGalleryPreviewFrame(
      background: FinanceAppTheme.background,
      accent: FinanceAppTheme.primary,
      surface: FinanceAppTheme.surface,
      primary: _FinanceOverviewPreview(),
      secondary: _FinanceActivityPreview(),
    );
  }
}

class _FinanceOverviewPreview extends StatelessWidget {
  const _FinanceOverviewPreview();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 3, 7, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Expanded(
                child: Text('Overview', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800)),
              ),
              CircleAvatar(
                radius: 6,
                backgroundColor: FinanceAppTheme.lavender,
                child: Text('AR', style: TextStyle(fontSize: 4, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            height: 56,
            width: double.infinity,
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: <Color>[FinanceAppTheme.primaryDark, FinanceAppTheme.primary]),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('TOTAL BALANCE', style: TextStyle(color: Color(0xFFCFD4FF), fontSize: 4, letterSpacing: 0.4)),
                SizedBox(height: 2),
                Text(
                  r'$24,860',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    PreviewLine(width: 24, color: FinanceAppTheme.mint),
                    SizedBox(width: 4),
                    PreviewLine(width: 17, color: FinanceAppTheme.coral),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text('Spending', style: TextStyle(fontSize: 6, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          const Expanded(child: _MiniBarChart()),
        ],
      ),
    );
  }
}

class _FinanceActivityPreview extends StatelessWidget {
  const _FinanceActivityPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 3, 8, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Activity', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          SizedBox(height: 3),
          Text('September', style: TextStyle(color: FinanceAppTheme.mutedInk, fontSize: 5)),
          SizedBox(height: 8),
          _PreviewTransaction(icon: Icons.shopping_bag_rounded, color: FinanceAppTheme.coral, width: 42),
          SizedBox(height: 8),
          _PreviewTransaction(icon: Icons.coffee_rounded, color: FinanceAppTheme.amber, width: 32),
          SizedBox(height: 8),
          _PreviewTransaction(icon: Icons.train_rounded, color: FinanceAppTheme.mint, width: 38),
          Spacer(),
          _MiniBalancePill(),
        ],
      ),
    );
  }
}

class _PreviewTransaction extends StatelessWidget {
  const _PreviewTransaction({required this.icon, required this.color, required this.width});

  final IconData icon;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        PreviewIconTile(
          icon: icon,
          background: color.withValues(alpha: 0.24),
          foreground: FinanceAppTheme.ink,
          size: 17,
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PreviewLine(width: width, color: FinanceAppTheme.ink),
            const SizedBox(height: 3),
            PreviewLine(width: width * 0.72, height: 2, color: FinanceAppTheme.divider),
          ],
        ),
      ],
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _PreviewBar(height: 12),
        _PreviewBar(height: 20),
        _PreviewBar(height: 16),
        _PreviewBar(height: 26, highlighted: true),
        _PreviewBar(height: 19),
      ],
    );
  }
}

class _PreviewBar extends StatelessWidget {
  const _PreviewBar({required this.height, this.highlighted = false});

  final double height;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: highlighted ? FinanceAppTheme.primary : FinanceAppTheme.lavender,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
    );
  }
}

class _MiniBalancePill extends StatelessWidget {
  const _MiniBalancePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: const BoxDecoration(
        color: FinanceAppTheme.lavender,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: const Text(r'+ $1,860 this month', style: TextStyle(fontSize: 5, fontWeight: FontWeight.w700)),
    );
  }
}
