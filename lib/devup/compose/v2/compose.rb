require "devup/compose/v1/compose"
require "devup/compose/v2/processes"

module Devup
  module Compose
    module V2
      class Compose < V1::Compose
        def processes(cached: true)
          Processes.new(cached ? exec_ps_cached : exec_ps)
        end
      end
    end
  end
end
