module Devup
  # TODO: This -er name is sux. #call is agr..
  class ServicePresenter
    attr_reader :service, :project

    def initialize(service, project: nil)
      @service = service
      @project = project
    end

    def call
      res = []

      res << "# #{service.name}"

      if has_ports?
        res << host_env
        res << ports_env
      else
        res << "# no exposed ports"
      end

      res.join "\n"
    end

    private

    def host_env
      "export #{service.name.upcase}_HOST=0.0.0.0"
    end

    def ports_env
      res = []

      res << port_env(to: service.ports.first.to)

      service.ports.each do |port|
        res << port_env(from: port.from, to: port.to)
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

    def port_to(from)
      service.ports.find { |p| p.from == from }&.to
    end

    def database_name
      "db"
    end
  end
end
