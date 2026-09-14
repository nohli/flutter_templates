import 'package:flutter/material.dart';

import 'models/template_gallery_item.dart';

class TemplateGalleryArtwork extends StatelessWidget {
  const TemplateGalleryArtwork({required this.item, super.key});

  final TemplateGalleryItem item;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final palette = _GalleryArtworkPalette.forDestination(item.destination, dark: dark);
    final imagePath = item.destination.galleryPreviewPath(dark: dark);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[palette.background, Color.lerp(palette.background, palette.accent, 0.12)!],
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Positioned(
                left: width * 0.07,
                top: height * 0.075,
                width: width * 0.255,
                height: height * 0.84,
                child: _ScreenFrame(imagePath: imagePath, palette: palette, fit: BoxFit.contain),
              ),
              Positioned(
                left: width * 0.39,
                top: height * 0.11,
                width: width * 0.55,
                height: height * 0.405,
                child: _ScreenFrame(imagePath: imagePath, palette: palette, alignment: const Alignment(0, -0.92)),
              ),
              Positioned(
                left: width * 0.48,
                top: height * 0.565,
                width: width * 0.46,
                height: height * 0.315,
                child: _ScreenFrame(imagePath: imagePath, palette: palette, alignment: const Alignment(0, -0.05)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScreenFrame extends StatelessWidget {
  const _ScreenFrame({
    required this.imagePath,
    required this.palette,
    this.alignment = Alignment.topCenter,
    this.fit = BoxFit.fitWidth,
  });

  final String imagePath;
  final _GalleryArtworkPalette palette;
  final Alignment alignment;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.frame,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: palette.border),
        boxShadow: <BoxShadow>[BoxShadow(color: palette.shadow, blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: Image.asset(imagePath, alignment: alignment, fit: fit, filterQuality: FilterQuality.high),
        ),
      ),
    );
  }
}

class _GalleryArtworkPalette {
  const _GalleryArtworkPalette({
    required this.background,
    required this.accent,
    required this.frame,
    required this.border,
    required this.shadow,
  });

  factory _GalleryArtworkPalette.forDestination(TemplateGalleryDestination destination, {required bool dark}) {
    final accent = switch (destination) {
      TemplateGalleryDestination.hotelBooking => const Color(0xFF52CDBF),
      TemplateGalleryDestination.fitness => const Color(0xFF4A5DE2),
      TemplateGalleryDestination.designCourse => const Color(0xFF0DB4DF),
      TemplateGalleryDestination.personalFinance => const Color(0xFF69E5B5),
      TemplateGalleryDestination.dating => const Color(0xFFE86C8D),
      TemplateGalleryDestination.languageLearning => const Color(0xFF39BA78),
      TemplateGalleryDestination.socialFeed => const Color(0xFFFF668A),
      TemplateGalleryDestination.bankingSuperApp => const Color(0xFF7449F3),
      TemplateGalleryDestination.channelMessenger => const Color(0xFF2D82DC),
      TemplateGalleryDestination.privateMessenger => const Color(0xFF3DB58A),
    };
    final background = switch (destination) {
      TemplateGalleryDestination.hotelBooking => const Color(0xFFE9F5F6),
      TemplateGalleryDestination.fitness => const Color(0xFFF1F3FA),
      TemplateGalleryDestination.designCourse => const Color(0xFFEDEDED),
      TemplateGalleryDestination.personalFinance => const Color(0xFFF1EFE8),
      TemplateGalleryDestination.dating => const Color(0xFFFBECE9),
      TemplateGalleryDestination.languageLearning => const Color(0xFFF7F2E6),
      TemplateGalleryDestination.socialFeed => const Color(0xFFF4F1ED),
      TemplateGalleryDestination.bankingSuperApp => const Color(0xFFF0ECFC),
      TemplateGalleryDestination.channelMessenger => const Color(0xFFEAF2FB),
      TemplateGalleryDestination.privateMessenger => const Color(0xFFF7F0E7),
    };

    if (dark) {
      return _GalleryArtworkPalette(
        background: Color.lerp(const Color(0xFF10141B), accent, 0.08)!,
        accent: accent,
        frame: const Color(0xFF171C24),
        border: Colors.white.withValues(alpha: 0.10),
        shadow: Colors.black.withValues(alpha: 0.42),
      );
    }

    return _GalleryArtworkPalette(
      background: background,
      accent: accent,
      frame: Colors.white,
      border: Colors.white.withValues(alpha: 0.78),
      shadow: const Color(0xFF253040).withValues(alpha: 0.20),
    );
  }

  final Color background;
  final Color accent;
  final Color frame;
  final Color border;
  final Color shadow;
}
