require "devup/environment"
require "devup/logger"

RSpec.describe Devup, integration: true do
  it "has a version number" do
    expect(Devup::VERSION).not_to be nil
  end

  let(:devup) { Devup::Environment.new pwd: Root.join("spec/dummy"), logger: logger }
  let(:logger) { Devup::Logger.new(level: :error) }

  it "works" do
    devup.up

    dotenv = File.read(devup.root.join(".env.services"))
    expect(dotenv).to include("export NGINX_HOST=0.0.0.0")
  end

  after { devup.down }
end
