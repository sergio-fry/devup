module Devup
  class PortMapping
    def initialize(from, to)
      @from = from
      @to = to
    end

    attr_reader :from, :to

    def ==(another)
      @from == another.from && @to == another.to
    end
  end
end
