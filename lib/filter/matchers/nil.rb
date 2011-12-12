module Filter
  module Matchers
    class Nil < Base
      # nil condition always results to true
      def ===(other)
        true
      end
    end
  end
end