require 'minitest/spec'
require 'capybara'
require "capybara_minitest_spec/matcher"
require "capybara_minitest_spec/version"

# For each Capybara node matcher,
# define positive and negative MiniTest::Unit assertions and
# infect it both assertions to create MiniTest::Spec expectations.
Capybara::Node::Matchers.public_instance_methods.each do |matcher_name|
  CapybaraMiniTestSpec::Matcher.new(matcher_name)
end
