module Filter
  module Matchers
    class Hash < Base
      def initialize(pattern)
        @pattern = ::Hash[pattern.map { |k, v| [k.to_proc, Filter::Matcher.new(v)]}]
      end

      def ===(other)
        pattern.all? do |attr, pattern|
          pattern === attr.call(other)
        end
      end
    end
  end
end