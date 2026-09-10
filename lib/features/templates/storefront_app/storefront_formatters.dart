import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatStorePrice(BuildContext context, double amount) {
  final locale = Localizations.localeOf(context).toLanguageTag();

  return NumberFormat.simpleCurrency(locale: locale, name: 'USD', decimalDigits: 0).format(amount);
}
