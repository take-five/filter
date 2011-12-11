# == Synpsys
# Extension for Ruby Enumerable module
#
# == Description
# Extends Enumerable module with +filter+ method - enhanced version of Enumerable#select
#
# == Examples
#   [1, 2, 3, 'ab'].filter(/a/)               # => ['ab']
#   [1, 2, 3].filter(&:even?)                 # => [2]
#   [1, 2, 3, 4.2].filter :to_i => :even?     # => [2, 4]
#   [1, 2, 4].filter { |num| num.even? }      # => [2, 4]
#   [1, 2, 4].filter(:even?) { |n| n + 1 }    # => [3, 5]
#   [0, false, 2, nil].filter(true)           # => [0, 2]
module Enumerable
  # Extended Enumerable#select combibed with Enumerable#collect
  #
  # When String or Regexp passed it acts as built-in +grep+ method, but return Enumerator instead of Array
  # Also you can pass Symbol, Proc or block
  #
  # @param pattern [Numeric|String|Regexp|Symbol|Proc|Method|NilClass|Hash|TrueClass|FalseClass|Module|Class]
  # @param block [Proc]
  def filter(pattern = nil, &block) # :yields: obj
    pattern, block = block, nil if block_given? && pattern.nil?

    filtered = case pattern
      when NilClass then self

      when Class, Module then
        select do |e|
          e.is_a?(Class) || e.is_a?(Module) ?
              e <= pattern :
              e.is_a?(pattern)
        end

      when Symbol, Proc, Method then select(&pattern.to_proc)

      when Array then # enum.filter [:even?, :positive?, :cool?, proc { |n| n < 10 }]
        pattern.reduce(self) do |chain, local_pattern|
          chain.select(&local_pattern.to_proc)
        end

      when Hash then # enum.filter :to_i => :even?, :ceil => :odd?
        pattern.reduce(self) do |chain, pair|
          attr, local_pattern = pair.map(&:to_proc)

          chain.select do |element|
            local_pattern.call(attr.call(element))
          end
        end

      when TrueClass, FalseClass then select { |e| !!e == pattern }

      else select { |e| pattern === e } # otherwise - String, Regexp, Numeric etc.
    end

    # also transform elements if block given
    block ? filtered.map(&block) : filtered
  end

end
