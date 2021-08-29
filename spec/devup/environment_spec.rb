require "devup/environment"

module Devup
  RSpec.describe Environment do
    let(:env) { described_class.new pwd: pwd, compose: compose, logger: logger }
    let(:logger) { Logger.build }
    let(:pwd) { Root.join("spec/dummy") }
    let(:compose) { double(:compose) }

    describe "#project" do
      let(:env) { described_class.new pwd: pwd, logger: logger }
      subject { env.project }
      let(:pwd) { "/apps/foo" }
      it { is_expected.to eq "foo" }
    end

    describe "#env" do
      subject { env.env }
      let(:compose) { double(:compose, services: services, service_ports: ports) }
      let(:services) { ["nginx"] }
      let(:ports) { [80] }
      before { allow(compose).to receive(:port_mapping).with(80).and_return("12345") }

      it { is_expected.to include("export NGINX_HOST=0.0.0.0") }
      it { is_expected.to include("export NGINX_PORT=12345") }

      context "when service has no exposed ports" do
        let(:ports) { [] }

        it { is_expected.not_to include("NGINX_PORT") }
      end
    end
  end
end
