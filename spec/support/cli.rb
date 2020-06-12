module RSpec
  module Support
    module Helpers
      module Cli
        def capture_output
          require "stringio"
          output = StringIO.new
          original_stdout = $stdout
          $stdout = output
          yield
          output.string
        rescue SystemExit
          output.string
        ensure
          $stdout = original_stdout
        end

        def capture_error
          require "stringio"
          error = StringIO.new
          original_stderr = $stderr
          $stderr = error
          yield
          error.string
        rescue SystemExit
          error.string
        ensure
          $stderr = original_stderr
        end
      end
    end
  end
end
