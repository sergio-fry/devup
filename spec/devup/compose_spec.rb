require "devup/compose"

module Devup
  RSpec.describe Compose do
    describe "#current_version" do
      context do
        let(:version) { "Composer version 1.8.4 2019-02-11 10:52:10" }
        it { expect(described_class.current_version(version)).to eq Compose::V1::Compose }
      end

      context do
        let(:version) { "Docker Compose version v2.0.0" }
        it { expect(described_class.current_version(version)).to eq Compose::V2::Compose }
      end
    end
  end
end
