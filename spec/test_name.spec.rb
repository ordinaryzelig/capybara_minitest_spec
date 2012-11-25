require_relative 'helper'

describe CapybaraMiniTestSpec::TestName do

  describe CapybaraMiniTestSpec::PositiveTestName do

    let(:positive) { CapybaraMiniTestSpec::PositiveTestName.new(:have_css) }

    specify '#assertion_name returns assert_page_has_css' do
      positive.assertion_name.must_equal 'assert_page_has_css'
    end

    specify '#expectation_name returns must_have_css' do
      positive.expectation_name.must_equal 'must_have_css'
    end

    specify '#match_method returns :matches?' do
      positive.match_method.must_equal :matches?
    end

  end

  describe CapybaraMiniTestSpec::NegativeTestName do

    let(:negative) { CapybaraMiniTestSpec::NegativeTestName.new(:have_css) }

    specify '#assertion_name returns refute_page_has_css' do
      negative.assertion_name.must_equal 'refute_page_has_css'
    end

    specify '#expectation_name returns wont_have_css' do
      negative.expectation_name.must_equal 'wont_have_css'
    end

    specify '#match_method returns :does_not_match?' do
      negative.match_method.must_equal :does_not_match?
    end

  end

  specify '#matcher returns actual Capybara RSpec matcher' do
    matcher_name = CapybaraMiniTestSpec::TestName.new(:have_css)
    rspec_matcher = matcher_name.matcher('.asdf')
    rspec_matcher.must_be_instance_of Capybara::RSpecMatchers::HaveSelector
  end

end
