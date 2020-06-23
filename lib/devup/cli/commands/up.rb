require "devup/cli/commands/command"
module Devup
  module CLI
    module Commands
      class Up < Command
        desc "Run dev services"

        option :verbose, type: :boolean, default: false, desc: "Verbose"

        def call(**options)
          super

          devup.up
          print_info
        end

        private

        def print_info
          puts <<~INFO

            Now you are ready to use services. All variables are available
            in a .env.services file. Just start you ruby application if
            gem "devup" is used. Or load variable manually with

                $ source .env.services

          INFO
        end
      end
    end
  end
end
