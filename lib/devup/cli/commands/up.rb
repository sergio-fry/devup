require "devup/cli/commands/command"
module Devup
  module CLI
    module Commands
      class Up < Command
        desc "Run dev services"

        option :verbose, type: :boolean, default: false, desc: "Verbose"

        def call(**options)
          super
          require "devup/environment"

          devup = Devup::Environment.new(
            pwd: `pwd`,
            logger: logger
          )

          devup.up
        end
      end
    end
  end
end
