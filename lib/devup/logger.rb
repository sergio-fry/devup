require "logger"

module Devup
  class Logger < ::Logger
    def self.build(level = :info)
      formatter = ->(_severity, _time, _progname, msg) { "DevUp! #{msg}\n" }
      logger = new(STDOUT, formatter: formatter)

      logger.level = level

      logger
    end
  end
end
