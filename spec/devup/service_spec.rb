require "devup/service"
require "devup/port"

module Devup
  RSpec.describe Service do
    let(:service) { described_class.new compose, "postgres" }

    let(:compose) do
      double(:compose, service_ports: [Port.new(from: 5432, to: 32772)])
    end

    describe "#ports" do
      subject(:ports) { service.ports }

      it { is_expected.to be_an Array }

      describe "port" do
        subject { ports.first }
        it { expect(subject.from).to eq 5432 }
        it { expect(subject.to).to eq 32772 }
      end
    end
  end
end
