module Devup
  class Compose
    class PortConfig
      def initialize(config)
        @config = config
      end

      def from
        @config.split(":")[-1].to_i
      end

      def ==(another)
        from == another.from
      end
    end
  end
end
