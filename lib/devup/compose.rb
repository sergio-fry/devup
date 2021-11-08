require "devup/compose/v1/compose"
require "devup/compose/v2/compose"

module Devup
  module Compose
    def self.current_version
      case `docker-compose -v`.match(/v(\d).\d+.\d+/)[1].to_i
      when 1
        V1::Compose
      when 2
        V2::Compose
      else
        raise "Can't detect compose version"
      end
    end
  end
end
