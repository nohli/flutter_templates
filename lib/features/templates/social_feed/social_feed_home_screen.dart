import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/social_post.dart';
import 'social_compose_screen.dart';
import 'social_feed_theme.dart';
import 'social_thread_screen.dart';
import 'widgets/social_avatar.dart';
import 'widgets/social_post_tile.dart';

class SocialFeedHomeScreen extends StatelessWidget {
  const SocialFeedHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: appearance,
      themeBuilder: SocialFeedTheme.build,
      builder: (BuildContext context) => const _SocialFeedHome(),
    );
  }
}

class _SocialFeedHome extends StatefulWidget {
  const _SocialFeedHome();

  @override
  State<_SocialFeedHome> createState() => _SocialFeedHomeState();
}

class _SocialFeedHomeState extends State<_SocialFeedHome> {
  final _scrollController = ScrollController();
  final _liked = <int>{};
  final _reposted = <int>{};
  var _tab = 0;
  String? _publishedPost;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PrimaryScrollController(
      controller: _scrollController,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Create a post',
          onPressed: _compose,
          child: const Icon(Icons.edit_rounded),
        ),
        bottomNavigationBar: const _SocialNavigation(),
        body: SafeArea(
          bottom: false,
          child: TemplateEntrance(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  leading: IconButton(
                    tooltip: 'Back to template gallery',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  title: const Text('PULSE', style: TextStyle(fontSize: 19, letterSpacing: 2.8)),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(tooltip: 'Feed settings', onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(49),
                    child: _FeedTabs(selectedIndex: _tab, onSelected: (int value) => setState(() => _tab = value)),
                  ),
                ),
                if (_publishedPost case final post?)
                  SliverToBoxAdapter(
                    child: _PublishedPost(body: post, onDismiss: () => setState(() => _publishedPost = null)),
                  ),
                SliverToBoxAdapter(child: _FeedMoment(tab: _tab)),
                SliverList.separated(
                  itemCount: SocialPost.samples.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: colors.outlineVariant),
                  itemBuilder: (BuildContext context, int index) {
                    final post = SocialPost.samples[index];
                    return SocialPostTile(
                      post: post,
                      liked: _liked.contains(index),
                      reposted: _reposted.contains(index),
                      onLike: () => setState(() => _liked.contains(index) ? _liked.remove(index) : _liked.add(index)),
                      onRepost: () =>
                          setState(() => _reposted.contains(index) ? _reposted.remove(index) : _reposted.add(index)),
                      onOpen: () => _openThread(post),
                    );
                  },
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 88)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _compose() async {
    final post = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute<String>(builder: (_) => const SocialComposeScreen()));
    if (!mounted || post == null) {
      return;
    }
    setState(() => _publishedPost = post);
  }

  void _openThread(SocialPost post) {
    unawaited(
      Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => SocialThreadScreen(post: post))),
    );
  }
}

class _FeedTabs extends StatelessWidget {
  const _FeedTabs({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _FeedTab(label: 'For you', selected: selectedIndex == 0, onTap: () => onSelected(0)),
        _FeedTab(label: 'Following', selected: selectedIndex == 1, onTap: () => onSelected(1)),
      ],
    );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 44,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? colors.onSurface : colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 4,
              width: selected ? 34 : 0,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedMoment extends StatelessWidget {
  const _FeedMoment({required this.tab});

  final int tab;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.fromLTRB(18, 18, 16, 17),
      decoration: BoxDecoration(
        color: colors.onSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tab == 0 ? 'LIVE / DESIGN WEEK' : 'FROM YOUR CIRCLE',
                  style: TextStyle(color: colors.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                Text(
                  tab == 0 ? 'What people are building right now.' : 'The latest from people you chose.',
                  style: TextStyle(color: colors.surface, fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_outward_rounded, color: colors.surface),
        ],
      ),
    );
  }
}

class _PublishedPost extends StatelessWidget {
  const _PublishedPost({required this.body, required this.onDismiss});

  final String body;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.primary.withValues(alpha: 0.08),
      padding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
      child: Row(
        children: <Widget>[
          const SocialAvatar(initials: 'YO', colors: <Color>[SocialFeedTheme.accent, Color(0xFFFFA65B)], radius: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(body, maxLines: 3, overflow: TextOverflow.ellipsis)),
          IconButton(tooltip: 'Dismiss published post', onPressed: onDismiss, icon: const Icon(Icons.close_rounded)),
        ],
      ),
    );
  }
}

class _SocialNavigation extends StatelessWidget {
  const _SocialNavigation();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
        ),
        child: const SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.home_filled),
              Icon(Icons.search_rounded),
              Badge(smallSize: 7, child: Icon(Icons.notifications_none_rounded)),
              Icon(Icons.mail_outline_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
