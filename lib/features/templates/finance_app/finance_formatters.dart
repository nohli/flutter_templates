import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatCurrency(BuildContext context, double amount, {int decimalDigits = 2}) {
  final locale = Localizations.localeOf(context).toLanguageTag();

  return NumberFormat.simpleCurrency(locale: locale, name: 'USD', decimalDigits: decimalDigits).format(amount);
}

String formatPercentage(BuildContext context, double fraction, {int decimalDigits = 0}) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final formatter = NumberFormat.percentPattern(locale)
    ..minimumFractionDigits = decimalDigits
    ..maximumFractionDigits = decimalDigits;

  return formatter.format(fraction);
}
