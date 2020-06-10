require "devup/port_checker"

module Devup
  RSpec.describe PortChecker do
    before { `docker run --name devup_test -p #{port_mapping} -d nginx` }
    before { sleep 1 }
    let(:checker) { described_class.new }

    context "when port works" do
      let(:port_mapping) { "1234:80" }
      it { expect(checker.call(1234)).to be_truthy }
      it { expect(checker.call(2345)).to be_falsey }
    end

    after { `docker rm -f devup_test` }
  end
end
