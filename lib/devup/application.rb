require "devup/dotenv_load_list"
require "devup/environment"
require "devup/logger"
require "dotenv"

module Devup
  class Application
    def run
      return if devup_disabled?

      boot
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
        logger: Devup::Logger.build(log_level)
      )
    end

    def load_env
      begin
        Dotenv.instrumenter = ActiveSupport::Notifications
        ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          Spring.watch event.payload[:env].filename # if Rails.application
        end
      rescue LoadError, ArgumentError, NameError
        # Spring is not available
      end

      env = (ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development").to_sym
      list = Devup::DotenvLoadList.new(env: env)
      Dotenv.load(*list.to_a)
    end

    def log_level
      ENV.fetch("DEVUP_LOG_LEVEL", "info")
    end

    def devup_disabled?
      ENV.fetch("DEVUP_ENABLED", "true") != "true"
    end
  end
end
