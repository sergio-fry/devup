require "devup/logger"

module Devup
  RSpec.describe Logger do
    subject(:logger) { described_class.new device: device }
    let(:device) { StringIO.new }

    it { expect { logger.debug("msg") }.not_to raise_error }
    it { expect { logger.error("msg") }.not_to raise_error }
    it { expect { logger.info("msg") }.not_to raise_error }
  end
end
