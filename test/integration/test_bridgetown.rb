require_relative 'integration_test_helper'

# This is for testing various tag params. It pulls in presets to make sure
# they're checked correctly, but it's focused on tag arguments.
class TestBridgetown < Minitest::Test
  include IntegrationTestHelper

  ROOT_DIR = File.expand_path('fixtures', "#{__dir__}/../")
  SOURCE_DIR = File.join(ROOT_DIR, 'src')
  DEST_DIR = File.expand_path('dest', "#{__dir__}/../")

  def setup
    config = Bridgetown.configuration(
      Bridgetown::Utils
        .deep_merge_hashes(
          {
            'full_rebuild' => true,
            'root_dir' => ROOT_DIR,
            'source' => SOURCE_DIR,
            'destination' => DEST_DIR
          },
          {}
        )
    ).tap do |conf|
      conf.run_initializers! context: :static
    end

    @site = Bridgetown::Site.new(config)
    @site.process
  end

  def test_hello
    assert File.exist?(File.join(DEST_DIR, 'pestka.jpg'))
    assert File.exist?(File.join(DEST_DIR, 'generated_dir', 'pestka-75-5a2d24bac.jpg'))
  end

  def teardown
    cleanup_files
    # FileUtils.rm_rf(DEST_DIR)
    # FileUtils.rm_rf(File.join(ROOT_DIR, ".bridgetown-cache"))
  end
end
