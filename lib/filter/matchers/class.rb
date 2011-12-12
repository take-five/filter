module Filter
  module Matchers
    class Class < Base
      def ===(other)
        other.is_a?(::Class) || other.is_a?(::Module) ?
            other <= pattern :
            other.is_a?(pattern)
      end
    end
  end
end