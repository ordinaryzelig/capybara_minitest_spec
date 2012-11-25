require 'bundler/setup'

require 'minitest/autorun'
require 'awesome_print'

require 'capybara/dsl'
require 'capybara_minitest_spec'

# Make all specs a subclass of MiniTest::Spec.
MiniTest::Spec.register_spec_type //, MiniTest::Spec

# Setup Rack test app.
$LOAD_PATH << File.join(__FILE__, '../../test_app')
require 'test_app'
Capybara.app = TestApp
