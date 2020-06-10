require "logger"

module Support
  class LoggerFactory
    def self.call(level = Logger::ERROR)
      formatter = ->(_severity, _time, _progname, msg) { "DevUp! #{msg}\n" }
      logger = Logger.new(STDOUT, formatter: formatter)

      logger.level = level

      logger
    end
  end
end
