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
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
      children: <Widget>[
        const Text('Find your next spark.', style: TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w800)),
        const SizedBox(height: 18),
        const TextField(
          decoration: InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Search people and ideas'),
        ),
        const SizedBox(height: 26),
        const Text('Trending now', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        const _TopicGrid(),
        const SizedBox(height: 28),
        const Text('People to know', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
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
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          boxShadow: SocialAppTheme.softShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(icon, size: 32, color: SocialAppTheme.ink),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(name.characters.first, style: const TextStyle(color: SocialAppTheme.ink)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(role),
      trailing: FilledButton.tonal(onPressed: onToggleFollowed, child: Text(isFollowed ? 'Following' : 'Follow')),
    );
  }
}
