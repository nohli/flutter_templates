require 'fileutils'
require 'minitest/autorun'
require 'open3'
require 'tmpdir'
require 'yaml'

class PrepareShorebirdTest < Minitest::Test
  APP_ID = '00000000-0000-4000-8000-000000000001'
  ROOT = File.expand_path('..', __dir__)
  SCRIPT = File.join(__dir__, 'prepare_shorebird.rb')

  def setup
    @directory = Dir.mktmpdir('template-config-', ENV.fetch('SHOREBIRD_TEST_ROOT'))
    @original = File.read(File.join(ROOT, 'pubspec.yaml'))
    File.write(File.join(@directory, 'pubspec.yaml'), @original)
  end

  def teardown
    FileUtils.remove_entry(@directory)
  end

  def test_missing_id_leaves_debug_configuration_untouched
    output, error, result = prepare(nil)

    refute result.success?, output + error
    assert_match(/Set SHOREBIRD_APP_ID/, error)
    assert_equal @original, File.read(File.join(@directory, 'pubspec.yaml'))
    refute File.exist?(File.join(@directory, 'shorebird.yaml'))
  end

  def test_invalid_ids_do_not_write_configuration
    ['', 'secret-value', "#{APP_ID}\napp_id: another", '00000000-0000-4000-8000-00000000000z'].each do |id|
      output, error, result = prepare(id)

      refute result.success?, output + error
      assert_equal @original, File.read(File.join(@directory, 'pubspec.yaml'))
      refute File.exist?(File.join(@directory, 'shorebird.yaml'))
    end
  end

  def test_valid_id_is_bundled_without_other_manifest_changes
    output, error, result = prepare(APP_ID)

    assert result.success?, output + error
    assert_equal({'app_id' => APP_ID}, YAML.safe_load(File.read(File.join(@directory, 'shorebird.yaml'))))
    expected = @original.sub(/^  assets:$/, "  assets:\n    - shorebird.yaml")
    assert_equal expected, File.read(File.join(@directory, 'pubspec.yaml'))
  end

  def test_repeated_preparation_does_not_duplicate_the_asset
    2.times do
      output, error, result = prepare(APP_ID)
      assert result.success?, output + error
    end

    prepared = File.read(File.join(@directory, 'pubspec.yaml'))
    assert_equal 1, YAML.safe_load(prepared).fetch('flutter').fetch('assets').count('shorebird.yaml')
  end

  def test_unexpected_manifest_fails_before_writing_configuration
    changed = @original.sub(/^  assets:$/, '  assets: []')
    File.write(File.join(@directory, 'pubspec.yaml'), changed)
    output, error, result = prepare(APP_ID)

    refute result.success?, output + error
    assert_equal changed, File.read(File.join(@directory, 'pubspec.yaml'))
    refute File.exist?(File.join(@directory, 'shorebird.yaml'))
  end

  def test_non_list_assets_fail_before_writing_configuration
    changed = "flutter:\n  assets: invalid\n"
    File.write(File.join(@directory, 'pubspec.yaml'), changed)
    output, error, result = prepare(APP_ID)

    refute result.success?, output + error
    assert_match(/Expected the Flutter assets list/, error)
    assert_equal changed, File.read(File.join(@directory, 'pubspec.yaml'))
    refute File.exist?(File.join(@directory, 'shorebird.yaml'))
  end

  def test_ambiguous_assets_sections_fail_before_writing_configuration
    changed = @original + "\nother:\n  assets:\n    - unrelated\n"
    File.write(File.join(@directory, 'pubspec.yaml'), changed)
    output, error, result = prepare(APP_ID)

    refute result.success?, output + error
    assert_match(/Expected exactly one Flutter assets section/, error)
    assert_equal changed, File.read(File.join(@directory, 'pubspec.yaml'))
    refute File.exist?(File.join(@directory, 'shorebird.yaml'))
  end

  def test_an_unrelated_assets_header_is_not_rewritten
    changed = "flutter: {assets: [original]}\nother:\n  assets:\n    - unrelated\n"
    File.write(File.join(@directory, 'pubspec.yaml'), changed)
    output, error, result = prepare(APP_ID)

    refute result.success?, output + error
    assert_match(/Could not add Shorebird/, error)
    assert_equal changed, File.read(File.join(@directory, 'pubspec.yaml'))
    refute File.exist?(File.join(@directory, 'shorebird.yaml'))
  end

  private

  def prepare(id)
    Open3.capture3({'SHOREBIRD_APP_ID' => id}, RbConfig.ruby, SCRIPT, chdir: @directory)
  end
end
