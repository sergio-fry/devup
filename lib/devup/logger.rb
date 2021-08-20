require "logger"

module Devup
  class Logger < ::Logger
    # Avoid factory. User new class instead
    def self.build(level = :info)
      formatter = ->(severity, _time, _progname, msg) { "DevUp! #{severity} #{msg}\n" }
      logger = new(STDOUT, formatter: formatter)

      logger.level = level

      logger
    end
  end
end
