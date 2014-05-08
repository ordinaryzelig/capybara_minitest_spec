require "capybara_minitest_spec/version"

require 'minitest/autorun'
require 'minitest/spec'
require 'capybara'
require 'capybara/rspec/matchers'
require "capybara_minitest_spec/test_name"

module CapybaraMiniTestSpec

  module_function

  # Define assertions and spec expectations for both positive and negative forms of the matcher name.
  def add_matcher(matcher_name)
    positive_name = CapybaraMiniTestSpec::PositiveTestName.new(matcher_name)
    negative_name = CapybaraMiniTestSpec::NegativeTestName.new(matcher_name)
    [positive_name, negative_name].each do |test_name|
      CapybaraMiniTestSpec.define_expectation(test_name)
    end
  end

  def define_expectation(test_name)
    define_assertion(test_name)
    infect_assertion(test_name)
  end

  # Define an assertion using test_name.
  # For example, if the test name is have_css,
  # the assertion would be called assert_page_has_css.
  #
  # Use either of Capybara::RSpecMatchers.
  # Assert that it matches, and pass its failure message if it doesn't.
  def define_assertion(test_name)
    method_name = test_name.assertion_name
    MiniTest::Assertions.send :define_method, method_name do |page, *args|
      matcher = test_name.matcher(*args)

      matches = matcher.send(test_name.match_method, page)
      failure_message = message do
        matcher.send(test_name.failure_message_method)
      end

      assert matches, failure_message
    end
  end

  # Define the MiniTest::Spec expectation.
  def infect_assertion(test_name)
    MiniTest::Expectations.infect_an_assertion test_name.assertion_name, test_name.expectation_name, true
  end

end

# For each Capybara RSpec matcher name,
# define positive and negative MiniTest::Unit assertions and
# infect both assertions to create MiniTest::Spec expectations.
Capybara::RSpecMatchers.public_instance_methods.each do |matcher_name|
  CapybaraMiniTestSpec.add_matcher(matcher_name)
end
