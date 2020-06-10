require "devup/compose"
require "devup/logger"

module Devup
  RSpec.describe Compose do
    let(:compose) { described_class.new docker_compose_path, logger: logger, shell: shell }
    let(:docker_compose_path) { Root.join("spec/dummy/docker-compose.yml") }
    let(:logger) { Logger.build(:error) }
    let(:shell) { double(:shell) }

    let(:config) do
      <<~COMPOSE
        version: '3'

        services:
          nginx:
            image: nginx
            ports:
              - "80"
              - "81:8181"

          postgres:
            image: nginx
            ports:
              - "5432"
      COMPOSE
    end

    before { allow(compose).to receive(:config_content).and_return(config) }

    describe "#services" do
      subject { compose.services }
      it { is_expected.to eq %w[nginx postgres] }
    end

    describe "#service_ports" do
      it { expect(compose.service_ports("nginx")).to eq [80, 8181] }
      it { expect(compose.service_ports("postgres")).to eq [5432] }
    end

    describe "#port_mapping" do
      subject { compose.port_mapping(serivce, port) }
      let(:serivce) { "nginx" }
      let(:port) { 80 }

      before do
        allow(shell).to receive(:exec)
          .with(/port nginx 80/)
          .and_return(double(data: "0.0.0.0:33188", success?: true))
      end

      it { is_expected.to eq 33188 }
    end
  end
end
