require 'minitest/spec'
require "capybara_minitest_spec/version"

# Define assertions for each Capybara node matcher.
# Then define MiniTest::Spec expectations.
module MiniTest::Expectations

  Capybara::Node::Matchers.public_instance_methods.each do |matcher_name|

    without_question_mark = matcher_name.to_s.sub /\?$/, ''
    have = without_question_mark.sub /has_/, 'have_'

    # Define positive assertion.
    positive_assertion_name = :"assert_page_#{without_question_mark}"
    define_method positive_assertion_name do |page, *args|
      assert wrap(page).send(matcher_name, *args), positive_failure_message(matcher_name, *args)
    end

    # Infect positive assertion.
    positive_expectation_name = :"must_#{have}"
    infect_an_assertion positive_assertion_name, positive_expectation_name, true

    # Define negative assertion.
    negative_assertion_name = :"refute_page_#{without_question_mark}"
    define_method negative_assertion_name do |page, *args|
      refute wrap(page).send(matcher_name, *args), negative_failure_message(matcher_name, *args)
    end

    # Infect negative assertions.
    negative_expectation_name = :"wont_#{have}"
    infect_an_assertion negative_assertion_name, negative_expectation_name, true

  end

  private

  # Copied from Capybara::RSpecMatchers::HaveMatcher.
  def wrap(actual)
    if actual.respond_to?("has_selector?")
      actual
    else
      Capybara.string(actual.to_s)
    end
  end

  def base_failure_message(matcher_name, *args)
    "#{matcher_name}(#{args.map(&:inspect).join(', ')})"
  end

  def positive_failure_message(matcher_name, *args)
    "Matcher failed: #{base_failure_message(matcher_name, *args)}"
  end

  def negative_failure_message(matcher_name, *args)
    "Matcher should have failed: #{base_failure_message(matcher_name, *args)}"
  end

end
