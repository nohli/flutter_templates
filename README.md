# UI Templates

A free, open-source gallery of Flutter interface examples.

[Try the Flutter web app](https://templates.achim.io).

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="screenshots/readme-hero-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="screenshots/readme-hero-light.png">
  <img alt="UI Templates for Android, iOS, web, Linux, macOS, and Windows" src="screenshots/readme-hero-light.png">
</picture>

The public app has no private backend or telemetry integration; feedback opens a simple support-email draft.

## Run

```sh
fvm flutter pub get
fvm flutter run
```

The first run needs no environment file, extra build flags, account or hosting setup.

## Languages

The app follows the device or per-app language setting. Its 49 complete locale catalogs cover all 34 iOS interface
languages, including Apple's named English, French, Spanish, Portuguese, and Chinese regional variants.
Right-to-left languages use the same examples and navigation. Names, addresses, user-written content, original legal
notices, and the French answers in the language lesson retain their original meaning.

Translations live in `lib/l10n/app_*.arb`. The app uses Flutter's
[generated localizations](https://docs.flutter.dev/ui/internationalization), configured in `l10n.yaml`.
After changing copy, update every catalog and regenerate both Flutter and native resources:

```sh
fvm flutter gen-l10n
fvm dart run scripts/generate_native_localizations.dart
fvm dart run scripts/generate_native_localizations.dart --check
```

Generated Dart files stay out of Git. Native menu tables and language declarations are checked in.
If you reuse an example, install `AppLocalizations.localizationsDelegates` and `AppLocalizations.supportedLocales`
on its `MaterialApp`, as shown in `lib/main.dart`. Keep localized sample identifiers stable when the language changes.
See [the artwork generation instructions](scripts/README.md) when changing the example screens or their translations.

## Architecture

- `lib/app/` owns the app shell, appearance, identity, and shared styling.
- `lib/features/gallery/` lists and opens the examples.
- `lib/features/templates/` keeps each example's screens, widgets, and sample models together; `shared/` holds reusable theme and motion helpers.
- `lib/features/support/` owns help, feedback, invitations, and About.
- `assets/` contains bundled artwork and fonts; `test/` and `integration_test/` cover app behavior.

The examples use sample content and need no backend or hosting account to run.

## Forking and optional releases

Local development requires only Flutter and the dependencies above. The bundle/package ID belongs to this published
gallery; before distributing a fork, choose your own identifiers in the platform projects and iOS signing configuration.
Select your own signing team in Xcode for physical-device builds. Codemagic applies the team from your signing profiles.

Contact settings have generic defaults in `lib/app/app_identity.dart`. Plain `fvm flutter run` uses these defaults;
there is no environment file to create or load. Optional `--dart-define` arguments can override
`SUPPORT_EMAIL`, `PRIVACY_POLICY_URL` and `SUPPORT_URL` at build time.
These values are public and compiled into the app; never pass passwords, API tokens or signing keys this way.

`codemagic.yaml` is an optional release template. Configure your own accounts and signing files in
[Codemagic](https://codemagic.io/apps), then add these app-level environment groups:

| Group | Variables | Used by |
|---|---|---|
| `release_config` | `SUPPORT_EMAIL`, `PRIVACY_POLICY_URL`, `SUPPORT_URL` (public app contacts), `APP_STORE_CONNECT_INTEGRATION` (integration name), `ANDROID_KEYSTORE_REFERENCE` (uploaded keystore reference), `TESTFLIGHT_BETA_GROUP` (tester group name), `SLACK_CHANNEL` (notification channel) | Public contacts for every release and patch, plus the selected workflow's account references |
| `google_play_credentials` | `GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS` (secret service-account JSON) | Android store releases |
| `cloudflare_credentials` | `CLOUDFLARE_ACCOUNT_ID`, `CLOUDFLARE_API_TOKEN` (secret), `CLOUDFLARE_PAGES_PROJECT` | Optional web publishing to your own existing Pages project |
| `shorebird` | `SHOREBIRD_APP_ID`, `SHOREBIRD_TOKEN` (secret) | Optional mobile Code Push |

Account references and deployment destinations have no checked-in owner-specific defaults.
Codemagic passes the contact values from `release_config` directly to Flutter and stops if a release contact value is missing or empty.
`APP_STORE_CONNECT_INTEGRATION` selects a saved Apple API key by its integration name for iOS signing and uploads.
You may replace its environment reference with that exact saved name; keeping the variable lets forks choose their own.
See [Codemagic's Apple integration configuration](https://docs.codemagic.io/yaml-quick-start/building-a-native-ios-app/).
Only iOS releases trigger automatically on `main`; Android, web, and Shorebird workflows are manual.
Publishing requires the selected workflow's account configuration; for a web build without publishing, run
`fvm flutter build web --release`. Optional [Terraform hosting configuration](infrastructure/cloudflare/README.md)
provisions your own Pages project and custom domain.
See [Codemagic's iOS signing](https://docs.codemagic.io/yaml-code-signing/signing-ios/) and
[Android signing](https://docs.codemagic.io/yaml-code-signing/signing-android/) guides for the required signing files.

## Mobile Code Push

Ordinary debug builds need no Shorebird account, CLI, or environment variables.
Only the optional Shorebird release and patch workflows prepare a Shorebird configuration.
The app identifier is bundled into the released app, but is not checked into this repository.
Web and desktop builds are unchanged.

In this application's [Codemagic environment variables](https://codemagic.io/apps), use the
app-local group `shorebird` for `SHOREBIRD_TOKEN` (secret, a current
[console API key](https://docs.shorebird.dev/account/api-keys/)) and `SHOREBIRD_APP_ID`
(the public UUID generated by one-time app registration).
The build creates ignored `shorebird.yaml` and adds it to the asset list in the disposable runner checkout.
Missing or malformed identifiers stop the Shorebird workflow; there is no shared template app ID or placeholder.

`ios` (**iOS**) and `android` (**Android**) use standard Flutter and need no Shorebird variables or configuration.
Only `ios` is automatic on `main`; all Shorebird workflows are manual opt-ins.
`ios_shorebird` (**iOS Shorebird**) and `android_shorebird` (**Android Shorebird**) create patchable baselines
with Shorebird's latest supported Flutter fork (`--flutter-version=latest`), not the runner's ordinary SDK.
Both release routes retain the same signing and publishers: iOS submits to TestFlight and Android to Play internal.
All mobile workflows have explicit readable names and matching build-list labels.
Standard releases cannot receive patches, even after an occasional Shorebird test.
Choose one release route per commit because both routes derive the same store build number.
For an iOS Shorebird test on `main`, cancel the automatic standard build before upload and start **iOS Shorebird**;
do not reuse a build already uploaded to TestFlight.
The manual `ios_shorebird_patch` (**iOS Shorebird Patch**) and
`android_shorebird_patch` (**Android Shorebird Patch**) workflows ask for `release_version` (exact app version plus build),
and **Dry-run** (`dry_run`, off by default, to validate without uploading).
Both workflows always publish to `staging`; there is no track selector or direct production publication.
Dry-run still requires an existing real Shorebird release.
Patches do not publish new store binaries and cannot change native code or assets.
Before production use, verify signed store packaging and patch delivery on physical hardware.
TestFlight installation alone does not subscribe to staging patches;
connect an unlocked test device and use the authenticated CLI with the same registered app ID:
`shorebird preview --app-id '<registered-app-id>' --platform ios --release-version 1.0.0+123 --track staging`.
Replace the placeholders with the existing Codemagic app ID and exact release version and build;
use `android` for an Android device. Preview reinstalls the app and clears its data; use disposable test data.
After download, fully close and reopen the app, then verify the fix.
See [Shorebird's preview instructions](https://docs.shorebird.dev/code-push/preview/#previewing-patches).
After verification, open the app and release in [Shorebird Console](https://console.shorebird.dev) and select
the patch's **⋮ → Change Track → stable** to serve the same tested patch to production.
The retired Shorebird CI service is not used.

## Gallery

Ten reusable examples with system, light, and dark appearances across six Flutter platforms.

### Web

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="screenshots/web-gallery-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="screenshots/web-gallery-light.png">
  <img alt="Web gallery" src="screenshots/web-gallery-light.png">
</picture>

### Mobile

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="screenshots/gallery-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="screenshots/gallery-light.png">
  <img alt="Mobile gallery" src="screenshots/gallery-light.png">
</picture>

## License and attribution

Based on [Best Flutter UI Templates](https://github.com/mitesh77/Best-Flutter-UI-Templates). See [`LICENSE`](LICENSE) and [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).
