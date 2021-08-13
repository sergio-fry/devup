require "socket"
require "timeout"

module Devup
  # TODO we should use this to check ports are ready
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
