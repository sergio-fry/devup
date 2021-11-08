require "devup/compose/v1/processes"

module Devup
  module Compose
    module V2
      class Processes < V1::Processes
        def up?
          service_lines.map { |line|
            line.match(/running/) && !line.match(/exited/)
          }.all?
        end

        private

        def service_lines
          output.split("\n")[1..-1]
        end
      end
    end
  end
end
