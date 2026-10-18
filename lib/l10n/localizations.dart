import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension AppLocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension LocalizedFormatting on AppLocalizations {
  String number(num value, {int? decimalDigits, int minimumIntegerDigits = 1}) {
    final formatter = NumberFormat.decimalPattern(localeName)..minimumIntegerDigits = minimumIntegerDigits;
    if (decimalDigits != null) {
      formatter
        ..minimumFractionDigits = decimalDigits
        ..maximumFractionDigits = decimalDigits;
    }

    return formatter.format(value);
  }

  String money(num value, String currency, {int decimalDigits = 2}) =>
      NumberFormat.simpleCurrency(locale: localeName, name: currency, decimalDigits: decimalDigits).format(value);

  String percent(num fraction, {int decimalDigits = 0}) {
    final formatter = NumberFormat.percentPattern(localeName)
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;

    return formatter.format(fraction);
  }

  String clock(int hour, int minute) => DateFormat.Hm(localeName).format(DateTime(2000, 1, 1, hour, minute));
}
