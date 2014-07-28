# Copied from 'capybara/spec/rspec/matchers_spec.rb' and changed to use minitest.
# https://gist.github.com/4297afa19edd44885248
require_relative 'helper'

# Bridge some gaps between RSpec and MiniTest.
class Minitest::Test
  class << self
    alias_method :context, :describe
  end
  alias_method :expect, :proc
end

module MiniTest::Assertions
  # Yield, rescue, compare exception's message.
  def assert_fails_with_message(exception_message)
    yield
  rescue Exception => exception
    exception_raised = true
    assert_match exception_message, exception.message
  ensure
    assert exception_raised, 'expected exception to be raised'
  end
  Proc.infect_an_assertion :assert_fails_with_message, :must_fail_with_message
end

# There is a capybara/spec/spec_helper, but the following lines seeem to be enough.
# Also, capybara/spec/spec_helper requires rspec.
require 'capybara/spec/test_app'
Capybara.default_selector = :xpath
Capybara.app = TestApp

describe Capybara::RSpecMatchers do
  include Capybara::DSL
  include Capybara::RSpecMatchers

  describe "have_css matcher" do
    it "gives proper description" do
      have_css('h1').description.must_equal "have css \"h1\""
    end

    context "on a string" do
      context "with should" do
        it "passes if has_css? returns true" do
          "<h1>Text</h1>".must_have_css('h1')
        end

        it "fails if has_css? returns false" do
          expect do
            "<h1>Text</h1>".must_have_css('h2')
          end.must_fail_with_message(/expected to find css "h2" but there were no matches/)
        end

        it "passes if matched node count equals expected count" do
          "<h1>Text</h1>".must_have_css('h1', :count => 1)
        end

        it "fails if matched node count does not equal expected count" do
          expect do
            "<h1>Text</h1>".must_have_css('h1', count: 2)
          end.must_fail_with_message("expected to find css \"h1\" 2 times, found 1 match: \"Text\"")
        end

        it "fails if matched node count is less than expected minimum count" do
          expect do
            "<h1>Text</h1>".must_have_css('p', minimum: 1)
          end.must_fail_with_message("expected to find css \"p\" at least 1 time but there were no matches")
        end

        it "fails if matched node count is more than expected maximum count" do
          expect do
            "<h1>Text</h1><h1>Text</h1><h1>Text</h1>".must_have_css('h1', maximum: 2)
          end.must_fail_with_message('expected to find css "h1" at most 2 times, found 3 matches: "Text", "Text", "Text"')
        end

        it "fails if matched node count does not belong to expected range" do
          expect do
            "<h1>Text</h1>".must_have_css('h1', between: 2..3)
          end.must_fail_with_message("expected to find css \"h1\" between 2 and 3 times, found 1 match: \"Text\"")
        end
      end

      context "with should_not" do
        it "passes if has_no_css? returns true" do
          "<h1>Text</h1>".wont_have_css('h2')
        end

        it "fails if has_no_css? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_css('h1')
          end.must_fail_with_message(/expected not to find css "h1"/)
        end

        it "passes if matched node count does not equal expected count" do
          "<h1>Text</h1>".wont_have_css('h1', :count => 2)
        end

        it "fails if matched node count equals expected count" do
          expect do
            "<h1>Text</h1>".wont_have_css('h1', :count => 1)
          end.must_fail_with_message(/expected not to find css "h1"/)
        end
      end
    end

    context "on a page or node" do
      before do
        visit('/with_html')
      end

      context "with should" do
        it "passes if has_css? returns true" do
          page.must_have_css('h1')
        end

        it "fails if has_css? returns false" do
          expect do
            page.must_have_css('h1#doesnotexist')
          end.must_fail_with_message(/expected to find css "h1#doesnotexist" but there were no matches/)
        end
      end

      context "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_css('h1#doesnotexist')
        end

        it "fails if has_no_css? returns false" do
          expect do
            page.wont_have_css('h1')
          end.must_fail_with_message(/expected not to find css "h1"/)
        end
      end
    end
  end

  describe "have_xpath matcher" do
    it "gives proper description" do
      have_xpath('//h1').description.must_equal "have xpath \"\/\/h1\""
    end

    context "on a string" do
      context "with should" do
        it "passes if has_xpath? returns true" do
          "<h1>Text</h1>".must_have_xpath('//h1')
        end

        it "fails if has_xpath? returns false" do
          expect do
            "<h1>Text</h1>".must_have_xpath('//h2')
          end.must_fail_with_message(%r(expected to find xpath "//h2" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_xpath? returns true" do
          "<h1>Text</h1>".wont_have_xpath('//h2')
        end

        it "fails if has_no_xpath? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_xpath('//h1')
          end.must_fail_with_message(%r(expected not to find xpath "//h1"))
        end
      end
    end

    context "on a page or node" do
      before do
        visit('/with_html')
      end

      context "with should" do
        it "passes if has_xpath? returns true" do
          page.must_have_xpath('//h1')
        end

        it "fails if has_xpath? returns false" do
          expect do
            page.must_have_xpath("//h1[@id='doesnotexist']")
          end.must_fail_with_message(%r(expected to find xpath "//h1\[@id='doesnotexist'\]" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_xpath? returns true" do
          page.wont_have_xpath('//h1[@id="doesnotexist"]')
        end

        it "fails if has_no_xpath? returns false" do
          expect do
            page.wont_have_xpath('//h1')
          end.must_fail_with_message(%r(expected not to find xpath "//h1"))
        end
      end
    end
  end

  describe "have_selector matcher" do
    it "gives proper description" do
      matcher = have_selector('//h1')
      matcher.matches?("<h1>Text</h1>")
      matcher.description.must_equal "have xpath \"//h1\""
    end

    context "on a string" do
      context "with should" do
        it "passes if has_selector? returns true" do
          "<h1>Text</h1>".must_have_selector('//h1')
        end

        it "fails if has_selector? returns false" do
          expect do
            "<h1>Text</h1>".must_have_selector('//h2')
          end.must_fail_with_message(%r(expected to find xpath "//h2" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_selector? returns true" do
          "<h1>Text</h1>".wont_have_selector(:css, 'h2')
        end

        it "fails if has_no_selector? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_selector(:css, 'h1')
          end.must_fail_with_message(%r(expected not to find css "h1"))
        end
      end
    end

    context "on a page or node" do
      before do
        visit('/with_html')
      end

      context "with should" do
        it "passes if has_selector? returns true" do
          page.must_have_selector('//h1', :text => 'test')
        end

        it "fails if has_selector? returns false" do
          expect do
            page.must_have_selector("//h1[@id='doesnotexist']")
          end.must_fail_with_message(%r(expected to find xpath "//h1\[@id='doesnotexist'\]" but there were no matches))
        end

        it "includes text in error message" do
          expect do
            page.must_have_selector("//h1", :text => 'wrong text')
          end.must_fail_with_message(%r(expected to find xpath "//h1" with text "wrong text" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_selector(:css, 'h1#doesnotexist')
        end

        it "fails if has_no_selector? returns false" do
          expect do
            page.wont_have_selector(:css, 'h1', :text => 'test')
          end.must_fail_with_message(%r(expected not to find css "h1" with text "test"))
        end
      end
    end
  end

  describe "have_content matcher" do
    it "gives proper description" do
      have_content('Text').description.must_equal "text \"Text\""
    end

    context "on a string" do
      context "with should" do
        it "passes if has_content? returns true" do
          "<h1>Text</h1>".must_have_content('Text')
        end

        it "passes if has_content? returns true using regexp" do
          "<h1>Text</h1>".must_have_content(/ext/)
        end

        it "fails if has_content? returns false" do
          expect do
            "<h1>Text</h1>".must_have_content('No such Text')
          end.must_fail_with_message(/expected to find text "No such Text" in "Text"/)
        end
      end

      context "with should_not" do
        it "passes if has_no_content? returns true" do
          "<h1>Text</h1>".wont_have_content('No such Text')
        end

        it "passes because escapes any characters that would have special meaning in a regexp" do
          "<h1>Text</h1>".wont_have_content('.')
        end

        it "fails if has_no_content? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_content('Text')
          end.must_fail_with_message(/expected not to find text "Text" in "Text"/)
        end
      end
    end

    context "on a page or node" do
      before do
        visit('/with_html')
      end

      context "with should" do
        it "passes if has_content? returns true" do
          page.must_have_content('This is a test')
        end

        it "passes if has_content? returns true using regexp" do
          page.must_have_content(/test/)
        end

        it "fails if has_content? returns false" do
          expect do
            page.must_have_content('No such Text')
          end.must_fail_with_message(/expected to find text "No such Text" in "(.*)This is a test(.*)"/)
        end

        context "with default selector CSS" do
          before { Capybara.default_selector = :css }
          it "fails if has_content? returns false" do
            expect do
              page.must_have_content('No such Text')
            end.must_fail_with_message(/expected to find text "No such Text" in "(.*)This is a test(.*)"/)
          end
          after { Capybara.default_selector = :xpath }
        end
      end

      context "with should_not" do
        it "passes if has_no_content? returns true" do
          page.wont_have_content('No such Text')
        end

        it "fails if has_no_content? returns false" do
          expect do
            page.wont_have_content('This is a test')
          end.must_fail_with_message(/expected not to find text "This is a test"/)
        end
      end
    end
  end

  describe "have_text matcher" do
    it "gives proper description" do
      have_text('Text').description.must_equal "text \"Text\""
    end

    context "on a string" do
      context "with should" do
        it "passes if text contains given string" do
          "<h1>Text</h1>".must_have_text('Text')
        end

        it "passes if text matches given regexp" do
          "<h1>Text</h1>".must_have_text(/ext/)
        end

        it "fails if text doesn't contain given string" do
          expect do
            "<h1>Text</h1>".must_have_text('No such Text')
          end.must_fail_with_message(/expected to find text "No such Text" in "Text"/)
        end

        it "fails if text doesn't match given regexp" do
          expect do
            "<h1>Text</h1>".must_have_text(/No such Text/)
          end.must_fail_with_message('expected to find text matching /No such Text/ in "Text"')
        end

        it "casts Fixnum to string" do
          expect do
            "<h1>Text</h1>".must_have_text(3)
          end.must_fail_with_message(/expected to find text "3" in "Text"/)
        end

        it "fails if matched text count does not equal to expected count" do
          expect do
            "<h1>Text</h1>".must_have_text('Text', count: 2)
          end.must_fail_with_message('expected to find text "Text" 2 times but found 1 time in "Text"')
        end

        it "fails if matched text count is less than expected minimum count" do
          expect do
            "<h1>Text</h1>".must_have_text('Lorem', minimum: 1)
          end.must_fail_with_message('expected to find text "Lorem" at least 1 time but found 0 times in "Text"')
        end

        it "fails if matched text count is more than expected maximum count" do
          expect do
            "<h1>Text TextText</h1>".must_have_text('Text', maximum: 2)
          end.must_fail_with_message('expected to find text "Text" at most 2 times but found 3 times in "Text TextText"')
        end

        it "fails if matched text count does not belong to expected range" do
          expect do
            "<h1>Text</h1>".must_have_text('Text', between: 2..3)
          end.must_fail_with_message('expected to find text "Text" between 2 and 3 times but found 1 time in "Text"')
        end
      end

      context "with should_not" do
        it "passes if text doesn't contain a string" do
          "<h1>Text</h1>".wont_have_text('No such Text')
        end

        it "passes because escapes any characters that would have special meaning in a regexp" do
          "<h1>Text</h1>".wont_have_text('.')
        end

        it "fails if text contains a string" do
          expect do
            "<h1>Text</h1>".wont_have_text('Text')
          end.must_fail_with_message(/expected not to find text "Text" in "Text"/)
        end
      end
    end

    context "on a page or node" do
      before do
        visit('/with_html')
      end

      context "with should" do
        it "passes if has_text? returns true" do
          page.must_have_text('This is a test')
        end

        it "passes if has_text? returns true using regexp" do
          page.must_have_text(/test/)
        end

        it "can check for all text" do
          page.must_have_text(:all, 'Some of this text is hidden!')
        end

        it "can check for visible text" do
          page.must_have_text(:visible, 'Some of this text is')
          page.wont_have_text(:visible, 'Some of this text is hidden!')
        end

        it "fails if has_text? returns false" do
          expect do
            page.must_have_text('No such Text')
          end.must_fail_with_message(/expected to find text "No such Text" in "(.*)This is a test(.*)"/)
        end

        context "with default selector CSS" do
          before { Capybara.default_selector = :css }
          it "fails if has_text? returns false" do
            expect do
              page.must_have_text('No such Text')
            end.must_fail_with_message(/expected to find text "No such Text" in "(.*)This is a test(.*)"/)
          end
          after { Capybara.default_selector = :xpath }
        end
      end

      context "with should_not" do
        it "passes if has_no_text? returns true" do
          page.wont_have_text('No such Text')
        end

        it "fails if has_no_text? returns false" do
          expect do
            page.wont_have_text('This is a test')
          end.must_fail_with_message(/expected not to find text "This is a test"/)
        end
      end
    end

  end

  describe "have_link matcher" do
    let(:html) { '<a href="#">Just a link</a><a href="#">Another link</a>' }

    it "gives proper description" do
      have_link('Just a link').description.must_equal "have link \"Just a link\""
    end

    it "passes if there is such a button" do
      html.must_have_link('Just a link')
    end

    it "fails if there is no such button" do
      expect do
        html.must_have_link('No such Link')
      end.must_fail_with_message(/expected to find link "No such Link"/)
    end
  end

  describe "have_title matcher" do
    it "gives proper description" do
      have_title('Just a title').description.must_equal "have title \"Just a title\""
    end

    context "on a string" do
      let(:html) { '<title>Just a title</title>' }

      it "passes if there is such a title" do
        html.must_have_title('Just a title')
      end

      it "fails if there is no such title" do
        expect do
          html.must_have_title('No such title')
        end.must_fail_with_message('expected "Just a title" to include "No such title"')
      end

      it "fails if title doesn't match regexp" do
        expect do
          html.must_have_title(/[[:upper:]]+[[:lower:]]+l{2}o/)
        end.must_fail_with_message('expected "Just a title" to match /[[:upper:]]+[[:lower:]]+l{2}o/')
      end
    end

    context "on a page or node" do
      it "passes if there is such a title" do
        visit('/with_js')
        page.must_have_title('with_js')
      end

      it "fails if there is no such title" do
        visit('/with_js')
        expect do
          page.must_have_title('No such title')
        end.must_fail_with_message('expected "with_js" to include "No such title"')
      end
    end
  end

  describe "have_button matcher" do
    let(:html) { '<button>A button</button><input type="submit" value="Another button"/>' }

    it "gives proper description" do
      have_button('A button').description.must_equal "have button \"A button\""
    end

    it "passes if there is such a button" do
      html.must_have_button('A button')
    end

    it "fails if there is no such button" do
      expect do
        html.must_have_button('No such Button')
      end.must_fail_with_message(/expected to find button "No such Button"/)
    end
  end

  describe "have_field matcher" do
    let(:html) { '<p><label>Text field<input type="text" value="some value"/></label></p>' }

    it "gives proper description" do
      have_field('Text field').description.must_equal "have field \"Text field\""
    end

    it "gives proper description for a given value" do
      have_field('Text field', with: 'some value').description.must_equal "have field \"Text field\" with value \"some value\""
    end
    
    it "passes if there is such a field" do
      html.must_have_field('Text field')
    end

    it "passes if there is such a field with value" do
      html.must_have_field('Text field', with: 'some value')
    end

    it "fails if there is no such field" do
      expect do
        html.must_have_field('No such Field')
      end.must_fail_with_message(/expected to find field "No such Field"/)
    end

    it "fails if there is such field but with false value" do
      expect do
        html.must_have_field('Text field', with: 'false value')
      end.must_fail_with_message(/expected to find field "Text field"/)
    end

    it "treats a given value as a string" do
      class Foo
        def to_s
          "some value"
        end
      end
      html.must_have_field('Text field', with: Foo.new)
    end
  end

  describe "have_checked_field matcher" do
    let(:html) do
      '<label>it is checked<input type="checkbox" checked="checked"/></label>
      <label>unchecked field<input type="checkbox"/></label>'
    end

    it "gives proper description" do
      have_checked_field('it is checked').description.must_equal "have field \"it is checked\" that is checked"
    end
    
    context "with should" do
      it "passes if there is such a field and it is checked" do
        html.must_have_checked_field('it is checked')
      end

      it "fails if there is such a field but it is not checked" do
        expect do
          html.must_have_checked_field('unchecked field')
        end.must_fail_with_message(/expected to find field "unchecked field"/)
      end

      it "fails if there is no such field" do
        expect do
          html.must_have_checked_field('no such field')
        end.must_fail_with_message(/expected to find field "no such field"/)
      end
    end

    context "with should not" do
      it "fails if there is such a field and it is checked" do
        expect do
          html.wont_have_checked_field('it is checked')
        end.must_fail_with_message(/expected not to find field "it is checked"/)
      end

      it "passes if there is such a field but it is not checked" do
        html.wont_have_checked_field('unchecked field')
      end

      it "passes if there is no such field" do
        html.wont_have_checked_field('no such field')
      end
    end
  end

  describe "have_unchecked_field matcher" do
    let(:html) do
      '<label>it is checked<input type="checkbox" checked="checked"/></label>
      <label>unchecked field<input type="checkbox"/></label>'
    end

    it "gives proper description" do
      have_unchecked_field('unchecked field').description.must_equal "have field \"unchecked field\" that is not checked"
    end

    context "with should" do
      it "passes if there is such a field and it is not checked" do
        html.must_have_unchecked_field('unchecked field')
      end

      it "fails if there is such a field but it is checked" do
        expect do
          html.must_have_unchecked_field('it is checked')
        end.must_fail_with_message(/expected to find field "it is checked"/)
      end

      it "fails if there is no such field" do
        expect do
          html.must_have_unchecked_field('no such field')
        end.must_fail_with_message(/expected to find field "no such field"/)
      end
    end

    context "with should not" do
      it "fails if there is such a field and it is not checked" do
        expect do
          html.wont_have_unchecked_field('unchecked field')
        end.must_fail_with_message(/expected not to find field "unchecked field"/)
      end

      it "passes if there is such a field but it is checked" do
        html.wont_have_unchecked_field('it is checked')
      end

      it "passes if there is no such field" do
        html.wont_have_unchecked_field('no such field')
      end
    end
  end

  describe "have_select matcher" do
    let(:html) { '<label>Select Box<select></select></label>' }

    it "gives proper description" do
      have_select('Select Box').description.must_equal "have select box \"Select Box\""
    end

    it "gives proper description for a given selected value" do
      have_select('Select Box', selected: 'some value').description.must_equal "have select box \"Select Box\" with \"some value\" selected"
    end

    it "passes if there is such a select" do
      html.must_have_select('Select Box')
    end

    it "fails if there is no such select" do
      expect do
        html.must_have_select('No such Select box')
      end.must_fail_with_message(/expected to find select box "No such Select box"/)
    end
  end

  describe "have_table matcher" do
    let(:html) { '<table><caption>Lovely table</caption></table>' }

    it "gives proper description" do
      have_table('Lovely table').description.must_equal "have table \"Lovely table\""
    end

    it "passes if there is such a select" do
      html.must_have_table('Lovely table')
    end

    it "fails if there is no such select" do
      expect do
        html.must_have_table('No such Table')
      end.must_fail_with_message(/expected to find table "No such Table"/)
    end
  end
end
