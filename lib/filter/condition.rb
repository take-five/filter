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
  end
end