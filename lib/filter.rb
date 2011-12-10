# == Synpsys
# Extension for Ruby Enumerable module
#
# == Description
# Extends Enumerable module with +filter+ method - enhanced version of Enumerable#select
#
# == Examples
#   [1, 2, 3, 'ab'].filter(/a/)               # => #<Enumerator: ['ab']>
#   [1, 2, 3].filter(&:even?)                 # => #<Enumerator: [2]>
#   [1, 2, 3, 4.2].filter :to_i => :even?     # => #<Enumerator: [2, 4]>
#   [1, 2, 4].filter { |num| num.even? }      # => #<Enumerator: [2, 4]>
#   [1, 2, 4].filter(:even?) { |n| n + 1 }    # => #<Enumerator: [3, 5]>
#   [0, false, 2, nil].filter(true)           # => #<Enumerator: [0, 2]>
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
      when NilClass then lazy_select { true }

      when Class, Module then
        lazy_select do |e|
          e.is_a?(Class) || e.is_a?(Module) ?
              e <= pattern :
              e.is_a?(pattern)
        end

      when Symbol, Proc, Method then lazy_select(&pattern.to_proc)

      when Array then # enum.filter [:even?, :positive?, :cool?, proc { |n| n < 10 }]
        pattern.reduce(self) do |chain, local_pattern|
          chain.lazy_select(&local_pattern.to_proc)
        end

      when Hash then # enum.filter :to_i => :even?, :ceil => :odd?
        pattern.reduce(self) do |chain, pair|
          attr, local_pattern = pair.map(&:to_proc)

          chain.lazy_select do |element|
            local_pattern.call(attr.call(element))
          end
        end

      when TrueClass, FalseClass then lazy_select { |e| !!e == pattern }

      else lazy_select { |e| pattern === e } # otherwise - String, Regexp, Numeric etc.
    end

    # also transform elements if block given
    block ? filtered.lazy_map(&block) : filtered
  end

  protected
  # Lazy version of built-in Enumerable#select
  def lazy_select
    Enumerator.new do |yielder|
      each { |entry| yielder << entry if yield(entry) }
    end
  end

  # Lazy version of built-in Enumerable#collect
  def lazy_map #:nodoc:
    Enumerator.new do |yielder|
      each { |entry| yielder << yield(entry) }
    end
  end
end
