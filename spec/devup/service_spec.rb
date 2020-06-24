require "devup/service"

module Devup
  RSpec.describe Service do
    let(:service) { described_class.new compose, "postgres" }

    let(:compose) { double :compose }
    before { allow(compose).to receive(:service_ports).with("postgres").and_return([5432]) }
    before { allow(compose).to receive(:port_mapping).with(5432).and_return(32772) }

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
