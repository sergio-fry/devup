require "devup/version"
require "devup/environment"
require "devup/application"

module Devup
  class Error < StandardError; end
end

app = Devup::Application.new
app.run

