require "dry/cli"

module Devup
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        def call(*)
          puts Devup::VERSION
        end
      end

      class Up < Dry::CLI::Command
        desc "Run dev services"

        option :verbose, type: :boolean, default: false, desc: "Verbose"

        attr_reader :opts

        def call(**options)
          require "devup/environment"

          @opts = options

          devup = Devup::Environment.new(
            pwd: `pwd`,
            logger: Devup::Logger.build(log_level)
          )

          devup.up
        end

        def log_level
          if opts.fetch(:verbose)
            :debug
          else
            :info
          end
        end
      end

      class Down < Dry::CLI::Command
        desc "Run dev services"

        option :verbose, type: :boolean, default: false, desc: "Verbose"

        attr_reader :opts

        def call(**options)
          require "devup/environment"

          @opts = options

          devup = Devup::Environment.new(
            pwd: `pwd`,
            logger: Devup::Logger.build(log_level)
          )

          devup.down
        end

        def log_level
          if opts.fetch(:verbose)
            :debug
          else
            :info
          end
        end
      end
    end
  end
end

Devup::CLI::Commands.register "version", Devup::CLI::Commands::Version, aliases: ["v", "-v", "--version"]
Devup::CLI::Commands.register "up", Devup::CLI::Commands::Up
Devup::CLI::Commands.register "down", Devup::CLI::Commands::Down
