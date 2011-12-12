# == Synopsys
# Extension for Ruby <code>Enumerable</code> module
#
# == Description
# Extends <code>Enumerable</code> module with <code>filter</code> method - enhanced version of <code>Enumerable#select</code>.
#
# == Examples
#   [1, 2, 3, 'ab'].filter(/a/)               # => ['ab']
#   [1, 2, 3].filter(&:even?)                 # => [2]
#   [1, 2, 3, 4.2].filter :to_i => :even?     # => [2, 4]
#   [1, 2, 4].filter { |num| num.even? }      # => [2, 4]
#   [1, 2, 4].filter(:even?) { |n| n + 1 }    # => [3, 5]
#   [0, false, 2, nil].filter(true)           # => [0, 2]
#
# <code>Enumerable#filter</code> also supports <code>OR</code> operator! Just pass many patterns as arguments.
# This snippet will match elements responding to <code>zero?</code> or <code>odd?</code> methods with <code>true</code>.
#   [0, 2, 3, 4].filter(:zero?, :odd?)        # => [0, 3]
module Enumerable
  # Extended Enumerable#select combibed with Enumerable#collect
  #
  # When String or Regexp passed it acts as built-in <code>Enumerable#grep</code> method
  # Also you can pass <code>Symbol, Proc, Method, Array, Hash, Class, Module, true, false, nil</code>.
  # If the <code>block</code> is supplied without other arguments it will be used as filter.
  # If the <code>block</code> is supplied with <code>patterns</code>,
  # each matching element is passed to it, and the block's result is stored in the output array.
  #
  # @param patterns *[Numeric|String|Regexp|Symbol|Proc|Method|NilClass|Hash|TrueClass|FalseClass|Module|Class]
  # @param block [Proc]
  # @return [Enumerable]
  def filter(*patterns, &block) # :yields: obj
    # do nothing on null input
    return self if !block_given? && patterns.empty?

    # move +block+ to +patterns+ if no +patterns+ given
    patterns, block = [block], nil if block_given? && patterns.empty?
    conditions = patterns.map { |pattern| filter_condition(pattern) }

    # match elements against all patterns using +OR+ operator
    filtered = select do |obj|
      conditions.any? { |condition| condition.call(obj) }
    end

    # also transform elements if block given
    block ? filtered.map(&block) : filtered
  end

  private
  def filter_condition(pattern) #:nodoc:
    # create filter condition from pattern
    case pattern
      when NilClass then proc { true }

      when Class, Module then
        proc do |e|
          e.is_a?(Class) || e.is_a?(Module) ?
              e <= pattern :
              e.is_a?(pattern)
        end

      when Symbol, Proc, Method then pattern.to_proc

      when Array then # enum.filter [:even?, :positive?, :cool?, proc { |n| n < 10 }]
        proc do |e|
          pattern.all? { |condition| filter_condition(condition).call(e) }
        end

      when Hash then # enum.filter :to_i => :even?, :ceil => :odd?
        proc do |e|
          pattern.all? do |attribute, condition|
            filter_condition(condition).call(attribute.to_proc.call(e))
          end
        end

      when TrueClass, FalseClass then proc { |e| !!e == pattern }

      else proc { |e| pattern === e } # otherwise - String, Regexp, Numeric etc.
    end
  end
end