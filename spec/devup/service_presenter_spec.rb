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
      it { is_expected.to include "export NGINX_PORT=12345" }
      it { is_expected.to include "export NGINX_PORT_80=12345" }
      it { is_expected.to include "export NGINX_PORT_433=23456" }
    end

    context "when no ports" do
      let(:ports) { [] }
      it { is_expected.not_to include "NGINX_HOST" }
      it { is_expected.to include "# no exposed ports" }
    end
  end
end
