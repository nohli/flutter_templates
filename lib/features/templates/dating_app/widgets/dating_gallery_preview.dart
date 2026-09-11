import 'package:flutter/material.dart';

import '../dating_app_theme.dart';
import '../models/dating_profile.dart';
import 'dating_profile_artwork.dart';

class DatingGalleryPreview extends StatelessWidget {
  const DatingGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Sway dating profile preview',
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[DatingAppTheme.background, Color(0xFF2E1D38)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(left: 13, top: 11, child: _PreviewWordmark()),
            Positioned(left: 16, top: 34, bottom: 12, width: 104, child: _PreviewProfile()),
            Positioned(right: 18, top: 45, child: _PreviewCopy()),
            Positioned(right: 19, bottom: 15, child: _PreviewActions()),
          ],
        ),
      ),
    );
  }
}

class _PreviewWordmark extends StatelessWidget {
  const _PreviewWordmark();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Sway',
          style: TextStyle(color: DatingAppTheme.ink, fontSize: 10, fontWeight: FontWeight.w800),
        ),
        SizedBox(width: 5),
        CircleAvatar(radius: 2.5, backgroundColor: DatingAppTheme.primary),
      ],
    );
  }
}

class _PreviewProfile extends StatelessWidget {
  const _PreviewProfile();

  @override
  Widget build(BuildContext context) {
    return const ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: DatingProfileArtwork(palette: DatingProfilePalette.sunset),
    );
  }
}

class _PreviewCopy extends StatelessWidget {
  const _PreviewCopy();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Mina, 29',
            style: TextStyle(color: DatingAppTheme.ink, fontSize: 9, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 5),
          Text(
            'Choosing dessert first.',
            style: TextStyle(color: DatingAppTheme.mutedInk, fontSize: 5.5, height: 1.25),
          ),
          SizedBox(height: 8),
          _MiniInterest(label: 'Jazz'),
          SizedBox(height: 4),
          _MiniInterest(label: 'Ceramics'),
        ],
      ),
    );
  }
}

class _MiniInterest extends StatelessWidget {
  const _MiniInterest({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: DatingAppTheme.raisedSurface,
        borderRadius: BorderRadius.all(Radius.circular(99)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(label, style: const TextStyle(color: DatingAppTheme.ink, fontSize: 4.5)),
      ),
    );
  }
}

class _PreviewActions extends StatelessWidget {
  const _PreviewActions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        _MiniAction(icon: Icons.close_rounded, color: DatingAppTheme.ink),
        SizedBox(width: 6),
        _MiniAction(icon: Icons.auto_awesome_rounded, color: DatingAppTheme.sun),
        SizedBox(width: 6),
        _MiniAction(icon: Icons.favorite_rounded, color: DatingAppTheme.primary),
      ],
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 11,
      backgroundColor: DatingAppTheme.raisedSurface,
      child: Icon(icon, size: 11, color: color),
    );
  }
}
