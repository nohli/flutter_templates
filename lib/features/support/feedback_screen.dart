import 'package:flutter/material.dart';

import '../../app/app_identity.dart';
import '../../app/app_theme.dart';
import 'external_actions.dart';
import 'illustrated_support_layout.dart';
import '../../l10n/localizations.dart';
import 'support_error.dart';

Uri feedbackEmailUri(String message, AppLocalizations l10n) =>
    appEmailUri(subject: l10n.feedbackEmailSubject(AppIdentity.name), body: message);

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key, this.launcher = launchExternalUri});

  final ExternalUriLauncher launcher;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();
  var _isOpeningEmail = false;
  SupportError? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendFeedback() async {
    final message = _controller.text.trim();
    if (message.isEmpty) {
      setState(() => _error = SupportError.feedbackRequired);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isOpeningEmail = true;
      _error = null;
    });
    var launched = false;
    try {
      launched = await widget.launcher(feedbackEmailUri(message, context.l10n));
    } catch (_) {
      launched = false;
    }
    if (!mounted) return;
    setState(() {
      _isOpeningEmail = false;
      _error = launched ? null : SupportError.emailUnavailable;
    });
    if (launched) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.emailReady)));
    }
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
            illustrationPath: 'assets/images/feedbackImage.png',
            content: <Widget>[
              const SizedBox(height: 8),
              Text(context.l10n.feedbackTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(context.l10n.feedbackDescription, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              _buildComposer(),
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
                minimumSize: const Size(120, 48),
                backgroundColor: actionBackground,
                foregroundColor: actionForeground,
                elevation: 8,
                shadowColor: (isDark ? colors.shadow : Colors.grey).withValues(alpha: 0.6),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              onPressed: _isOpeningEmail ? null : _sendFeedback,
              child: Text(_isOpeningEmail ? context.l10n.opening : context.l10n.send),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    final colors = Theme.of(context).colorScheme;
    final isDark = colors.brightness == Brightness.dark;
    final surface = isDark ? Color.alphaBlend(colors.onSurface.withValues(alpha: 0.16), colors.surface) : Colors.white;
    final foreground = isDark ? colors.onSurface : AppTheme.darkGrey;
    final hint = isDark ? colors.onSurfaceVariant : AppTheme.lightText;

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
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
            color: surface,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: _controller,
                maxLines: null,
                onChanged: (_) {
                  if (_error != null) {
                    setState(() => _error = null);
                  }
                },
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 16, color: foreground),
                cursorColor: colors.primary,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: context.l10n.feedbackHint,
                  hintStyle: TextStyle(color: hint),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
