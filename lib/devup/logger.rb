require "logger"

module Devup
  class Logger < ::Logger
    def self.default
      formatter = ->(_severity, _time, _progname, msg) { "#{msg}\n" }
      new(STDOUT, formatter: formatter)
    end
  end
end
