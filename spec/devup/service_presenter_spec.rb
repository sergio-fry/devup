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

    it {
      should_include <<~TXT
        export NGINX_HOST=0.0.0.0
        export NGINX_PORT=32772
        export NGINX_PORT_80=32772
      TXT
    }
  end
end
