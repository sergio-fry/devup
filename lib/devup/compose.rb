require "yaml"

module Devup
  class Compose
    attr_reader :path, :project

    def initialize(path, project: "devup")
      @path = path
      @project = project
    end

    def services
      config["services"].keys
    end

    def service_ports(name)
      config["services"][name]["ports"]
    end

    def up
      exec "up -d --remove-orphans"
    end

    def stop
      exec "stop"
      exec "rm -f"
    end

    def exec(cmd)
      `docker-compose -p #{project} -f #{path} #{cmd}`
    end

    private

    def config
      YAML.safe_load(config_content)
    end

    def config_content
      File.read(path)
    end
  end
end
