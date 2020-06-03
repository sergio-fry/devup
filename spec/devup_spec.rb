require "devup/compose"

RSpec.describe Devup do
  it "has a version number" do
    expect(Devup::VERSION).not_to be nil
  end

  let(:docker_compose_path) { Devup.root.join("spec/dummy/docker-compose.yml") }

  it "works" do
    compose = Devup::Compose.new docker_compose_path, project: "devup-test"
    compose.up
    compose.stop
  end
end
