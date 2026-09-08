import 'package:flutter/material.dart';

import 'app_identity.dart';
import 'app_theme.dart';
import 'external_actions.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, this.launcher = launchExternalUri});

  final ExternalUriLauncher launcher;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  var _isOpeningEmail = false;
  String? _errorMessage;

  Future<void> _openSupport() async {
    setState(() {
      _isOpeningEmail = true;
      _errorMessage = null;
    });
    var launched = false;
    try {
      launched = await widget.launcher(supportEmailUri());
    } catch (_) {
      launched = false;
    }
    if (!mounted) return;
    setState(() {
      _isOpeningEmail = false;
      _errorMessage = launched ? null : 'No email app is available. Contact ${AppIdentity.supportEmail}.';
    });
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
                              'assets/images/helpImage.png',
                              fit: BoxFit.contain,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'How can we help you?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Questions or problems with a template? Email us and we will help.',
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
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(140, 48),
                          backgroundColor: AppTheme.actionBlue,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.grey.withValues(alpha: 0.6),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                        ),
                        onPressed: _isOpeningEmail ? null : _openSupport,
                        child: Text(_isOpeningEmail ? 'Opening…' : 'Email Us'),
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
