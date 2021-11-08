require "yaml"

require "devup/logger"
require "devup/service"
require "devup/service_dotenv"
require "devup/shell"

require "devup/compose"

module Devup
  class Environment
    attr_reader :pwd, :logger, :shell

    def initialize(pwd:, compose: nil, logger:, shell: Shell.new(pwd: pwd, logger: logger))
      @pwd = pwd.to_s.strip
      @compose = compose
      @logger = logger
      @shell = shell
    end

    def project
      pwd.split("/")[-1].strip
    end

    def env
      services.map { |s| service_env(s) }.join("\n\n")
    end

    def up
      logger.info "starting up..."
      check
      compose.up
      write_dotenv
      logger.info "up"
    rescue => ex
      clear_dotenv
      logger.debug ex
      logger.error "halted"
      raise ex
    end

    def down
      logger.info "shutting down..."
      compose.stop
      compose.rm
      clear_dotenv
      logger.info "down"
    rescue => ex
      logger.debug ex
      logger.info "halted"
    end

    def root
      Pathname.new pwd
    end

    private

    def check
      raise if missing_config
      compose.check
    end

    def missing_config
      if File.exist?(compose.path)
        false
      else
        logger.error "missing #{compose.path}"

        true
      end
    end

    def services
      @services ||= compose.services.map { |name| Service.new(compose, name) }
    end

    def service_env(service)
      ServiceDotenv.new(service, project: project).text
    end

    def write_dotenv
      File.open(root.join(".env.services"), "w") { |f| f.write dotenv }
    end

    def clear_dotenv
      File.open(root.join(".env.services"), "w") { |f| f.write "" }
    end

    def dotenv
      <<~DOTENV
        ####################################################
        #     This file is generated by devup command.     #
        #     Home: https://github.com/sergio-fry/devup    #
        ####################################################
        # START

        #{env}

        # END

      DOTENV
    end

    def compose
      @compose ||= begin
                     Compose.current_version.new(
                       root.join("docker-compose.devup.yml"),
                       project: project, logger: logger, shell: shell
                     )
                   end
    end
  end
end
