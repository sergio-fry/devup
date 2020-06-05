require "dotenv"

# Add to Gemfile with require to load devup  ENV with dotenv.
#
#   gem "devup", require: "devup/dotenv"
#
module Dotenv
  alias load_without_services load

  def load(*files)
    load_without_services(*(files + [".env.services"]))
  end

  module_function :load
  module_function :load_without_services
end
