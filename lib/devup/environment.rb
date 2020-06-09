require "yaml"

require "devup/logger"
require "devup/compose"
require "devup/service"
require "devup/service_presenter"

module Devup
  class Environment
    attr_reader :pwd, :compose, :logger

    def initialize(pwd:, compose: nil, logger: Logger.default)
      @pwd = pwd.to_s.strip
      @compose = compose || Compose.new(root.join("docker-compose.devup.yml"), project: project, logger: logger)
      @logger = logger
    end

    def project
      pwd.split("/")[-1].strip
    end

    def env
      services.map { |s| service_env(s) }.join("\n\n")
    end

    def up
      logger.info "DevUp! is starting up services..."
      check
      compose.up
      write_dotenv
      logger.info "DevUp! is up"
    rescue
      clear_dotenv
      logger.info "DevUp! halted"
    end

    def down
      logger.info "DevUp! is shutting down services..."
      compose.stop
      compose.rm
      clear_dotenv
      logger.info "DevUp! is down"
    rescue
      logger.info "DevUp! halted"
    end

    def root
      Pathname.new pwd
    end

    private

    def check
      return false if missing_config

      compose.check

      true
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
      ServicePresenter.new(service, project: project).call
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
  end
end
