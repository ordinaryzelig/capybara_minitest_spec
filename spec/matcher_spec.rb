require_relative 'helper'

describe CapybaraMiniTestSpec::Matcher do

  let(:matcher) { CapybaraMiniTestSpec::Matcher.new(:has_css?) }

  it 'should define an assertion' do
    MiniTest::Assertions.public_instance_methods.must_include(:assert_page_has_css)
  end

  it 'should define a refutation' do
    MiniTest::Assertions.public_instance_methods.must_include(:refute_page_has_css)
  end

  it 'should define positive expectation' do
    MiniTest::Expectations.public_instance_methods.must_include(:must_have_css)
  end

  it 'should define negative expectation' do
    MiniTest::Expectations.public_instance_methods.must_include(:wont_have_css)
  end

  it 'should wrap the asserted object in a Capybara::Node::Simple' do
    matcher.send(:wrap, '').must_be_instance_of(Capybara::Node::Simple)
  end

  it '#test returns true when test passes' do
    test_result = matcher.test('<h1>Test</h1>', 'h1', {:count => 1})
  end

  it '#test returns false when test fails' do
    test_result = matcher.test('<h1>Test</h1>', 'h2', {:count => 1})
  end

  it "#failure_message with 'assert' arg returns positive assertion failure message" do
    message = CapybaraMiniTestSpec::Matcher.failure_message('assert', :has_css?, {:option => 1})
    message.must_equal 'Matcher failed: has_css?({:option=>1})'
  end

  it "#failure_message with 'refute' arg returns negative assertion failure message" do
    message = CapybaraMiniTestSpec::Matcher.failure_message('refute', :has_css?, {:option => 1})
    message.must_equal 'Matcher should have failed: has_css?({:option=>1})'
  end

end
