import 'package:flutter/material.dart';

import 'app_identity.dart';
import 'app_theme.dart';
import 'external_actions.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({super.key, this.sharer = shareText});

  final TextSharer sharer;

  @override
  State<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  final GlobalKey _shareButtonKey = GlobalKey();
  bool _isSharing = false;
  String? _errorMessage;

  Future<void> _share() async {
    final RenderObject? renderObject = _shareButtonKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      setState(() => _errorMessage = 'Sharing is temporarily unavailable.');
      return;
    }
    final Rect origin = renderObject.localToGlobal(Offset.zero) & renderObject.size;
    setState(() {
      _isSharing = true;
      _errorMessage = null;
    });
    try {
      await widget.sharer(inviteText, origin);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Sharing is temporarily unavailable.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFFEFEFE),
      child: SafeArea(
        bottom: false,
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: Color(0xFF253840)),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.paddingOf(context).bottom + 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              'assets/images/inviteImage.png',
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Invite Your Friends',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Share ${AppIdentity.name} with friends and fellow developers.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      if (_errorMessage != null) ...<Widget>[
                        const SizedBox(height: 8),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ],
                      const Spacer(),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        key: _shareButtonKey,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(120, 48),
                          backgroundColor: AppTheme.actionBlue,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.grey.withValues(alpha: 0.6),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                        ),
                        onPressed: _isSharing ? null : _share,
                        icon: Icon(_isSharing ? Icons.more_horiz : Icons.share),
                        label: Text(_isSharing ? 'Opening…' : 'Share'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
