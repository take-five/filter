require "filter/condition"

module Filter
  class Not < Condition
    def ===(other)
      !super
    end
  end

  def not(pattern)
    Not.new(pattern)
  end
  module_function :not
end