module Devup
  class ServicePresenter
    attr_reader :service

    def initialize(service)
      @service = service
    end

    TEMPLATE = <<~ERB
      <% if has_ports? %>
      # <%= service.name %>
      <%= host_env %>
      <%= ports_env %>
      <% else %>
      # <%= service.name %> has no exposed ports
      <% end %>
    ERB

    def call
      ERB.new(TEMPLATE).result binding
    end

    private

    def host_env
      "export #{service.name.upcase}_HOST=0.0.0.0"
    end

    def ports_env
      res = []

      if service.ports.size == 1
        res << port_env(to: service.ports.first.to)
      else
        service.ports.each do |port|
          res << port_env(from: port.from, to: port.to)
        end
      end

      res.join "\n"
    end

    def port_env(from: nil, to:)
      if from.nil?
        "export #{service.name.upcase}_PORT=#{to}"
      else
        "export #{service.name.upcase}_PORT_#{from}=#{to}"
      end
    end

    def has_ports?
      service.ports.size > 0
    end
  end
end
