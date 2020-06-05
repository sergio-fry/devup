require "devup/environment"

module Devup
  RSpec.describe Environment do
    let(:env) { described_class.new pwd: pwd, compose: compose }
    let(:pwd) { Root.join("spec/dummy") }
    let(:compose) { double(:compose) }

    describe "#project" do
      let(:env) { described_class.new pwd: pwd }
      subject { env.project }
      let(:pwd) { "/apps/foo" }
      it { is_expected.to eq "foo" }
    end

    describe "#vars" do
      subject { env.vars }
      let(:compose) { double(:compose, services: services, service_ports: ports) }
      let(:services) { ["nginx"] }
      let(:ports) { ["80"] }
      before { allow(compose).to receive(:exec).with("port nginx 80").and_return("0.0.0.0:12345") }

      it { is_expected.to include("NGINX_HOST" => "0.0.0.0") }
      it { is_expected.to include("NGINX_PORT" => "12345") }
      it { is_expected.to include("NGINX_PORT_80" => "12345") }

      context "when service has no exposed ports" do
        let(:ports) { [] }

        it { is_expected.to include("NGINX_HOST" => "0.0.0.0") }
        it { is_expected.not_to include("NGINX_PORT" => "12345") }
      end
    end

    describe "#env" do
      subject { env.env }
      before { allow(env).to receive(:vars).and_return(vars) }
      let(:vars) { [{"A" => 1}] }

      it { is_expected.to include("export A=1") }
    end
  end
end
