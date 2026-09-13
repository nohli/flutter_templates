import 'package:flutter/material.dart';

import '../channel_messenger_theme.dart';

class ChannelMessengerGalleryPreview extends StatelessWidget {
  const ChannelMessengerGalleryPreview({required this.brightness, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? ChannelMessengerTheme.darkBackground : ChannelMessengerTheme.lightBackground;
    final surface = dark ? ChannelMessengerTheme.darkSurface : ChannelMessengerTheme.lightSurface;
    final ink = dark ? const Color(0xFFF3F8FC) : const Color(0xFF172936);
    final muted = dark ? const Color(0xFFAFC1D0) : const Color(0xFF617582);
    return Semantics(
      image: true,
      label: 'Aero channel messenger preview',
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
                  padding: const EdgeInsets.fromLTRB(14, 11, 14, 7),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Aero',
                        style: TextStyle(
                          color: ink,
                          fontFamily: ChannelMessengerTheme.displayFontName,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.search_rounded, color: ink, size: 14),
                    ],
                  ),
                ),
                Container(
                  height: 26,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: surface, borderRadius: const BorderRadius.all(Radius.circular(9))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: ChannelMessengerTheme.blue,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'All',
                            style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('Unread', style: TextStyle(color: muted, fontSize: 6)),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('Channels', style: TextStyle(color: muted, fontSize: 6)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ColoredBox(
                    color: surface,
                    child: Column(
                      children: <Widget>[
                        _PreviewChat(
                          title: 'Design Dispatch',
                          line: 'Interfaces that move with purpose',
                          color: ChannelMessengerTheme.blue,
                          ink: ink,
                          muted: muted,
                          unread: true,
                        ),
                        _PreviewChat(
                          title: 'Studio Crew',
                          line: 'The prototype is ready to try',
                          color: const Color(0xFFFF9C66),
                          ink: ink,
                          muted: muted,
                          unread: true,
                        ),
                        _PreviewChat(
                          title: 'City Signals',
                          line: 'Five exhibitions this weekend',
                          color: const Color(0xFF8D6EE8),
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

class _PreviewChat extends StatelessWidget {
  const _PreviewChat({
    required this.title,
    required this.line,
    required this.color,
    required this.ink,
    required this.muted,
    required this.unread,
  });

  final String title;
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
            CircleAvatar(
              radius: 12,
              backgroundColor: color,
              child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 11),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
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
                backgroundColor: ChannelMessengerTheme.blue,
                child: Text('2', style: TextStyle(color: Colors.white, fontSize: 4)),
              ),
          ],
        ),
      ),
    );
  }
}
