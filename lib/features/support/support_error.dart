import '../../app/app_identity.dart';
import '../../l10n/localizations.dart';

enum SupportError {
  feedbackRequired,
  emailUnavailable,
  sharingUnavailable;

  String message(AppLocalizations l10n) => switch (this) {
    SupportError.feedbackRequired => l10n.feedbackRequired,
    SupportError.emailUnavailable => l10n.emailUnavailable(AppIdentity.supportEmail),
    SupportError.sharingUnavailable => l10n.sharingUnavailable,
  };
}
