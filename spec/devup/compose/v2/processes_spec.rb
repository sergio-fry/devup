require "devup/compose/v2/processes"
require "devup/port_mapping"

module Devup
  module Compose
    module V2
      RSpec.describe Processes do
        let(:ps) { described_class.new output }

        context do
          let(:output) do
            <<~OUTPUT
              NAME               COMMAND              SERVICE    STATUS       PORTS
              devup_postgres_1   docker-entrypoint.sh postgres   running      0.0.0.0:33188->5432/tcp
            OUTPUT
          end

          it { expect(ps).to be_up }
        end

        context do
          let(:output) do
            <<~OUTPUT
              NAME               COMMAND              SERVICE    STATUS       PORTS
              devup_postgres_1   docker-entrypoint.sh postgres   running      0.0.0.0:33188->5432/tcp
              devup_reds_1       docker-entrypoint.sh foo        exited (127)
            OUTPUT
          end

          it { expect(ps).not_to be_up }
        end

        context do
          let(:output) do
            <<~OUTPUT
              NAME               COMMAND              SERVICE    STATUS       PORTS
              devup_postgres_1   docker-entrypoint.sh postgres   running      0.0.0.0:33188->5432/tcp
              devup_memcached_1  docker-entrypoint.sh postgres   running      0.0.0.0:33189->11211/tcp
            OUTPUT
          end

          it { expect(ps.port_mapping(5432)).to eq PortMapping.new(5432, 33188) }
          it { expect(ps.port_mapping(11211)).to eq PortMapping.new(11211, 33189) }
          it { expect(ps.port_mapping(123)).to eq PortMapping.new(123, nil) }
        end
      end
    end
  end
end
