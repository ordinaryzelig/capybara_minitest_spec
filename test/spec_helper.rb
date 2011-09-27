require 'bundler/setup'

require 'minitest/autorun'
require 'capybara/dsl'

require 'capybara_minitest_spec'

# Make all specs a subclass of MiniTest::Spec.
MiniTest::Spec.register_spec_type //, MiniTest::Spec

# Setup Rack test app.
$LOAD_PATH << File.join(__FILE__, '../../test_app')
require 'test_app'
Capybara.app = TestApp

# Set Capybara default selector to xpath.
class MiniTest::Spec
  before :each do
    Capybara.configure do |config|
      config.default_selector = :xpath
    end
  end
end
