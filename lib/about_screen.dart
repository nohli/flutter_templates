import 'package:flutter/material.dart';

import 'app_identity.dart';
import 'app_theme.dart';
import 'external_actions.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, this.launcher = launchExternalUri});

  final ExternalUriLauncher launcher;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isOpeningLink = false;

  Future<void> _open(Uri uri) async {
    if (_isOpeningLink) return;

    setState(() {
      _isOpeningLink = true;
    });
    try {
      final bool launched = await widget.launcher(uri);
      if (!launched) debugPrint('Could not open $uri.');
    } catch (error) {
      debugPrint('Could not open $uri: $error');
    }
    if (!mounted) return;
    setState(() {
      _isOpeningLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showUpstreamSource = Theme.of(context).platform != TargetPlatform.android;
    final ButtonStyle linkStyle = TextButton.styleFrom(
      minimumSize: const Size(0, 48),
      foregroundColor: AppTheme.actionBlue,
    );

    return ColoredBox(
      color: const Color(0xFFFEFEFE),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.paddingOf(context).bottom + 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Color(0xFF253840)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      AppIdentity.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(AppIdentity.summary, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    const Text(
                      AppIdentity.sampleContentNotice,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Open source',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'UI Templates is based on a publicly available interface gallery by Mitesh Chodvadiya. The complete inherited terms, third-party notices, and source history are available in the repository.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: _isOpeningLink ? null : () => _open(AppIdentity.sourceUri),
                      icon: const Icon(Icons.code),
                      label: const Text('UI Templates source code'),
                    ),
                    if (showUpstreamSource)
                      TextButton.icon(
                        style: linkStyle,
                        onPressed: _isOpeningLink ? null : () => _open(AppIdentity.upstreamSourceUri),
                        icon: const Icon(Icons.history),
                        label: const Text('Original open-source project'),
                      ),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: () => showLicensePage(context: context, applicationName: AppIdentity.name),
                      icon: const Icon(Icons.description_outlined),
                      label: const Text('Open-source licenses'),
                    ),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: _isOpeningLink ? null : () => _open(AppIdentity.privacyPolicyUri),
                      icon: const Icon(Icons.privacy_tip_outlined),
                      label: const Text('Privacy Policy'),
                    ),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: _isOpeningLink ? null : () => _open(developerPortfolioUri),
                      icon: const Icon(Icons.language),
                      label: const Text('Developer portfolio'),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Trademark notice',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppIdentity.trademarkDisclaimer,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
