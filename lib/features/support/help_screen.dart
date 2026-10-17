import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import 'external_actions.dart';
import 'illustrated_support_layout.dart';
import '../../l10n/localizations.dart';
import 'support_error.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, this.launcher = launchExternalUri});

  final ExternalUriLauncher launcher;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  var _isOpeningEmail = false;
  SupportError? _error;

  Future<void> _openSupport() async {
    setState(() {
      _isOpeningEmail = true;
      _error = null;
    });
    var launched = false;
    try {
      launched = await widget.launcher(supportEmailUri(context.l10n));
    } catch (_) {
      launched = false;
    }
    if (!mounted) return;
    setState(() {
      _isOpeningEmail = false;
      _error = launched ? null : SupportError.emailUnavailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = colors.brightness == Brightness.dark;
    final foreground = isDark ? colors.onSurface : AppTheme.darkText;
    final actionBackground = isDark ? colors.primary : AppTheme.actionBlue;
    final actionForeground = isDark ? colors.onPrimary : Colors.white;

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foreground),
          child: IllustratedSupportLayout(
            illustrationPath: 'assets/images/helpImage.png',
            content: <Widget>[
              const SizedBox(height: 8),
              Text(
                context.l10n.helpTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(context.l10n.helpDescription, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              if (_error case final error?) ...<Widget>[
                const SizedBox(height: 8),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    error.message(context.l10n),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ],
            action: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(140, 48),
                backgroundColor: actionBackground,
                foregroundColor: actionForeground,
                elevation: 8,
                shadowColor: (isDark ? colors.shadow : Colors.grey).withValues(alpha: 0.6),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              onPressed: _isOpeningEmail ? null : _openSupport,
              child: Text(_isOpeningEmail ? context.l10n.opening : context.l10n.emailUs),
            ),
          ),
        ),
      ),
    );
  }
}
