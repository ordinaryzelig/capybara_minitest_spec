require 'bundler/setup'

require 'minitest/autorun'
require 'capybara/dsl'

require 'capybara_minitest_spec'

MiniTest::Spec.register_spec_type //, MiniTest::Spec

$LOAD_PATH << File.join(__FILE__, '../../test_app')
require 'test_app'
Capybara.app = TestApp

class MiniTest::Spec
  before :each do
    Capybara.configure do |config|
      config.default_selector = :xpath
    end
  end
end

class Proc
  include MiniTest::Assertions
  # TODO: Replace this with a real assertion that checks the message.
  def must_raise(exception_or_message)
    exception = assert_raises(MiniTest::Assertion, &self)
  end
end
