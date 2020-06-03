require "yaml"

require "devup/compose"
require "devup/service"

module Devup
  class Environment
    attr_reader :pwd, :compose

    def initialize(pwd:, compose: nil)
      @pwd = pwd.to_s.strip
      @compose = compose || Compose.new(root.join("docker-compose.yml"), project: project)
    end

    def project
      pwd.split("/")[-1].strip
    end

    def vars
      compose.services.map { |name| Service.new(compose, name) }.map { |service|
        res = []

        res << {"#{service.name}_HOST".upcase => "0.0.0.0"}

        if service.ports.size > 0
          res << {"#{service.name}_PORT".upcase => service.ports.first.to}

          service.ports.each do |port|
            res << {"#{service.name}_PORT_#{port.from}".upcase => port.to}
          end
        end

        res
      }.flatten
    end

    def up
      compose.up
      write_dotenv
    end

    def down
      compose.stop
      compose.rm
      clear_dotenv
    end

    def root
      Pathname.new pwd
    end

    private

    def write_dotenv
      File.open(root.join(".env.services"), "w") { |f| f.write dotenv }
    end

    def clear_dotenv
      File.open(root.join(".env.services"), "w") { |f| f.write "" }
    end

    def dotenv
      vars.reduce({}, :merge).map { |k, v| "#{k}=#{v}" }.join("\n")
    end
  end
end
