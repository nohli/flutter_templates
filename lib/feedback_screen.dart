import 'package:flutter/material.dart';

import 'app_identity.dart';
import 'app_theme.dart';
import 'external_actions.dart';

Uri feedbackEmailUri(String message) => appEmailUri(subject: '${AppIdentity.name} feedback', body: message);

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key, this.launcher = launchExternalUri});

  final ExternalUriLauncher launcher;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();
  var _isOpeningEmail = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendFeedback() async {
    final message = _controller.text.trim();
    if (message.isEmpty) {
      setState(() => _errorMessage = 'Enter your feedback before sending.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isOpeningEmail = true;
      _errorMessage = null;
    });
    var launched = false;
    try {
      launched = await widget.launcher(feedbackEmailUri(message));
    } catch (_) {
      launched = false;
    }
    if (!mounted) return;
    setState(() {
      _isOpeningEmail = false;
      _errorMessage = launched ? null : 'No email app is available. Contact ${AppIdentity.supportEmail}.';
    });
    if (launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your email app is ready. Send the message there when you are satisfied.')),
      );
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
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.asset(
                                'assets/images/feedbackImage.png',
                                fit: BoxFit.contain,
                                excludeFromSemantics: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        child: const Text('Your Feedback', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: const Text(
                          'Give your best time for this moment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      _buildComposer(),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                          child: Semantics(
                            liveRegion: true,
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.paddingOf(context).bottom + 24),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(120, 48),
                            backgroundColor: AppTheme.actionBlue,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.grey.withValues(alpha: 0.6),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                          ),
                          onPressed: _isOpeningEmail ? null : _sendFeedback,
                          child: Text(_isOpeningEmail ? 'Opening…' : 'Send'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _controller,
                maxLines: null,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(fontFamily: AppTheme.fontName, fontSize: 16, color: Color(0xFF313A44)),
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your feedback...',
                  hintStyle: TextStyle(color: Color(0xFF4A6572)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
