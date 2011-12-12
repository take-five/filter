module Filter
  module Matchers
    class Array < Base
      def initialize(pattern)
        @pattern = pattern.map(&:to_proc)
      end

      def ===(other)
        pattern.all? { |p| p === other }
      end
    end
  end
end