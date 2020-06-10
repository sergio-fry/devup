require "devup/environment"
require "devup/logger"

RSpec.describe Devup do
  it "has a version number" do
    expect(Devup::VERSION).not_to be nil
  end

  let(:docker_compose_path) { Root.join("spec/dummy/docker-compose.yml") }

  let(:devup) { Devup::Environment.new pwd: Root.join("spec/dummy"), logger: logger }
  let(:logger) { Devup::Logger.build(:error) }

  it "works" do
    devup.up

    dotenv = File.read(devup.root.join(".env.services"))
    expect(dotenv).to include("export NGINX_HOST=0.0.0.0")
  end

  after { devup.down }
end
