require "devup/dotenv_load_list"

module Devup
  RSpec.describe DotenvLoadList do
    subject { DotenvLoadList.new.to_a }

    it { is_expected.to include ".env.services" }
  end
end
