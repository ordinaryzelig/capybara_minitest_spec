require_relative 'helper'

describe CapybaraMiniTestSpec do

  it 'defines the assertion' do
    MiniTest::Assertions.public_instance_methods.must_include :assert_page_has_css
  end

  it 'defines the spec expectation' do
    MiniTest::Expectations.public_instance_methods.must_include :must_have_css
  end

end
