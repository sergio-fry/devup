require "devup/version"
require "devup/environment"

module Devup
  class Error < StandardError; end
end

require "devup/boot"
require "devup/dotenv"
