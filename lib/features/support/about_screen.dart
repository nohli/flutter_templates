import 'package:flutter/material.dart';

import '../../app/app_identity.dart';
import '../../app/app_theme.dart';
import 'external_actions.dart';
import '../../l10n/localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, this.launcher = launchExternalUri});

  final ExternalUriLauncher launcher;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  var _isOpeningLink = false;

  Future<void> _open(Uri uri) async {
    if (_isOpeningLink) return;

    setState(() {
      _isOpeningLink = true;
    });
    try {
      final launched = await widget.launcher(uri);
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
    final colors = Theme.of(context).colorScheme;
    final isDark = colors.brightness == Brightness.dark;
    final foreground = isDark ? colors.onSurface : AppTheme.darkText;
    final linkForeground = isDark ? colors.primary : AppTheme.actionBlue;
    final linkStyle = TextButton.styleFrom(minimumSize: const Size(0, 48), foregroundColor: linkForeground);

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 24, 16, MediaQuery.paddingOf(context).bottom + 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: foreground),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      AppIdentity.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(context.l10n.appSummary, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.sampleContentNotice,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.openSource,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.sourceAttribution,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: _isOpeningLink ? null : () => _open(AppIdentity.sourceUri),
                      icon: const Icon(Icons.code),
                      label: Text(context.l10n.sourceCode),
                    ),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: () => showLicensePage(context: context, applicationName: AppIdentity.name),
                      icon: const Icon(Icons.description_outlined),
                      label: Text(context.l10n.openSourceLicenses),
                    ),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: _isOpeningLink ? null : () => _open(AppIdentity.privacyPolicyUri),
                      icon: const Icon(Icons.privacy_tip_outlined),
                      label: Text(context.l10n.privacyPolicy),
                    ),
                    TextButton.icon(
                      style: linkStyle,
                      onPressed: _isOpeningLink ? null : () => _open(developerPortfolioUri),
                      icon: const Icon(Icons.language),
                      label: Text(context.l10n.developerPortfolio),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.trademarkNotice,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.trademarkDisclaimer,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
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
