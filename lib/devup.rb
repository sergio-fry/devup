require "devup/version"
require "devup/environment"

module Devup
  class Error < StandardError; end
end

if ENV.fetch("DEVUP_ENABLED", "true") == "true"
  require "devup/boot"
  require "devup/dotenv"
end
