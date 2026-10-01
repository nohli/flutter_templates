require 'yaml'

app_id = ENV.fetch('SHOREBIRD_APP_ID', '')
abort 'Set SHOREBIRD_APP_ID to the registered app UUID in this Codemagic application' unless
  app_id.match?(/\A[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}\z/)

source = File.read('pubspec.yaml')
pubspec = YAML.safe_load(source, aliases: true)
assets = pubspec.fetch('flutter').fetch('assets')
abort 'Expected the Flutter assets list in pubspec.yaml' unless assets.is_a?(Array)

prepared = source
unless assets.include?('shorebird.yaml')
  abort 'Expected exactly one Flutter assets section' unless source.scan(/^  assets:$/).length == 1

  prepared = source.sub(/^  assets:$/, "  assets:\n    - shorebird.yaml")
  bundled = YAML.safe_load(prepared, aliases: true).fetch('flutter').fetch('assets')
  abort 'Could not add Shorebird to the Flutter asset bundle' unless bundled == ['shorebird.yaml', *assets]
end

File.write('shorebird.yaml', YAML.dump('app_id' => app_id))
File.write('pubspec.yaml', prepared) unless prepared == source
