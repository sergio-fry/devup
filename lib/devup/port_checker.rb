require "socket"
require "timeout"

require "devup/logger"

module Devup
  class PortChecker
    def call(port)
      s = TCPSocket.new("0.0.0.0", port)
      s.write "1"
      s.close

      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      false
    end
  end
end
