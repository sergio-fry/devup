require "yaml"

require "devup/compose/v1/processes"
require "devup/compose/port_config"

module Devup
  module Compose
    module V1
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

          config["services"][name]["ports"].map { |el| PortConfig.new(el.to_s) }
        end

        def port_mapping(port)
          processes.port_mapping(port)
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
          processes(cached: false).up?
        end

        def processes(cached: true)
          Processes.new(cached ? exec_ps_cached : exec_ps)
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
  end
end
