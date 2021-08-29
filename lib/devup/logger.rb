require "logger"

module Devup
  class Logger
    def initialize(device: STDOUT, level: :info)
      @level = level
      @device = device
    end

    def debug(msg)
      logger.debug msg
    end

    def info(msg)
      logger.info msg
    end

    def error(msg)
      logger.error msg
    end

    private

    def logger
      logger = ::Logger.new(@device, formatter: formatter)

      logger.level = @level

      logger
    end

    def formatter
      ->(severity, _time, _progname, msg) { "DevUp! #{severity} #{msg}\n" }
    end
  end
end
