require "ostruct"

module Devup
  class Service
    attr_reader :compose, :name

    def initialize(compose, name)
      @compose = compose
      @name = name
    end

    def ports
      @ports ||= fetch_ports
    end

    private

    def fetch_ports
      compose.service_ports(name).map { |el| el.to_s.split(":")[-1] }.map do |from|
        OpenStruct.new(
          from: from.to_i,
          to: compose.exec("port #{name} #{from}").split(":")[-1].strip.to_i
        )
      end
    end
  end
end
