module Filter
  module Matchers
    class Base
      attr_reader :pattern

      def initialize(pattern)
        @pattern = pattern
      end

      def ===(other)
        pattern === other
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
end