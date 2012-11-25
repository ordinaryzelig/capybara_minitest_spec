module CapybaraMiniTestSpec
  # Represents the a matcher name.
  # Returns different forms of the name depending on whether it is positive or negative.
  class TestName

    include Capybara::RSpecMatchers

    def initialize(name)
      @original_name = name.to_s
    end

    def matcher(*args)
      send @original_name, *args
    end

  private

    def has
      have.sub /^have/, 'has'
    end

    def have
      @original_name
    end

  end

  class PositiveTestName < TestName

    def assertion_name
      "assert_page_#{has}"
    end

    def expectation_name
      "must_#{have}"
    end

    def match_method
      :matches?
    end

    def failure_message_method
      :failure_message_for_should
    end

  end

  class NegativeTestName < TestName

    def assertion_name
      "refute_page_#{has}"
    end

    def expectation_name
      "wont_#{have}"
    end

    def failure_message_method
      :failure_message_for_should_not
    end

    def match_method
      :does_not_match?
    end

  end
end
