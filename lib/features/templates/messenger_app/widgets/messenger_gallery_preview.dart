import 'package:flutter/material.dart';

import '../messenger_app_theme.dart';

class MessengerGalleryPreview extends StatelessWidget {
  const MessengerGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(width: 214, height: 143, child: _MessengerPreviewCanvas()),
    );
  }
}

class _MessengerPreviewCanvas extends StatelessWidget {
  const _MessengerPreviewCanvas();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MessengerAppTheme.background,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Expanded(
                  child: Text('LUMA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                ),
                Icon(Icons.edit_square, size: 14, color: MessengerAppTheme.primary),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: MessengerAppTheme.surface,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: const Column(
                  children: <Widget>[
                    _PreviewChat(initials: 'MC', color: MessengerAppTheme.rose, width: 92, unread: true),
                    Spacer(),
                    _PreviewChat(initials: 'SO', color: MessengerAppTheme.aqua, width: 68),
                    Spacer(),
                    _PreviewChat(initials: 'PT', color: MessengerAppTheme.lavender, width: 80),
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

class _PreviewChat extends StatelessWidget {
  const _PreviewChat({required this.initials, required this.color, required this.width, this.unread = false});

  final String initials;
  final Color color;
  final double width;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 10,
          backgroundColor: color,
          child: Text(initials, style: const TextStyle(fontSize: 6, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width,
                height: 5,
                decoration: const BoxDecoration(
                  color: MessengerAppTheme.ink,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: width + 20,
                height: 4,
                decoration: const BoxDecoration(
                  color: MessengerAppTheme.divider,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
            ],
          ),
        ),
        if (unread) const CircleAvatar(radius: 4, backgroundColor: MessengerAppTheme.primary),
      ],
    );
  }
}
