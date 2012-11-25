require_relative 'helper'

# Setup Rack test app.
require_relative 'test_app/test_app'
Capybara.app = TestApp


describe CapybaraMiniTestSpec do
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
          end.must_raise_with_message(/expected to find css "h2" but there were no matches/)
        end

        it "passes if matched node count equals expected count" do
          "<h1>Text</h1>".must_have_css('h1', :count => 1)
        end

        it "fails if matched node count does not equal expected count" do
          expect do
            "<h1>Text</h1>".must_have_css('h1', :count => 2)
          end.must_raise_with_message(/expected css "h1" to be found 2 times/)
        end
      end

      context "with should_not" do
        it "passes if has_no_css? returns true" do
          "<h1>Text</h1>".wont_have_css('h2')
        end

        it "fails if has_no_css? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_css('h1')
          end.must_raise_with_message(/expected not to find css "h1"/)
        end

        it "passes if matched node count does not equal expected count" do
          "<h1>Text</h1>".wont_have_css('h1', :count => 2)
        end

        it "fails if matched node count equals expected count" do
          expect do
            "<h1>Text</h1>".wont_have_css('h1', :count => 1)
          end.must_raise_with_message(/expected not to find css "h1"/)
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
          end.must_raise_with_message(/expected to find css "h1#doesnotexist" but there were no matches/)
        end
      end

      context "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_css('h1#doesnotexist')
        end

        it "fails if has_no_css? returns false" do
          expect do
            page.wont_have_css('h1')
          end.must_raise_with_message(/expected not to find css "h1"/)
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
          end.must_raise_with_message(%r(expected to find xpath "//h2" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_xpath? returns true" do
          "<h1>Text</h1>".wont_have_xpath('//h2')
        end

        it "fails if has_no_xpath? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_xpath('//h1')
          end.must_raise_with_message(%r(expected not to find xpath "//h1"))
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
          end.must_raise_with_message(%r(expected to find xpath "//h1\[@id='doesnotexist'\]" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_xpath? returns true" do
          page.wont_have_xpath('//h1[@id="doesnotexist"]')
        end

        it "fails if has_no_xpath? returns false" do
          expect do
            page.wont_have_xpath('//h1')
          end.must_raise_with_message(%r(expected not to find xpath "//h1"))
        end
      end
    end
  end

  describe "have_selector matcher" do
    it "gives proper description" do
      matcher = have_selector('//h1')
      "<h1>Text</h1>".must_have_selector('//h1')
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
          end.must_raise_with_message(%r(expected to find xpath "//h2" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_selector? returns true" do
          "<h1>Text</h1>".wont_have_selector(:css, 'h2')
        end

        it "fails if has_no_selector? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_selector(:css, 'h1')
          end.must_raise_with_message(%r(expected not to find css "h1"))
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
          end.must_raise_with_message(%r(expected to find xpath "//h1\[@id='doesnotexist'\]" but there were no matches))
        end

        it "includes text in error message" do
          expect do
            page.must_have_selector("//h1", :text => 'wrong text')
          end.must_raise_with_message(%r(expected to find xpath "//h1" with text "wrong text" but there were no matches))
        end
      end

      context "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_selector(:css, 'h1#doesnotexist')
        end

        it "fails if has_no_selector? returns false" do
          expect do
            page.wont_have_selector(:css, 'h1', :text => 'test')
          end.must_raise_with_message(%r(expected not to find css "h1" with text "test"))
        end
      end
    end
  end

  describe "have_content matcher" do
    it "gives proper description" do
      have_content('Text').description.must_equal "have text \"Text\""
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
          end.must_raise_with_message(/expected there to be text "No such Text" in "Text"/)
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
          end.must_raise_with_message(/expected there not to be text "Text" in "Text"/)
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
          end.must_raise_with_message(/expected there to be text "No such Text" in "(.*)This is a test(.*)"/)
        end

        context "with default selector CSS" do
          before { Capybara.default_selector = :css }
          it "fails if has_content? returns false" do
            expect do
              page.must_have_content('No such Text')
            end.must_raise_with_message(/expected there to be text "No such Text" in "(.*)This is a test(.*)"/)
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
          end.must_raise_with_message(/expected there not to be text "This is a test"/)
        end
      end
    end
  end

  describe "have_text matcher" do
    it "gives proper description" do
      have_text('Text').description.must_equal "have text \"Text\""
    end

    context "on a string" do
      context "with should" do
        it "passes if has_text? returns true" do
          "<h1>Text</h1>".must_have_text('Text')
        end

        it "passes if has_text? returns true using regexp" do
          "<h1>Text</h1>".must_have_text(/ext/)
        end

        it "fails if has_text? returns false" do
          expect do
            "<h1>Text</h1>".must_have_text('No such Text')
          end.must_raise_with_message(/expected there to be text "No such Text" in "Text"/)
        end

        it "casts has_text? argument to string" do
          expect do
            "<h1>Text</h1>".must_have_text(:cast_me)
          end.must_raise_with_message(/expected there to be text "cast_me" in "Text"/)
        end
      end

      context "with should_not" do
        it "passes if has_no_text? returns true" do
          "<h1>Text</h1>".wont_have_text('No such Text')
        end

        it "passes because escapes any characters that would have special meaning in a regexp" do
          "<h1>Text</h1>".wont_have_text('.')
        end

        it "fails if has_no_text? returns false" do
          expect do
            "<h1>Text</h1>".wont_have_text('Text')
          end.must_raise_with_message(/expected there not to be text "Text" in "Text"/)
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

        it "fails if has_text? returns false" do
          expect do
            page.must_have_text('No such Text')
          end.must_raise_with_message(/expected there to be text "No such Text" in "(.*)This is a test(.*)"/)
        end

        context "with default selector CSS" do
          before { Capybara.default_selector = :css }
          it "fails if has_text? returns false" do
            expect do
              page.must_have_text('No such Text')
            end.must_raise_with_message(/expected there to be text "No such Text" in "(.*)This is a test(.*)"/)
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
          end.must_raise_with_message(/expected there not to be text "This is a test"/)
        end
      end
    end
  end

  describe "have_link matcher" do
    let(:html) { '<a href="#">Just a link</a>' }

    it "gives proper description" do
      have_link('Just a link').description.must_equal "have link \"Just a link\""
    end

    it "passes if there is such a button" do
      html.must_have_link('Just a link')
    end

    it "fails if there is no such button" do
      expect do
        html.must_have_link('No such Link')
      end.must_raise_with_message(/expected to find link "No such Link"/)
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
      end.must_raise_with_message(/expected to find button "No such Button"/)
    end
  end

  describe "have_field matcher" do
    let(:html) { '<p><label>Text field<input type="text"/></label></p>' }

    it "gives proper description" do
      have_field('Text field').description.must_equal "have field \"Text field\""
    end

    it "passes if there is such a field" do
      html.must_have_field('Text field')
    end

    it "fails if there is no such field" do
      expect do
        html.must_have_field('No such Field')
      end.must_raise_with_message(/expected to find field "No such Field"/)
    end
  end

  describe "have_checked_field matcher" do
    let(:html) do
      '<label>it is checked<input type="checkbox" checked="checked"/></label>
      <label>unchecked field<input type="checkbox"/></label>'
    end

    it "gives proper description" do
      have_checked_field('it is checked').description.must_equal "have field \"it is checked\""
    end

    context "with should" do
      it "passes if there is such a field and it is checked" do
        html.must_have_checked_field('it is checked')
      end

      it "fails if there is such a field but it is not checked" do
        expect do
          html.must_have_checked_field('unchecked field')
        end.must_raise_with_message(/expected to find field "unchecked field"/)
      end

      it "fails if there is no such field" do
        expect do
          html.must_have_checked_field('no such field')
        end.must_raise_with_message(/expected to find field "no such field"/)
      end
    end

    context "with should not" do
      it "fails if there is such a field and it is checked" do
        expect do
          html.wont_have_checked_field('it is checked')
        end.must_raise_with_message(/expected not to find field "it is checked"/)
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
      have_unchecked_field('unchecked field').description.must_equal "have field \"unchecked field\""
    end

    context "with should" do
      it "passes if there is such a field and it is not checked" do
        html.must_have_unchecked_field('unchecked field')
      end

      it "fails if there is such a field but it is checked" do
        expect do
          html.must_have_unchecked_field('it is checked')
        end.must_raise_with_message(/expected to find field "it is checked"/)
      end

      it "fails if there is no such field" do
        expect do
          html.must_have_unchecked_field('no such field')
        end.must_raise_with_message(/expected to find field "no such field"/)
      end
    end

    context "with should not" do
      it "fails if there is such a field and it is not checked" do
        expect do
          html.wont_have_unchecked_field('unchecked field')
        end.must_raise_with_message(/expected not to find field "unchecked field"/)
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

    it "passes if there is such a select" do
      html.must_have_select('Select Box')
    end

    it "fails if there is no such select" do
      expect do
        html.must_have_select('No such Select box')
      end.must_raise_with_message(/expected to find select box "No such Select box"/)
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
      end.must_raise_with_message(/expected to find table "No such Table"/)
    end
  end
end

