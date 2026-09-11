import 'package:flutter/material.dart';

import '../social_app_theme.dart';

class SocialDiscoverSection extends StatelessWidget {
  const SocialDiscoverSection({
    required this.scrollController,
    required this.followedCreatorIds,
    required this.onToggleFollowed,
    super.key,
  });

  final ScrollController scrollController;
  final Set<String> followedCreatorIds;
  final ValueChanged<String> onToggleFollowed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(color: SocialAppTheme.coral),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'FIND YOUR\nPEOPLE.',
              style: TextStyle(
                color: SocialAppTheme.ink,
                fontFamily: SocialAppTheme.displayFontName,
                fontSize: 30,
                height: 0.9,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'Search people and ideas',
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'TRENDING / RIGHT NOW',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        const SizedBox(height: 14),
        const _TopicGrid(),
        const SizedBox(height: 28),
        const Text('PEOPLE TO KNOW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        ..._creators.map(
          (({Color color, String id, String name, String role}) creator) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CreatorTile(
              name: creator.name,
              role: creator.role,
              color: creator.color,
              isFollowed: followedCreatorIds.contains(creator.id),
              onToggleFollowed: () => onToggleFollowed(creator.id),
            ),
          ),
        ),
      ],
    );
  }
}

const _creators = <({Color color, String id, String name, String role})>[
  (id: 'lena', name: 'Lena Park', role: 'Visual storyteller', color: SocialAppTheme.coral),
  (id: 'jon', name: 'Jon Bell', role: 'Urban gardener', color: SocialAppTheme.mint),
  (id: 'amira', name: 'Amira Noor', role: 'Independent maker', color: SocialAppTheme.amber),
];

class _TopicGrid extends StatelessWidget {
  const _TopicGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          child: _TopicCard(
            label: 'Slow living',
            icon: Icons.spa_outlined,
            colors: <Color>[Color(0xFFFFB3A7), Color(0xFFFFD27A)],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _TopicCard(
            label: 'New makers',
            icon: Icons.auto_awesome_outlined,
            colors: <Color>[Color(0xFF8D7CE7), Color(0xFF79D9C8)],
          ),
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.label, required this.icon, required this.colors});

  final String label;
  final IconData icon;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.first,
          border: Border.all(color: SocialAppTheme.ink, width: 2),
          boxShadow: SocialAppTheme.softShadow,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(right: -18, top: -18, child: CircleAvatar(radius: 46, backgroundColor: colors.last)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(icon, size: 32, color: SocialAppTheme.ink),
                  Text(label.toUpperCase(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatorTile extends StatelessWidget {
  const _CreatorTile({
    required this.name,
    required this.role,
    required this.color,
    required this.isFollowed,
    required this.onToggleFollowed,
  });

  final String name;
  final String role;
  final Color color;
  final bool isFollowed;
  final VoidCallback onToggleFollowed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      tileColor: colors.surface,
      shape: RoundedRectangleBorder(side: BorderSide(color: colors.outlineVariant)),
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: SocialAppTheme.ink),
        ),
        child: SizedBox.square(
          dimension: 40,
          child: Center(
            child: Text(name.characters.first, style: const TextStyle(color: SocialAppTheme.ink)),
          ),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(role),
      trailing: FilledButton.tonal(onPressed: onToggleFollowed, child: Text(isFollowed ? 'Following' : 'Follow')),
    );
  }
}
