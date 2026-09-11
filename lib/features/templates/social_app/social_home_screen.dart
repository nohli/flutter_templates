import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/social_post.dart';
import 'models/social_section.dart';
import 'sections/social_discover_section.dart';
import 'sections/social_feed_section.dart';
import 'sections/social_profile_section.dart';
import 'social_app_theme.dart';
import 'widgets/social_action_bar.dart';

class SocialHomeScreen extends StatefulWidget {
  const SocialHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  State<SocialHomeScreen> createState() => _SocialHomeScreenState();
}

class _SocialHomeScreenState extends State<SocialHomeScreen> {
  late final _scrollControllers = <SocialSection, ScrollController>{
    for (final section in SocialSection.values) section: ScrollController(),
  };
  final _likedPostIds = <String>{};
  final _savedPostIds = <String>{};
  final _followedCreatorIds = <String>{};

  var _selectedSection = SocialSection.feed;
  var _isPrivate = false;

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: SocialAppTheme.build,
      builder: (BuildContext context) {
        return PrimaryScrollController(
          controller: _scrollControllers[_selectedSection]!,
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      tooltip: 'Back to template gallery',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : null,
              title: const Text(
                'Mingle',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, letterSpacing: -0.7),
              ),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Social notifications',
                  onPressed: () => _showMessage('You are all caught up.'),
                  icon: const Badge(smallSize: 7, child: Icon(Icons.notifications_none_rounded)),
                ),
              ],
            ),
            body: TemplateEntrance(
              child: TemplateSectionSwitcher(
                selectedIndex: _selectedSection.index,
                children: <Widget>[
                  SocialFeedSection(
                    posts: SocialPost.samples,
                    likedPostIds: _likedPostIds,
                    savedPostIds: _savedPostIds,
                    scrollController: _scrollControllers[SocialSection.feed]!,
                    onToggleLiked: _toggleLiked,
                    onToggleSaved: _toggleSaved,
                    onPreviewAction: _showMessage,
                  ),
                  SocialDiscoverSection(
                    scrollController: _scrollControllers[SocialSection.discover]!,
                    followedCreatorIds: _followedCreatorIds,
                    onToggleFollowed: _toggleFollowed,
                  ),
                  SocialProfileSection(
                    scrollController: _scrollControllers[SocialSection.profile]!,
                    posts: SocialPost.samples,
                    savedPostCount: _savedPostIds.length,
                    isPrivate: _isPrivate,
                    onPrivateChanged: (bool value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SocialActionBar(
              selectedSection: _selectedSection,
              onSelected: _selectSection,
              onCreate: () => _showMessage('Post creation is shown as an interface preview.'),
            ),
          ),
        );
      },
    );
  }

  void _selectSection(SocialSection section) {
    if (section == _selectedSection) {
      final controller = _scrollControllers[section]!;
      if (controller.hasClients) {
        if (MediaQuery.disableAnimationsOf(context)) {
          controller.jumpTo(0);
        } else {
          controller.animateTo(0, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
        }
      }
      return;
    }

    setState(() {
      _selectedSection = section;
    });
  }

  void _toggleLiked(SocialPost post) {
    setState(() {
      if (!_likedPostIds.remove(post.id)) {
        _likedPostIds.add(post.id);
      }
    });
  }

  void _toggleSaved(SocialPost post) {
    setState(() {
      if (!_savedPostIds.remove(post.id)) {
        _savedPostIds.add(post.id);
      }
    });
  }

  void _toggleFollowed(String creatorId) {
    setState(() {
      if (!_followedCreatorIds.remove(creatorId)) {
        _followedCreatorIds.add(creatorId);
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
