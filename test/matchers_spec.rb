require 'spec_helper'

describe CapybaraMinitestSpec do
  include Capybara::DSL

  describe "have_css matcher" do
    describe "on a string" do
      describe "with should" do
        it "passes if has_css? returns true" do
          "<h1>Text</h1>".must_have_css('h1')
        end

        it "fails if has_css? returns false" do
          proc do
            "<h1>Text</h1>".must_have_css('h2')
          end.must_raise(/expected css "h2" to return something/)
        end

        it "passes if matched node count equals expected count" do
          "<h1>Text</h1>".must_have_css('h1', :count => 1)
        end

        it "fails if matched node count does not equal expected count" do
          proc do
            "<h1>Text</h1>".must_have_css('h1', :count => 2)
          end.must_raise(/expected css "h1" to return something/)
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          "<h1>Text</h1>".wont_have_css('h2')
        end

        it "fails if has_no_css? returns false" do
          proc do
            "<h1>Text</h1>".wont_have_css('h1')
          end.must_raise(/expected css "h1" not to return anything/)
        end

        it "passes if matched node count does not equal expected count" do
          "<h1>Text</h1>".wont_have_css('h1', :count => 2)
        end

        it "fails if matched node count equals expected count" do
          proc do
            "<h1>Text</h1>".wont_have_css('h1', :count => 1)
          end.must_raise(/expected css "h1" not to return anything/)
        end
      end
    end

    describe "on a page or node" do
      before do
        visit('/with_html')
      end

      describe "with should" do
        it "passes if has_css? returns true" do
          page.must_have_css('h1')
        end

        it "fails if has_css? returns false" do
          proc do
            page.must_have_css('h1#doesnotexist')
          end.must_raise(/expected css "h1#doesnotexist" to return something/)
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_css('h1#doesnotexist')
        end

        it "fails if has_no_css? returns false" do
          proc do
            page.wont_have_css('h1')
          end.must_raise(/expected css "h1" not to return anything/)
        end
      end
    end
  end

  describe "have_xpath matcher" do
    describe "on a string" do
      describe "with should" do
        it "passes if has_css? returns true" do
          "<h1>Text</h1>".must_have_xpath('//h1')
        end

        it "fails if has_css? returns false" do
          proc do
            "<h1>Text</h1>".must_have_xpath('//h2')
          end.must_raise(%r(expected xpath "//h2" to return something))
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          "<h1>Text</h1>".wont_have_xpath('//h2')
        end

        it "fails if has_no_css? returns false" do
          proc do
            "<h1>Text</h1>".wont_have_xpath('//h1')
          end.must_raise(%r(expected xpath "//h1" not to return anything))
        end
      end
    end

    describe "on a page or node" do
      before do
        visit('/with_html')
      end

      describe "with should" do
        it "passes if has_css? returns true" do
          page.must_have_xpath('//h1')
        end

        it "fails if has_css? returns false" do
          proc do
            page.must_have_xpath("//h1[@id='doesnotexist']")
          end.must_raise(%r(expected xpath "//h1\[@id='doesnotexist'\]" to return something))
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_xpath('//h1[@id="doesnotexist"]')
        end

        it "fails if has_no_css? returns false" do
          proc do
            page.wont_have_xpath('//h1')
          end.must_raise(%r(expected xpath "//h1" not to return anything))
        end
      end
    end
  end

  describe "have_selector matcher" do
    describe "on a string" do
      describe "with should" do
        it "passes if has_css? returns true" do
          assert Capybara.string("<h1>Text</h1>").has_selector?('//h1')
          "<h1>Text</h1>".must_have_selector('//h1')
        end

        it "fails if has_css? returns false" do
          proc do
            "<h1>Text</h1>".must_have_selector('//h2')
          end.must_raise(%r(expected xpath "//h2" to return something))
        end

        it "fails with the selector's failure_message if set" do
          Capybara.add_selector(:monkey) do
            xpath { |num| ".//*[contains(@id, 'monkey')][#{num}]" }
            failure_message { |node, selector| node.all(".//*[contains(@id, 'monkey')]").map { |node| node.text }.sort.join(', ') }
          end
          proc do
            '<h1 id="monkey_paul">Monkey John</h1>'.must_have_selector(:monkey, 14)
          end.must_raise("Monkey John")
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          "<h1>Text</h1>".wont_have_selector(:css, 'h2')
        end

        it "fails if has_no_css? returns false" do
          proc do
            "<h1>Text</h1>".wont_have_selector(:css, 'h1')
          end.must_raise(%r(expected css "h1" not to return anything))
        end
      end
    end

    describe "on a page or node" do
      before do
        visit('/with_html')
      end

      describe "with should" do
        it "passes if has_css? returns true" do
          page.must_have_selector('//h1', :text => 'test')
        end

        it "fails if has_css? returns false" do
          proc do
            page.must_have_selector("//h1[@id='doesnotexist']")
          end.must_raise(%r(expected xpath "//h1\[@id='doesnotexist'\]" to return something))
        end

        it "includes text in error message" do
          proc do
            page.must_have_selector("//h1", :text => 'wrong text')
          end.must_raise(%r(expected xpath "//h1" with text "wrong text" to return something))
        end

        it "fails with the selector's failure_message if set" do
          Capybara.add_selector(:monkey) do
            xpath { |num| ".//*[contains(@id, 'monkey')][#{num}]" }
            failure_message { |node, selector| node.all(".//*[contains(@id, 'monkey')]").map { |node| node.text }.sort.join(', ') }
          end
          proc do
            page.must_have_selector(:monkey, 14)
          end.must_raise("Monkey John, Monkey Paul")
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_selector(:css, 'h1#doesnotexist')
        end

        it "fails if has_no_css? returns false" do
          proc do
            page.wont_have_selector(:css, 'h1', :text => 'test')
          end.must_raise(%r(expected css "h1" with text "test" not to return anything))
        end
      end
    end
  end

  describe "have_content matcher" do

    describe "on a string" do
      describe "with should" do
        it "passes if has_css? returns true" do
          "<h1>Text</h1>".must_have_content('Text')
        end

        it "fails if has_css? returns false" do
          proc do
            "<h1>Text</h1>".must_have_content('No such Text')
          end.must_raise(/expected there to be content "No such Text" in "Text"/)
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          "<h1>Text</h1>".wont_have_content('No such Text')
        end

        it "fails if has_no_css? returns false" do
          proc do
            "<h1>Text</h1>".wont_have_content('Text')
          end.must_raise(/expected content "Text" not to return anything/)
        end
      end
    end

    describe "on a page or node" do
      before do
        visit('/with_html')
      end

      describe "with should" do
        it "passes if has_css? returns true" do
          page.must_have_content('This is a test')
        end

        it "fails if has_css? returns false" do
          proc do
            page.must_have_content('No such Text')
          end.must_raise(/expected there to be content "No such Text" in "(.*)This is a test(.*)"/)
        end

        describe "with default selector CSS" do
          before { Capybara.default_selector = :css }
          it "fails if has_css? returns false" do
            proc do
              page.must_have_content('No such Text')
            end.must_raise(/expected there to be content "No such Text" in "(.*)This is a test(.*)"/)
          end
          after { Capybara.default_selector = :xpath }
        end
      end

      describe "with should_not" do
        it "passes if has_no_css? returns true" do
          page.wont_have_content('No such Text')
        end

        it "fails if has_no_css? returns false" do
          proc do
            page.wont_have_content('This is a test')
          end.must_raise(/expected content "This is a test" not to return anything/)
        end
      end
    end
  end

  describe "have_link matcher" do
    let(:html) { '<a href="#">Just a link</a>' }

    it "passes if there is such a button" do
      html.must_have_link('Just a link')
    end

    it "fails if there is no such button" do
      proc do
        html.must_have_link('No such Link')
      end.must_raise(/expected link "No such Link"/)
    end
  end

  describe "have_button matcher" do
    let(:html) { '<button>A button</button><input type="submit" value="Another button"/>' }

    it "passes if there is such a button" do
      html.must_have_button('A button')
    end

    it "fails if there is no such button" do
      proc do
        html.must_have_button('No such Button')
      end.must_raise(/expected button "No such Button"/)
    end
  end

  describe "have_field matcher" do
    let(:html) { '<p><label>Text field<input type="text"/></label></p>' }

    it "passes if there is such a field" do
      html.must_have_field('Text field')
    end

    it "fails if there is no such field" do
      proc do
        html.must_have_field('No such Field')
      end.must_raise(/expected field "No such Field"/)
    end
  end

  describe "have_checked_field matcher" do
    let(:html) do
      '<label>it is checked<input type="checkbox" checked="checked"/></label>
      <label>unchecked field<input type="checkbox"/></label>'
    end

    describe "with should" do
      it "passes if there is such a field and it is checked" do
        html.must_have_checked_field('it is checked')
      end

      it "fails if there is such a field but it is not checked" do
        proc do
          html.must_have_checked_field('unchecked field')
        end.must_raise(/expected checked_field "unchecked field"/)
      end

      it "fails if there is no such field" do
        proc do
          html.must_have_checked_field('no such field')
        end.must_raise(/expected checked_field "no such field"/)
      end
    end

    describe "with must_not" do
      it "fails if there is such a field and it is checked" do
        proc do
          html.wont_have_checked_field('it is checked')
        end.must_raise(/expected checked_field "it is checked" not to return anything/)
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

    describe "with should" do
      it "passes if there is such a field and it is not checked" do
        html.must_have_unchecked_field('unchecked field')
      end

      it "fails if there is such a field but it is checked" do
        proc do
          html.must_have_unchecked_field('it is checked')
        end.must_raise(/expected unchecked_field "it is checked"/)
      end

      it "fails if there is no such field" do
        proc do
          html.must_have_unchecked_field('no such field')
        end.must_raise(/expected unchecked_field "no such field"/)
      end
    end

    describe "with must_not" do
      it "fails if there is such a field and it is not checked" do
        proc do
          html.wont_have_unchecked_field('unchecked field')
        end.must_raise(/expected unchecked_field "unchecked field" not to return anything/)
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

    it "passes if there is such a select" do
      html.must_have_select('Select Box')
    end

    it "fails if there is no such select" do
      proc do
        html.must_have_select('No such Select box')
      end.must_raise(/expected select "No such Select box"/)
    end
  end

  describe "have_table matcher" do
    let(:html) { '<table><caption>Lovely table</caption></table>' }

    it "passes if there is such a select" do
      html.must_have_table('Lovely table')
    end

    it "fails if there is no such select" do
      proc do
        html.must_have_table('No such Table')
      end.must_raise(/expected table "No such Table"/)
    end
  end

  describe 'failure message' do
    it 'shows matcher name and args' do
      begin
        'actual'.must_have_css('expected', :count => 1)
      rescue MiniTest::Assertion => ex
        exception = ex
      else
        flunk 'No exception was raised'
      end
      assert_equal 'Matcher failed: has_css?("expected", {:count=>1})', exception.message
    end
  end
end
