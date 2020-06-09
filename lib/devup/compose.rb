require "yaml"
require "open3"

require "devup/port"

module Devup
  class Compose
    attr_reader :path, :project, :logger

    class Error < StandardError; end

    def initialize(path, project: "devup", logger:)
      @path = path
      @project = project
      @logger = logger
    end

    def check
      _output, status = safe_exec("docker-compose -v")

      raise Error, "Command docker-compose is not installed" unless status
    end

    def services
      config["services"].keys
    end

    def service_ports(name)
      puts mappings.inspect
      config["services"][name]["ports"].map { |el| el.to_s.split(":")[-1] }.map do |from|
        Port.new(
          from: from.to_i,
          to: exec("port #{name} #{from}").split(":")[-1].strip.to_i
        )
      end
    end

    def up
      exec "up -d --remove-orphans --renew-anon-volumes"
    end

    def stop
      exec "stop"
    end

    def rm
      exec "rm -f"
    end

    def exec(cmd)
      output, status = safe_exec "docker-compose -p #{project} -f #{path} #{cmd}"

      raise(Error) unless status

      output
    end

    private

    def mappings
      out = exec "ps"

      full = out.scan /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:(\d+)->(\d+)\/tcp/
      short = out.scan(/\s(\d+)\/tcp/).map { |el| el * 2 }

      full + short
    end

    def safe_exec(cmd)
      output, error, status = Open3.capture3(cmd + ";")

      logger.error(error) unless status.success?

      [output, status.success?]
    end

    def config
      YAML.safe_load(config_content)
    end

    def config_content
      File.read(path)
    end
  end
end
