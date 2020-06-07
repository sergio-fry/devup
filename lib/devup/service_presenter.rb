module Devup
  class ServicePresenter
    attr_reader :service, :project

    def initialize(service, project: nil)
      @service = service
      @project = project
    end

    def call
      res = []

      res << "# #{service.name}"
      res << magic if magic?

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

      res << port_env(to: service.ports.first.to) if service.ports.size == 1

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

    def magic?
      %w[postgres redis mysql memcached].include? service.name
    end

    def magic
      case service.name
      when "postgres"
        "export DATABASE_URL=postgres://postgres@0.0.0.0:#{port_to(5432)}/#{database_name}"
      when "mysql"
        "export DATABASE_URL=mysql2://root@0.0.0.0:#{port_to(3306)}/#{database_name}"
      when "redis"
        "export REDIS_URL=redis://0.0.0.0:#{port_to(6379)}"
      when "memcached"
        "export MEMCACHE_SERVERS=0.0.0.0:#{port_to(11211)}"
      end
    end

    def port_to(from)
      service.ports.find { |p| p.from == from }&.to
    end

    def database_name
      if defined? Rails
        [
          project,
          Rails.env
        ].join("_")
      else
        "db"
      end
    end
  end
end
