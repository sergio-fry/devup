require "devup/shell"
require "devup/logger"

module Devup
  RSpec.describe Shell do
    let(:shell) { described_class.new pwd: `pwd`, logger: Logger.build }

    describe "#exec" do
      context "when success" do
        subject { shell.exec "echo 123" }
        it { is_expected.to be_success }
        it { expect(subject.data).to include "123" }
      end

      context "when fail" do
        subject { shell.exec "unknown command" }
        it { is_expected.not_to be_success }
      end
    end
  end
end
