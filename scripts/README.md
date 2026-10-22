# Localization tools

Run these tools from the repository root with its configured Flutter SDK.

## Native resources

`fvm dart run scripts/generate_native_localizations.dart` reads every complete ARB catalog and generates macOS menu
tables, Apple language declarations and Android's per-app language configuration. It preserves unrelated project
settings. Add `--check` to verify the checked-in output without writing files.

## Gallery artwork

`generate_gallery_previews.py` renders the actual example widgets using a dedicated disposable iOS simulator and native fonts.
It uses the original 402 × 874 artwork size, light/dark appearances and settled accessible animation states.
The capture entry lives in `capture_gallery_previews.dart`; it is developer tooling, separate from the shipped app.

Create and boot a disposable simulator, then create a temporary review folder and pass its new child output directory
and that simulator's identifier. The rendering target replaces the installed app, so do not use a personal test device.

```sh
mkdir /private/tmp/ui-templates-preview-review
python3 -B scripts/generate_gallery_previews.py \
  --device '<disposable iOS simulator identifier>' \
  --output /private/tmp/ui-templates-preview-review/rendered
```

Optional `--locales fr_FR,zh_Hant_HK` and `--appearances light` select a smaller review batch.
The default covers every catalog and both appearances. The receiver binds only to this Mac's loopback interface,
accepts the expected PNG names and dimensions, and saves a manifest and native test log beside the images.
The capture waits for image providers to finish decoding before reading pixels. Any rendering error, missing image,
timeout or incomplete process cleanup fails the run. The runner retains the app until the disposable simulator is removed.

Review the rendered text and layout, losslessly optimize the still PNGs with ImageOptim, and verify unchanged decoded
pixels, dimensions and transparency before updating shipped assets. Preserve the manifest and test evidence outside
temporary storage, then remove the completed temporary review folder and disposable simulator.

## Runtime lookup coverage

After adding or removing source messages, run `fvm dart run scripts/generate_localization_test.dart` to update the
generated runtime getter inventory. `fvm flutter test test/localization_test.dart` loads every catalog and its gallery
artwork through Flutter's app bundle and checks locale selection, formatting and translated interactions.

## Codemagic workflow timeout

Every workflow uses Codemagic's native `max_build_duration: 30` for a 30-minute limit. Scripts run directly, and signing and built-in publishers keep their existing configuration.

Codemagic's YAML schema has no per-step or built-in store-upload timeout setting. The workflow limit does not establish a separate upload cutoff.
