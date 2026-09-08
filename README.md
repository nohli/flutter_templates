# UI Templates

UI Templates is an open-source interactive gallery of three mobile interface concepts: hotel booking, fitness tracking, and design courses. It is built with the Flutter SDK and is the canonical source for both the reusable project and the published app under bundle ID `com.achimsapps.templates`.

All names, prices, ratings, reviews, activity values, and other content inside the gallery are fictional examples. UI Templates does not provide hotel booking, fitness tracking, or course enrollment services.

Flutter and the related logo are trademarks of Google LLC. Flutter UI Templates is not affiliated with or otherwise sponsored by Google LLC. The app is now named UI Templates.

## Local setup

Use the repository through FVM:

```sh
fvm flutter pub get
fvm flutter run
```

## Verification

```sh
fvm dart format --output=none --set-exit-if-changed --line-length 120 lib test
fvm dart analyze --fatal-infos
fvm flutter test --coverage
```

## Release ownership

This public repository is the only maintained source and release repository. `codemagic.yaml` builds the existing iOS and Android applications from the same tracked source; signing credentials remain in Codemagic and are never committed.

Canonical store copy and review notes live in [`store/`](store/). Regenerate launcher icons after changing either canonical source image:

```sh
fvm dart run flutter_launcher_icons
```

## Gallery

![Hotel booking interface](assets/hotel/hotel_booking.png)
![Fitness tracking interface](assets/fitness_app/fitness_app.png)
![Design course interface](assets/design_course/design_course.png)

## License and attribution

The project is based on Mitesh Chodvadiya's publicly available [Best Flutter UI Templates](https://github.com/mitesh77/Best-Flutter-UI-Templates) project. See [`LICENSE`](LICENSE) for the preserved repository terms and [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) for upstream asset and bundled-font provenance.
