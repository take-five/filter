require "filter/condition"

module Filter
  class Or < Condition
    def initialize(*patterns)
      @matchers = patterns.map { |pattern| Matcher.new(pattern) }
    end

    def ===(other)
      @matchers.any? { |m| m === other }
    end
  end

  def or(*patterns)
    Or.new(*patterns)
  end
  module_function :or
end