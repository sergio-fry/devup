require "devup/service_presenter"

module Devup
  RSpec.describe ServicePresenter do
    subject { presenter.call }
    let(:presenter) { described_class.new(service) }
    let(:service) { double(:service, name: name, ports: ports) }
    let(:name) { "nginx" }
    let(:ports) { [double(:port, from: 80, to: 32772)] }

    def should_include(text)
      expect(subject).to include text.strip
    end

    it { is_expected.to include "export NGINX_HOST=0.0.0.0" }
    it { is_expected.to include "export NGINX_PORT_80=32772" }
    it { is_expected.to include "export NGINX_PORT=32772" }

    context "when multiple ports" do
      let(:ports) { [double(:port, from: 80, to: 12345), double(:port, from: 433, to: 23456)] }

      it { is_expected.to include "export NGINX_HOST=0.0.0.0" }
      it { is_expected.to include "export NGINX_PORT_80=12345" }
      it { is_expected.to include "export NGINX_PORT_433=23456" }
    end

    context "when no ports" do
      let(:ports) { [] }
      it { is_expected.not_to include "NGINX_HOST" }
      it { is_expected.to include "# no exposed ports" }
    end

    describe "magic URLs" do
      context "when postgres" do
        let(:name) { "postgres" }
        let(:ports) { [double(:port, from: 5432, to: 32772)] }

        it { is_expected.to include "export DATABASE_URL=postgres://postgres@0.0.0.0:32772/db" }
      end

      context "when redis" do
        let(:name) { "redis" }
        let(:ports) { [double(:port, from: 6379, to: 32772)] }

        it { is_expected.to include "export REDIS_URL=redis://0.0.0.0:32772" }
      end

      context "when memcached"
      # MEMCACHE_SERVERS
      # 11211

      context "when mysql" do
        let(:name) { "mysql" }
        let(:ports) { [double(:port, from: 3306, to: 32772)] }

        it { is_expected.to include "export DATABASE_URL=mysql2://root@0.0.0.0:32772/db" }
      end
    end
  end
end
