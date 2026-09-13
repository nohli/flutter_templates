import 'package:flutter/material.dart';

import '../private_messenger_theme.dart';

class PrivateMessengerGalleryPreview extends StatelessWidget {
  const PrivateMessengerGalleryPreview({required this.brightness, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? PrivateMessengerTheme.darkBackground : PrivateMessengerTheme.lightBackground;
    final surface = dark ? PrivateMessengerTheme.darkSurface : PrivateMessengerTheme.lightSurface;
    final ink = dark ? const Color(0xFFF4FBF7) : const Color(0xFF173129);
    final muted = dark ? const Color(0xFFB4C5BD) : const Color(0xFF64766E);
    return Semantics(
      image: true,
      label: 'Clover private messenger preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: background,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Clover',
                        style: TextStyle(
                          color: ink,
                          fontFamily: PrivateMessengerTheme.displayFontName,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.camera_alt_outlined, color: ink, size: 13),
                      const SizedBox(width: 10),
                      Icon(Icons.search_rounded, color: ink, size: 13),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: <Widget>[
                      _PreviewStatus(color: PrivateMessengerTheme.evergreen, surface: surface),
                      _PreviewStatus(color: PrivateMessengerTheme.peach, surface: surface),
                      _PreviewStatus(color: PrivateMessengerTheme.mint, surface: surface),
                      _PreviewStatus(color: PrivateMessengerTheme.lilac, surface: surface),
                    ],
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: surface,
                    child: Column(
                      children: <Widget>[
                        _PreviewPrivateChat(
                          name: 'Jules',
                          line: 'The garden table is booked',
                          color: PrivateMessengerTheme.peach,
                          ink: ink,
                          muted: muted,
                          unread: true,
                        ),
                        _PreviewPrivateChat(
                          name: 'Sunday hikers',
                          line: 'I’ll bring enough water',
                          color: PrivateMessengerTheme.mint,
                          ink: ink,
                          muted: muted,
                          unread: true,
                        ),
                        _PreviewPrivateChat(
                          name: 'Dad',
                          line: 'That photo made my day',
                          color: const Color(0xFF9AB0F8),
                          ink: ink,
                          muted: muted,
                          unread: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewStatus extends StatelessWidget {
  const _PreviewStatus({required this.color, required this.surface});

  final Color color;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(shape: BoxShape.circle, color: PrivateMessengerTheme.evergreen),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: surface,
        child: CircleAvatar(radius: 13, backgroundColor: color),
      ),
    );
  }
}

class _PreviewPrivateChat extends StatelessWidget {
  const _PreviewPrivateChat({
    required this.name,
    required this.line,
    required this.color,
    required this.ink,
    required this.muted,
    required this.unread,
  });

  final String name;
  final String line;
  final Color color;
  final Color ink;
  final Color muted;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: <Widget>[
            CircleAvatar(radius: 12, backgroundColor: color),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(color: ink, fontSize: 7, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    line,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: muted, fontSize: 5),
                  ),
                ],
              ),
            ),
            if (unread)
              const CircleAvatar(
                radius: 5,
                backgroundColor: PrivateMessengerTheme.evergreen,
                child: Text('2', style: TextStyle(color: Colors.white, fontSize: 4)),
              ),
          ],
        ),
      ),
    );
  }
}
