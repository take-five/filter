require "filter/matchers/base"
require "filter/matchers/array"
require "filter/matchers/boolean"
require "filter/matchers/class"
require "filter/matchers/hash"
require "filter/matchers/nil"
require "filter/matchers/symbol"

module Filter
  module Matcher
    MAPPING = {
      [NilClass] => Filter::Matchers::Nil,
      [TrueClass, FalseClass] => Filter::Matchers::Boolean,
      [Class, Module] => Filter::Matchers::Class,
      [Array] => Filter::Matchers::Array,
      [Symbol, Proc, Method, UnboundMethod] => Filter::Matchers::Symbol,
      [Hash] => Filter::Matchers::Hash,
    }

    def new(pattern)
      klass = nil

      MAPPING.each_pair do |classes, matcher_klass|
        klass = matcher_klass if classes.any? { |cls| pattern.is_a?(cls) }
      end

      klass = Filter::Matchers::Base if klass.nil?

      klass.new(pattern)
    end
    module_function :new
  end

  def match(pattern)
    Matcher.new(pattern)
  end
  module_function :match
end