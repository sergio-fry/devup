require "yaml"

require "devup/compose/ps"

module Devup
  class Compose
    attr_reader :path, :project, :logger, :shell

    class Error < StandardError; end

    def initialize(path, project: "devup", logger:, shell:)
      @path = path
      @project = project
      @logger = logger
      @shell = shell
    end

    def check
      true
    end

    def services
      config["services"].keys
    end

    def service_ports(name)
      config["services"][name]["ports"].map { |el| el.to_s.split(":")[-1].to_i }
    end

    def port_mapping(service, port)
      exec("port #{service} #{port}").split(":")[-1].strip.to_i
    end

    def up
      exec "up -d --remove-orphans"

      wait_alive 3
    end

    def stop
      exec "stop"
    end

    def rm
      exec "rm -f"
    end

    private

    def wait_alive(timeout, retry_sleep: 0.3)
      start = Time.now

      loop {
        break if alive?

        if Time.now - start > timeout
          logger.error "can't run services"
          break
        end
        sleep retry_sleep
      }
    end

    def alive?
      ComposeHelpers::Ps.new(exec("ps")).up?
    end

    def exec(cmd)
      resp = shell.exec "docker-compose -p #{project} -f #{path} #{cmd}"

      raise(Error) unless resp.success?

      resp.data
    end

    def config
      YAML.safe_load(config_content)
    end

    def config_content
      File.read(path)
    end
  end
end
