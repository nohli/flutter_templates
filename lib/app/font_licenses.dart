import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

var _areFontLicensesRegistered = false;

void registerBundledFontLicenses() {
  if (_areFontLicensesRegistered) return;
  _areFontLicensesRegistered = true;

  LicenseRegistry.addLicense(() async* {
    final workSansLicense = await rootBundle.loadString('assets/fonts/WorkSans-LICENSE.txt');
    final robotoLicense = await rootBundle.loadString('assets/fonts/Roboto-LICENSE.txt');
    final archivoBlackLicense = await rootBundle.loadString('assets/fonts/ArchivoBlack-LICENSE.txt');
    final anybodyLicense = await rootBundle.loadString('assets/fonts/Anybody-LICENSE.txt');
    final bricolageGrotesqueLicense = await rootBundle.loadString('assets/fonts/BricolageGrotesque-LICENSE.txt');
    final dmSerifDisplayLicense = await rootBundle.loadString('assets/fonts/DMSerifDisplay-LICENSE.txt');
    final frauncesLicense = await rootBundle.loadString('assets/fonts/Fraunces-LICENSE.txt');
    final instrumentSerifLicense = await rootBundle.loadString('assets/fonts/InstrumentSerif-LICENSE.txt');
    final spaceGroteskLicense = await rootBundle.loadString('assets/fonts/SpaceGrotesk-LICENSE.txt');
    final syneLicense = await rootBundle.loadString('assets/fonts/Syne-LICENSE.txt');
    final unboundedLicense = await rootBundle.loadString('assets/fonts/Unbounded-LICENSE.txt');
    final smoothStarRatingLicense = await rootBundle.loadString('assets/licenses/smooth_star_rating-LICENSE.txt');

    yield LicenseEntryWithLineBreaks(<String>['Work Sans'], workSansLicense);
    yield LicenseEntryWithLineBreaks(<String>['Roboto'], robotoLicense);
    yield LicenseEntryWithLineBreaks(<String>['Archivo Black'], archivoBlackLicense);
    yield LicenseEntryWithLineBreaks(<String>['Anybody'], anybodyLicense);
    yield LicenseEntryWithLineBreaks(<String>['Bricolage Grotesque'], bricolageGrotesqueLicense);
    yield LicenseEntryWithLineBreaks(<String>['DM Serif Display'], dmSerifDisplayLicense);
    yield LicenseEntryWithLineBreaks(<String>['Fraunces'], frauncesLicense);
    yield LicenseEntryWithLineBreaks(<String>['Instrument Serif'], instrumentSerifLicense);
    yield LicenseEntryWithLineBreaks(<String>['Space Grotesk'], spaceGroteskLicense);
    yield LicenseEntryWithLineBreaks(<String>['Syne'], syneLicense);
    yield LicenseEntryWithLineBreaks(<String>['Unbounded'], unboundedLicense);
    yield LicenseEntryWithLineBreaks(<String>['Smooth Star Rating'], smoothStarRatingLicense);
  });
}
