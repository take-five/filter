module Filter
  module Matchers
    class Symbol < Base
      def initialize(pattern)
        @pattern = pattern.to_proc
      end

      def ===(other)
        pattern.call(other)
      end
    end
  end
end