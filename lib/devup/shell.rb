require "open3"

module Devup
  class Shell
    attr_reader :pwd, :logger

    def initialize(pwd:, logger:)
      @pwd = pwd
      @logger = logger
    end

    Result = Struct.new(:data, :status) {
      def success?
        status
      end
    }

    def exec(cmd)
      logger.debug "shell #{cmd}"

      output, error, status = Open3.capture3(cmd + ";")

      logger.error(error) unless status.success?

      Result.new(output, status.success?)
    end
  end
end
