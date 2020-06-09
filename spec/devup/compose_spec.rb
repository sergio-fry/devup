require "devup/compose"

module Devup
  RSpec.describe Compose do
    let(:compose) { described_class.new docker_compose_path, logger: logger }
    let(:docker_compose_path) { Root.join("spec/dummy/docker-compose.yml") }
    let(:logger) { double(:logger) }

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
      before do
        allow(compose).to receive(:exec).with("ps").and_return <<~OUT
                Name               Command          State                      Ports
          ---------------------------------------------------------------------------------------------
          devup_nginx_1      nginx -g daemon off;   Up      0.0.0.0:33143->80/tcp, 0.0.0.0:81->8181/tcp
          devup_postgres_1   nginx -g daemon off;   Up      0.0.0.0:33144->5432/tcp, 80/tcp
        OUT
      end

      it { expect(compose.service_ports("nginx")).to include({80 => 33143}) }
      it { expect(compose.service_ports("nginx")).to include({81 => 8181}) }
      it { expect(compose.service_ports("postgres")).to include({5432 => 33144}) }
    end
  end
end
