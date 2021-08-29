require "devup/logger"

module Devup
  module CLI
    module Commands
      class Command < Dry::CLI::Command
        def call(**options)
          @opts = options
        end

        private

        attr_reader :opts

        def logger
          @logger ||= Devup::Logger.new(level: log_level)
        end

        def log_level
          if opts.fetch(:verbose)
            :debug
          else
            :info
          end
        end

        def devup
          require "devup/environment"

          @devup ||= Devup::Environment.new(
            pwd: `pwd`,
            logger: logger
          )
        end
      end
    end
  end
end
