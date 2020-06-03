require "devup/version"
require "devup/environment"

module Devup
  class Error < StandardError; end
  # Your code goes here...

  def self.root
    Pathname.new File.dirname(__dir__)
  end
end
