require "logger"

module Devup
  class Logger < ::Logger
    def self.default
      formatter = ->(_severity, _time, _progname, msg) { "DevUp! #{msg}\n" }
      logger = new(STDOUT, formatter: formatter)

      logger.level = Logger::INFO

      logger
    end
  end
end
