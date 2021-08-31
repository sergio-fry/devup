module Devup
  class Compose
    class PortMapping
      def initialize(config)
        @config = config
      end

      def from
        @config.split(":")[-1].to_i
      end
    end
  end
end
