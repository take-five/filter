module Filter
  module Matchers
    class Boolean < Base
      def ===(other)
        !!other == pattern
      end
    end
  end
end