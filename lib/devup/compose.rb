require "yaml"

require "devup/compose/processes"
require "devup/compose/port_mapping"

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
      return [] if config["services"][name]["ports"].nil?

      # TODO: extract this to a class
      config["services"][name]["ports"].map { |el| PortMapping.new(el.to_s).from }
    end

    def port_mapping(port)
      Compose::Processes.new(exec_ps_cached).port_mapping(port)
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
      Compose::Processes.new(exec_ps).up?
    end

    def exec_ps
      @exec_ps_output = exec("ps")
    end

    def exec_ps_cached
      @exec_ps_output ||= exec("ps")
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
