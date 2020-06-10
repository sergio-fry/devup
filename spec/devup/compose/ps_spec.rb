require "devup/compose/ps"

module Devup
  module ComposeHelpers
    RSpec.describe Ps do
      let(:ps) { described_class.new output }

      context do
        let(:output) do
          <<~OUTPUT
                        Name                           Command              State            Ports
            -----------------------------------------------------------------------------------------------
            devup_postgres_1   docker-entrypoint.sh postgres   Up      0.0.0.0:33188->5432/tcp
          OUTPUT
        end

        it { expect(ps).to be_up }
      end

      context do
        let(:output) do
          <<~OUTPUT
                        Name                           Command              State            Ports
            -----------------------------------------------------------------------------------------------
            devup_postgres_1   docker-entrypoint.sh postgres   Up      0.0.0.0:33188->5432/tcp
            devup_reds_1       docker-entrypoint.sh foo        Exit 127
          OUTPUT
        end

        it { expect(ps).not_to be_up }
      end

      context do
        let(:output) do
          <<~OUTPUT
                        Name                           Command              State            Ports
            -----------------------------------------------------------------------------------------------
            devup_postgres_1   docker-entrypoint.sh postgres   Up      0.0.0.0:33188->5432/tcp
            devup_memcached_1   docker-entrypoint.sh postgres   Up      0.0.0.0:33189->11211/tcp
          OUTPUT
        end

        it { expect(ps.port_mapping(5432)).to eq 33188 }
        it { expect(ps.port_mapping(11211)).to eq 33189 }
        it { expect(ps.port_mapping(123)).to be_nil }
      end
    end
  end
end
