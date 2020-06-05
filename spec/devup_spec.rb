require "devup"

RSpec.describe Devup do
  it "has a version number" do
    expect(Devup::VERSION).not_to be nil
  end

  let(:docker_compose_path) { Devup.root.join("spec/dummy/docker-compose.yml") }

  let(:devup) { Devup::Environment.new pwd: Devup.root.join("spec/dummy") }

  it "works" do
    devup.up

    dotenv = File.read(devup.root.join(".env.services"))
    expect(dotenv).to include("export NGINX_HOST=0.0.0.0")
  end

  after { devup.down }
end
