module Devup
  class Port
    attr_reader :from, :to

    def initialize(from: nil, to: nil)
      @from = from
      @to = to
    end
  end
end
