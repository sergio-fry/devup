module Devup
  class Port
    def initialize(from:, to:)
      @from = from
      @to = to
    end

    attr_reader :from, :to
  end
end
