import 'package:flutter/material.dart';

import '../models/social_post.dart';
import '../social_app_theme.dart';
import 'social_post_art.dart';

class SocialGalleryPreview extends StatelessWidget {
  const SocialGalleryPreview({this.brightness = Brightness.light, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? const Color(0xFF15131B) : const Color(0xFFFFF8DE);
    final ink = dark ? const Color(0xFFF7F0FF) : SocialAppTheme.ink;
    final paper = dark ? const Color(0xFF2A2533) : Colors.white;

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Mingle expressive social collage preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: background,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(painter: _ScribblePainter(color: ink)),
                ),
                Positioned(
                  left: 15,
                  top: 13,
                  child: Text(
                    'MINGLE!',
                    style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -1.2),
                  ),
                ),
                Positioned(
                  left: 17,
                  top: 43,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    color: SocialAppTheme.amber,
                    child: const Text(
                      'GOOD PEOPLE / GOOD ENERGY',
                      style: TextStyle(color: SocialAppTheme.ink, fontSize: 5.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Positioned(
                  left: 19,
                  top: 77,
                  width: 82,
                  height: 105,
                  child: _CollageCard(artwork: SocialPostArtwork.sunset, paper: paper, ink: ink, angle: -0.08),
                ),
                Positioned(
                  left: 91,
                  top: 61,
                  width: 95,
                  height: 120,
                  child: _CollageCard(artwork: SocialPostArtwork.coast, paper: paper, ink: ink, angle: 0.06),
                ),
                Positioned(
                  right: 18,
                  top: 30,
                  width: 87,
                  height: 111,
                  child: _CollageCard(artwork: SocialPostArtwork.studio, paper: paper, ink: ink, angle: -0.035),
                ),
                Positioned(right: 17, bottom: 13, child: _FriendSticker(ink: ink)),
                const Positioned(left: 168, top: 17, child: _NewSticker()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CollageCard extends StatelessWidget {
  const _CollageCard({required this.artwork, required this.paper, required this.ink, required this.angle});

  final SocialPostArtwork artwork;
  final Color paper;
  final Color ink;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
        decoration: BoxDecoration(
          color: paper,
          border: Border.all(color: ink, width: 1),
          boxShadow: <BoxShadow>[
            BoxShadow(color: ink.withValues(alpha: 0.18), blurRadius: 0, offset: const Offset(4, 4)),
          ],
        ),
        child: Column(
          children: <Widget>[
            Expanded(child: SocialPostArt(artwork: artwork, compact: true)),
            const SizedBox(height: 5),
            Row(
              children: <Widget>[
                const Icon(Icons.favorite_rounded, color: SocialAppTheme.coral, size: 8),
                const SizedBox(width: 4),
                Expanded(child: Container(height: 2, color: ink.withValues(alpha: 0.55))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendSticker extends StatelessWidget {
  const _FriendSticker({required this.ink});

  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.07,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: SocialAppTheme.mint,
          border: Border.all(color: ink),
        ),
        child: const Text(
          '+ 4.8K FRIENDS',
          style: TextStyle(color: SocialAppTheme.ink, fontSize: 5.5, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _NewSticker extends StatelessWidget {
  const _NewSticker();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.13,
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: SocialAppTheme.coral,
        child: Text(
          'NEW\nPOST',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 5, fontWeight: FontWeight.w900, height: 1.05),
        ),
      ),
    );
  }
}

class _ScribblePainter extends CustomPainter {
  const _ScribblePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.4), 50, paint);
    canvas.drawLine(Offset(6, size.height - 15), Offset(size.width - 8, size.height * 0.48), paint);
    canvas.drawLine(Offset(size.width * 0.48, 0), Offset(size.width * 0.56, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ScribblePainter oldDelegate) => oldDelegate.color != color;
}
