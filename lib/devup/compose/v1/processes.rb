require "devup/port_mapping"

module Devup
  module Compose
    module V1
      class Processes
        attr_reader :output
        def initialize(output)
          @output = output
        end

        def up?
          service_lines.map { |line|
            line.match(/Up/) && !line.match(/Exit/)
          }.all?
        end

        def port_mapping(port)
          m = output.match(/\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:(\d+)->#{port}\/tcp/)

          return PortMapping.new(port, nil) if m.nil?

          PortMapping.new(port, m[1].to_i)
        end

        private

        def service_lines
          output.split("\n")[2..-1]
        end
      end
    end
  end
end
