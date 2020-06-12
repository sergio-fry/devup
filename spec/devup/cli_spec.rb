require "devup/cli"
require "devup/environment"

module Devup
  RSpec.describe CLI, type: :cli do
    let(:cli) { Dry.CLI(CLI::Commands) }
    let(:cmd) { File.basename($PROGRAM_NAME, File.extname($PROGRAM_NAME)) }

    it "displays version" do
      output = capture_output { cli.call(arguments: ["version"]) }

      expect(output).to match VERSION
    end

    it "up" do
      expect_any_instance_of(Environment).to receive(:up)
      capture_output { cli.call(arguments: ["up"]) }
    end

    it "down" do
      expect_any_instance_of(Environment).to receive(:down)
      capture_output { cli.call(arguments: ["down"]) }
    end
  end
end
