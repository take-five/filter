require "filter/condition"

module Filter
  class And < Condition
    def initialize(*patterns)
      @matchers = patterns.map { |pattern| Matcher.new(pattern) }
    end

    def ===(other)
      @matchers.all? { |m| m === other }
    end
  end

  def and(*patterns)
    And.new(*patterns)
  end
  module_function :and
end