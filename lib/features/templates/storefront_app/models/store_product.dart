enum StoreCategory { all, living, audio, wearables }

enum StoreProductKind { chair, headphones, lamp, watch }

class StoreProduct {
  const StoreProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.kind,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final StoreCategory category;
  final StoreProductKind kind;

  static const samples = <StoreProduct>[
    StoreProduct(
      id: 'nest-chair',
      name: 'Nest Chair',
      description: 'Soft boucle · oak frame',
      price: 249,
      category: StoreCategory.living,
      kind: StoreProductKind.chair,
    ),
    StoreProduct(
      id: 'quiet-headphones',
      name: 'Quiet One',
      description: 'Spatial audio · 32 hours',
      price: 189,
      category: StoreCategory.audio,
      kind: StoreProductKind.headphones,
    ),
    StoreProduct(
      id: 'halo-lamp',
      name: 'Halo Lamp',
      description: 'Warm dimming · touch control',
      price: 96,
      category: StoreCategory.living,
      kind: StoreProductKind.lamp,
    ),
    StoreProduct(
      id: 'tempo-watch',
      name: 'Tempo Watch',
      description: 'Health insights · 5-day battery',
      price: 219,
      category: StoreCategory.wearables,
      kind: StoreProductKind.watch,
    ),
  ];
}
