import 'package:flutter/material.dart';

class TemplateGalleryPreviewFrame extends StatelessWidget {
  const TemplateGalleryPreviewFrame({
    required this.background,
    required this.accent,
    required this.primary,
    required this.secondary,
    this.surface = Colors.white,
    super.key,
  });

  final Color background;
  final Color accent;
  final Color surface;
  final Widget primary;
  final Widget secondary;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: DefaultTextStyle.merge(
        style: const TextStyle(height: 1),
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: 300,
            height: 200,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[background, Color.lerp(background, accent, 0.08)!],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -24,
                    bottom: -42,
                    child: _PreviewOrb(color: accent.withValues(alpha: 0.08), size: 120),
                  ),
                  Positioned(right: 20, top: 15, child: _PreviewRing(color: accent.withValues(alpha: 0.22), size: 24)),
                  Positioned(right: 132, top: 24, child: _PreviewOrb(color: accent.withValues(alpha: 0.24), size: 8)),
                  Positioned(
                    left: 44,
                    top: 12,
                    width: 86,
                    height: 176,
                    child: TemplatePreviewDevice(surface: surface, child: primary),
                  ),
                  Positioned(
                    right: 36,
                    top: 27,
                    width: 102,
                    height: 150,
                    child: TemplatePreviewDevice(surface: surface, child: secondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TemplatePreviewDevice extends StatelessWidget {
  const TemplatePreviewDevice({required this.child, this.surface = Colors.white, super.key});

  final Color surface;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final chromeColor = ThemeData.estimateBrightnessForColor(surface) == Brightness.dark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0x99182033);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.all(Radius.circular(17)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x240E1528), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Column(
        children: <Widget>[
          _PreviewStatusBar(color: chromeColor),
          Expanded(child: child),
          _PreviewHomeIndicator(color: chromeColor.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}

class PreviewLine extends StatelessWidget {
  const PreviewLine({required this.width, required this.color, this.height = 3, super.key});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(99))),
    );
  }
}

class PreviewIconTile extends StatelessWidget {
  const PreviewIconTile({
    required this.icon,
    required this.background,
    required this.foreground,
    this.size = 22,
    super.key,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, borderRadius: const BorderRadius.all(Radius.circular(7))),
      alignment: Alignment.center,
      child: Icon(icon, color: foreground, size: size * 0.55),
    );
  }
}

class _PreviewStatusBar extends StatelessWidget {
  const _PreviewStatusBar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PreviewLine(width: 12, height: 2, color: color),
          Row(
            children: <Widget>[
              PreviewLine(width: 3, height: 3, color: color),
              const SizedBox(width: 2),
              PreviewLine(width: 3, height: 3, color: color),
              const SizedBox(width: 2),
              PreviewLine(width: 7, height: 3, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewHomeIndicator extends StatelessWidget {
  const _PreviewHomeIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 4),
      child: PreviewLine(width: 24, height: 2, color: color),
    );
  }
}

class _PreviewOrb extends StatelessWidget {
  const _PreviewOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: SizedBox.square(dimension: size),
  );
}

class _PreviewRing extends StatelessWidget {
  const _PreviewRing({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: color, width: 4),
    ),
  );
}
