require_relative "port"

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
      compose.service_ports(name).map do |from|
        # TODO should be merged to PortMapping (?)
        Port.new(
          from: from,
          to: compose.port_mapping(from)
        )
      end
    end
  end
end
