require "devup/dotenv_load_list"
require "devup/environment"
require "devup/logger"
require "dotenv"

module Devup
  class Application
    def run
      boot unless devup_disabled?
      load_env
    end

    def boot
      devup.up

      begin
        require "spring/commands"

        Spring.watch devup.root.join("docker-compose.yml")
      rescue LoadError, ArgumentError, NameError
        # Spring is not available
      end
    end

    def devup
      @devup ||= Devup::Environment.new(
        pwd: `pwd`,
        logger: Devup::Logger.new(level: log_level)
      )
    end

    def load_env
      if defined? ActiveSupport::Notifications
        Dotenv.instrumenter = ActiveSupport::Notifications
        ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          Spring.watch event.payload[:env].filename if defined? Spring
        end
      end

      Dotenv.load(*dotenv_list.to_a)
    end

    def app_env
      (ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development").to_sym
    end

    def dotenv_list
      Devup::DotenvLoadList.new(env: app_env)
    end

    def dotenv_vars
      Dotenv.parse(*dotenv_list.to_a)
    end

    def log_level
      ENV.fetch("DEVUP_LOG_LEVEL", dotenv_vars["DEVUP_LOG_LEVEL"] || "info")
    end

    def devup_disabled?
      ENV.fetch("DEVUP_ENABLED", dotenv_vars["DEVUP_ENABLED"] || "true") != "true"
    end
  end
end
