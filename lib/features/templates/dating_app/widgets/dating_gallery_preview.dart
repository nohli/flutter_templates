import 'package:flutter/material.dart';

import '../dating_app_theme.dart';
import '../models/dating_profile.dart';
import 'dating_profile_artwork.dart';

class DatingGalleryPreview extends StatelessWidget {
  const DatingGalleryPreview({this.brightness = Brightness.dark, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Sway dating profile preview',
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? const <Color>[DatingAppTheme.background, Color(0xFF2E1D38)]
                : const <Color>[Color(0xFFFFF3EA), Color(0xFFFFD9E4)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(left: 13, top: 11, child: _PreviewWordmark(dark: dark)),
            const Positioned(left: 16, top: 34, bottom: 12, width: 104, child: _PreviewProfile()),
            Positioned(right: 18, top: 45, child: _PreviewCopy(dark: dark)),
            Positioned(right: 19, bottom: 15, child: _PreviewActions(dark: dark)),
          ],
        ),
      ),
    );
  }
}

class _PreviewWordmark extends StatelessWidget {
  const _PreviewWordmark({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Sway',
          style: TextStyle(
            color: dark ? DatingAppTheme.ink : const Color(0xFF21181D),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 5),
        const CircleAvatar(radius: 2.5, backgroundColor: DatingAppTheme.primary),
      ],
    );
  }
}

class _PreviewProfile extends StatelessWidget {
  const _PreviewProfile();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(border: Border.fromBorderSide(BorderSide(color: DatingAppTheme.primary))),
      child: DatingProfileArtwork(palette: DatingProfilePalette.sunset),
    );
  }
}

class _PreviewCopy extends StatelessWidget {
  const _PreviewCopy({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? DatingAppTheme.ink : const Color(0xFF21181D);
    final muted = dark ? DatingAppTheme.mutedInk : const Color(0xFF7E7078);

    return SizedBox(
      width: 82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Mina, 29',
            style: TextStyle(color: ink, fontSize: 9, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text('Choosing dessert first.', style: TextStyle(color: muted, fontSize: 5.5, height: 1.25)),
          const SizedBox(height: 8),
          _MiniInterest(label: 'Jazz', dark: dark),
          const SizedBox(height: 4),
          _MiniInterest(label: 'Ceramics', dark: dark),
        ],
      ),
    );
  }
}

class _MiniInterest extends StatelessWidget {
  const _MiniInterest({required this.label, required this.dark});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark ? DatingAppTheme.raisedSurface : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(99)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(label, style: TextStyle(color: dark ? DatingAppTheme.ink : const Color(0xFF21181D), fontSize: 4.5)),
      ),
    );
  }
}

class _PreviewActions extends StatelessWidget {
  const _PreviewActions({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _MiniAction(icon: Icons.close_rounded, color: dark ? DatingAppTheme.ink : const Color(0xFF21181D), dark: dark),
        const SizedBox(width: 6),
        _MiniAction(icon: Icons.auto_awesome_rounded, color: DatingAppTheme.sun, dark: dark),
        const SizedBox(width: 6),
        _MiniAction(icon: Icons.favorite_rounded, color: DatingAppTheme.primary, dark: dark),
      ],
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({required this.icon, required this.color, required this.dark});

  final IconData icon;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: dark ? DatingAppTheme.raisedSurface : Colors.white),
      child: SizedBox.square(dimension: 22, child: Icon(icon, size: 11, color: color)),
    );
  }
}
