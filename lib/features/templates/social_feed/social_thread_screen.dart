import 'package:flutter/material.dart';

import 'models/social_post.dart';
import 'widgets/social_avatar.dart';
import 'widgets/social_post_tile.dart';
import '../../../l10n/localizations.dart';

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
      appBar: AppBar(title: Text(context.l10n.thread)),
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
                _Reply(
                  avatar: const SocialAvatar(initials: 'AT', colors: <Color>[Color(0xFF8A6CFF), Color(0xFFD877FF)]),
                  name: 'Amir Taylor',
                  body: context.l10n.thatIsTheDifferenceBetweenDecorationAndDirectionBeautifullyPut,
                ),
                _Reply(
                  avatar: const SocialAvatar(initials: 'JO', colors: <Color>[Color(0xFFFF8A5B), Color(0xFFFFC46B)]),
                  name: 'June Okafor',
                  body: context.l10n.motionShouldAnswerAQuestionBeforeItAsksForAttention,
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
                  hintText: context.l10n.postYourReply,
                  suffixIcon: IconButton(
                    tooltip: context.l10n.sendReply,
                    onPressed: () {
                      if (_replyController.text.trim().isEmpty) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.replyPublished)));
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
