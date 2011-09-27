require 'spec_helper'

class Capybara::Session
  def has_flash_message?(message)
    within '#flash' do
      has_content? message
    end
  end
end
CapybaraMiniTestSpec::Matcher.new(:has_flash_message?)

describe 'Custom matcher' do
  include Capybara::DSL

  before :each do
    Capybara.default_selector = :css
    visit '/flash_message'
  end

  after { Capybara.default_selector = :xpath }

  it 'works with positive expectation' do
    page.must_have_flash_message 'Barry Allen'
  end

  it 'works with negative expectation' do
    page.wont_have_flash_message 'The Blob'
  end
end
