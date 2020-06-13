require "dry/cli"

require "devup/cli/commands/up"
require "devup/cli/commands/down"

module Devup
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        def call(*)
          puts Devup::VERSION
        end
      end
    end
  end
end

Devup::CLI::Commands.register "version", Devup::CLI::Commands::Version, aliases: ["v", "-v", "--version"]
Devup::CLI::Commands.register "up", Devup::CLI::Commands::Up
Devup::CLI::Commands.register "down", Devup::CLI::Commands::Down
