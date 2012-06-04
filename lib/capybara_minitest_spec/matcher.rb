module CapybaraMiniTestSpec
  class Matcher

    attr_reader :name

    def initialize(node_matcher_name)
      @name = Name.new(node_matcher_name, true)
      define_expectations
    end

    def define_expectations
      # Define positive expectations.
      define_expectation
      # Define negative expectations.
      @name.negate!
      define_expectation
    end

    def undefine_assertions
      undefine_assertion
      @name.negate!
      undefine_assertion
    end

    # Send page the matcher name with args.
    # E.g. page.has_css?(*args)
    def test(page, *args)
      wrap(page).send(name.original, *args)
    end

    # Compose failure message.
    # E.g. Matcher failed: has_css?("expected", {:count => 1})
    def self.failure_message(page, assertion_method, matcher_name, *args)
      if assertion_method == 'assert'
        message = "Expected match: "
        delimiter = "\n"
      else
        message = "Expected no match: "
        delimiter = "\n   "
      end
      message << "#{matcher_name}(#{args.map(&:inspect).join(', ')})"
      message << delimiter 
      message << "Actual content: "
      message << page.to_s
    end

    private

    def define_expectation
      define_assertion
      infect_assertion
    end

    # Define an assertion with the matcher name in MiniTest::Assertions.
    # For example, if the matcher name is has_css?,
    # the assertion would be called assert_page_has_css.
    def define_assertion
      # scope self to be available in the method definition.
      matcher = self
      assertion_method = name.positive? ? 'assert' : 'refute'
      MiniTest::Assertions.send :define_method, name.assertion do |page, *args|
        message = matcher.class.failure_message(page, assertion_method, matcher.name.original, *args)
        send(assertion_method, matcher.test(page, *args), message)
      end
    end

    def undefine_assertion
      MiniTest::Assertions.send :undef_method, @name.assertion
    end

    def infect_assertion
      MiniTest::Expectations.infect_an_assertion @name.assertion, @name.expectation, true
    end

    # Turn a string into a Capybara node if it's not already.
    # Copied from Capybara::RSpecMatchers::HaveMatcher.
    def wrap(actual)
      if actual.respond_to?("has_selector?")
        actual
      else
        Capybara.string(actual.to_s)
      end
    end

    # Represents the a matcher name.
    # Returns different forms of the name depending on whether it is in a positive or negative state.
    class Name

      attr_reader :original

      def initialize(name, positive)
        @original = name.to_s
        @positive = positive
      end

      def positive?
        !!@positive
      end

      def negate!
        @positive = !positive?
      end

      def without_question_mark
        @original.to_s.sub /\?$/, ''
      end

      def have
        without_question_mark.sub /has_/, 'have_'
      end

      def assertion
        if positive?
          "assert_page_#{without_question_mark}"
        else
          "refute_page_#{without_question_mark}"
        end
      end

      def expectation
        if positive?
          "must_#{have}"
        else
          "wont_#{have}"
        end
      end

    end

  end
end
