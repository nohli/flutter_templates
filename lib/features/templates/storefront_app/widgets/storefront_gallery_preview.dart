import 'package:flutter/material.dart';

import '../../shared/template_gallery_preview.dart';
import '../models/store_product.dart';
import '../storefront_app_theme.dart';
import 'storefront_product_art.dart';

class StorefrontGalleryPreview extends StatelessWidget {
  const StorefrontGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateGalleryPreviewFrame(
      background: StorefrontAppTheme.background,
      accent: StorefrontAppTheme.primary,
      surface: StorefrontAppTheme.surface,
      primary: _StorefrontHomePreview(),
      secondary: _StorefrontProductPreview(),
    );
  }
}

class _StorefrontHomePreview extends StatelessWidget {
  const _StorefrontHomePreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text('Nest', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700)),
              ),
              Icon(Icons.shopping_bag_outlined, size: 8),
            ],
          ),
          SizedBox(height: 5),
          Text('Calmer spaces.', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          SizedBox(height: 5),
          _PreviewSearch(),
          SizedBox(height: 5),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _MiniProduct(kind: StoreProductKind.chair, label: 'Nest chair'),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: _MiniProduct(kind: StoreProductKind.headphones, label: 'Quiet one'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StorefrontProductPreview extends StatelessWidget {
  const _StorefrontProductPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text('Saved', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
              ),
              Icon(Icons.favorite_rounded, size: 9, color: StorefrontAppTheme.primary),
            ],
          ),
          SizedBox(height: 6),
          Expanded(child: StorefrontProductArt(kind: StoreProductKind.watch, compact: true)),
          SizedBox(height: 6),
          Text('Still Watch', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800)),
          SizedBox(height: 2),
          Text('Quietly considered.', style: TextStyle(fontSize: 4.5, color: StorefrontAppTheme.mutedInk)),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                r'$129',
                style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: StorefrontAppTheme.primary),
              ),
              CircleAvatar(
                radius: 8,
                backgroundColor: StorefrontAppTheme.primary,
                child: Icon(Icons.add_rounded, size: 10, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewSearch extends StatelessWidget {
  const _PreviewSearch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 15,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(color: Color(0xFFF5EFE5), borderRadius: BorderRadius.all(Radius.circular(7))),
      child: const Row(
        children: <Widget>[
          Icon(Icons.search_rounded, size: 7, color: StorefrontAppTheme.mutedInk),
          SizedBox(width: 3),
          Expanded(
            child: Text(
              'Search collection',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 4.5, color: StorefrontAppTheme.mutedInk),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniProduct extends StatelessWidget {
  const _MiniProduct({required this.kind, required this.label});

  final StoreProductKind kind;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0x1425231F), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: StorefrontProductArt(kind: kind, compact: true)),
            const SizedBox(height: 3),
            Text(label, maxLines: 1, style: const TextStyle(fontSize: 4.5, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
