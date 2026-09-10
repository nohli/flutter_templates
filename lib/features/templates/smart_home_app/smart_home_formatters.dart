import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatEnergy(BuildContext context, num value) {
  final locale = Localizations.localeOf(context).toLanguageTag();

  return NumberFormat.decimalPattern(locale).format(value);
}
