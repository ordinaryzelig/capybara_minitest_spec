require 'bundler/setup'

require 'minitest/autorun'
require 'awesome_print'

require 'capybara/dsl'
require 'capybara_minitest_spec'

# Make all specs a subclass of MiniTest::Spec.
MiniTest::Spec.register_spec_type //, MiniTest::Spec

# Bridge some gaps between RSpec and MiniTest.
class MiniTest::Spec

  class << self
    alias_method :context, :describe
  end

  alias_method :expect, :proc

end

module MiniTest::Assertions

  # Yield, rescue, compare exception's message.
  def assert_raises_with_message(exception_message)
    yield
  rescue Exception => exception
    exception_raised = true
    assert_match exception_message, exception.message
  ensure
    assert exception_raised, 'expected exception to be raised'
  end

end

module MiniTest::Expectations
  infect_an_assertion :assert_raises_with_message, :must_raise_with_message
end
