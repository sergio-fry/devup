require "ostruct"

module Devup
  class Service
    attr_reader :compose, :name

    def initialize(compose, name)
      @compose = compose
      @name = name
    end

    def ports
      compose.service_ports(name).map { |el| el.to_s.split(":")[-1] }.map do |from|
        OpenStruct.new(
          from: from,
          to: compose.command("port #{name} #{from}").split(":")[-1].strip
        )
      end
    end
  end
end
