require "devup/compose"
require "devup/logger"
require "devup/compose/port_config"

module Devup
  RSpec.describe Compose do
    let(:compose) { described_class.new docker_compose_path, logger: logger, shell: shell }
    let(:docker_compose_path) { Root.join("spec/dummy/docker-compose.yml") }
    let(:logger) { Logger.new(level: :error) }
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

    describe "#servport_mapping" do
      subject { compose.services }
      it { is_expected.to eq %w[nginx postgres] }
    end

    describe "#service_ports" do
      it { expect(compose.service_ports("nginx")).to eq [Compose::PortConfig.new("80"), Compose::PortConfig.new("81:8181")] }
      it { expect(compose.service_ports("postgres")).to eq [Compose::PortConfig.new("5432")] }

      context "when service has no port" do
        let(:config) do
          <<~COMPOSE
            version: '3'

            services:
              nginx:
                image: nginx
          COMPOSE
        end
        it { expect(compose.service_ports("nginx")).to eq [] }
      end
    end

    describe "#port_mapping" do
      subject { compose.port_mapping(port) }
      let(:port) { 80 }

      before do
        allow(shell).to receive(:exec)
          .with(/ps/)
          .and_return(double(data: output, success?: true))
      end
      let(:output) do
        <<~OUTPUT
                      Name                           Command              State            Ports
          -----------------------------------------------------------------------------------------------
          devup_nginx_1   docker-entrypoint.sh postgres   Up      0.0.0.0:33188->80/tcp
        OUTPUT
      end

      it { is_expected.to eq Port.new(80, 33188) }
    end
  end
end
