import 'package:flutter/material.dart';

import 'models/social_post.dart';
import 'widgets/social_avatar.dart';
import 'widgets/social_post_tile.dart';

class SocialThreadScreen extends StatefulWidget {
  const SocialThreadScreen({required this.post, super.key});

  final SocialPost post;

  @override
  State<SocialThreadScreen> createState() => _SocialThreadScreenState();
}

class _SocialThreadScreenState extends State<SocialThreadScreen> {
  final _replyController = TextEditingController();
  var _liked = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Thread')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SocialPostTile(
                  post: widget.post,
                  liked: _liked,
                  reposted: false,
                  onLike: () => setState(() => _liked = !_liked),
                  onRepost: () {},
                  onOpen: () {},
                ),
                Divider(height: 1, color: colors.outlineVariant),
                const _Reply(
                  avatar: SocialAvatar(initials: 'AT', colors: <Color>[Color(0xFF8A6CFF), Color(0xFFD877FF)]),
                  name: 'Amir Taylor',
                  body: 'That is the difference between decoration and direction. Beautifully put.',
                ),
                const _Reply(
                  avatar: SocialAvatar(initials: 'JO', colors: <Color>[Color(0xFFFF8A5B), Color(0xFFFFC46B)]),
                  name: 'June Okafor',
                  body: 'Motion should answer a question before it asks for attention.',
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: TextField(
                controller: _replyController,
                decoration: InputDecoration(
                  hintText: 'Post your reply',
                  suffixIcon: IconButton(
                    tooltip: 'Send reply',
                    onPressed: () {
                      if (_replyController.text.trim().isEmpty) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply published')));
                      _replyController.clear();
                    },
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Reply extends StatelessWidget {
  const _Reply({required this.avatar, required this.name, required this.body});

  final Widget avatar;
  final String name;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          avatar,
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(body, style: const TextStyle(fontSize: 15, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
