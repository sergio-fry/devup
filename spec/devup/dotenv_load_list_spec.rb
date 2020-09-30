require "rspec/expectations"

RSpec::Matchers.define :have_less_priority_than do |expected|
  match do |actual|
    subject.index(actual) > subject.index(expected)
  end
end

require "devup/dotenv_load_list"

module Devup
  RSpec.describe DotenvLoadList do
    subject { DotenvLoadList.new env: app_env }
    let(:app_env) { nil }

    it { is_expected.to include ".env.services" }
    it { is_expected.to include ".env" }
    it { is_expected.to include ".env.local" }

    it { expect(".env").to have_less_priority_than(".env.services") }
    it { expect(".env.services").to have_less_priority_than(".env.local") }

    context "when env is development" do
      let(:app_env) { :development }

      it { is_expected.to include ".env.development.local" }
      it { is_expected.to include ".env.development" }
      it { expect(".env.local").to have_less_priority_than(".env.development.local") }
      it { expect(".env.development").to have_less_priority_than(".env.services") }
      it { expect(".env.development").to have_less_priority_than(".env.development.local") }
    end

    context "when env is test" do
      let(:app_env) { :test }
      # it { is_expected.not_to include ".env.local" }
    end
  end
end
