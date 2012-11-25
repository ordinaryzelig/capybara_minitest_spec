require 'minitest/spec'
require 'capybara'
require "capybara_minitest_spec/matcher"
require "capybara_minitest_spec/version"

matcher_names = Capybara::Node::Matchers.public_instance_methods
matcher_names.delete(:==) # Can't define 'must_=='.

# For each Capybara node matcher,
# define positive and negative MiniTest::Unit assertions and
# infect both assertions to create MiniTest::Spec expectations.
matcher_names.each do |matcher_name|
  CapybaraMiniTestSpec::Matcher.new(matcher_name)
end
