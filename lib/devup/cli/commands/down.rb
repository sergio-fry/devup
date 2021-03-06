module Devup
  module CLI
    module Commands
      class Down < Command
        desc "Stop dev services"

        option :verbose, type: :boolean, default: false, desc: "Verbose"

        def call(**options)
          super

          devup.down
        end
      end
    end
  end
end
