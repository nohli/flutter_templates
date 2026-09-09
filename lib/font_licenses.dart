import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

var _areFontLicensesRegistered = false;

void registerBundledFontLicenses() {
  if (_areFontLicensesRegistered) return;
  _areFontLicensesRegistered = true;

  LicenseRegistry.addLicense(() async* {
    final workSansLicense = await rootBundle.loadString('assets/fonts/WorkSans-LICENSE.txt');
    final robotoLicense = await rootBundle.loadString('assets/fonts/Roboto-LICENSE.txt');
    final smoothStarRatingLicense = await rootBundle.loadString('assets/licenses/smooth_star_rating-LICENSE.txt');

    yield LicenseEntryWithLineBreaks(<String>['Work Sans'], workSansLicense);
    yield LicenseEntryWithLineBreaks(<String>['Roboto'], robotoLicense);
    yield LicenseEntryWithLineBreaks(<String>['Smooth Star Rating'], smoothStarRatingLicense);
  });
}
