require "filter/matcher"

module Filter
  class Condition
    def initialize(pattern)
      @matcher = Filter::Matcher.new(pattern)
    end

    def ===(another)
      @matcher === another
    end

    def and(other)
      Filter.and(self, other)
    end
    alias & and

    def or(other)
      Filter.or(self, other)
    end
    alias | or

    def not
      Filter.not(self)
    end
    alias ~ not
  end
end