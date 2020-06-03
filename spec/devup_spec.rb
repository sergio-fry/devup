require "devup/environment"

RSpec.describe Devup do
  it "has a version number" do
    expect(Devup::VERSION).not_to be nil
  end

  let(:docker_compose_path) { Devup.root.join("spec/dummy/docker-compose.yml") }

  it "works" do
    devup = Devup::Environment.new pwd: Devup.root.join("spec/dummy")
    devup.up
    devup.down
  end
end
