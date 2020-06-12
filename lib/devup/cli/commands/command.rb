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
          @logger ||= Devup::Logger.build(log_level)
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
