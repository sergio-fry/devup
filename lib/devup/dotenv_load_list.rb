module Devup
  class DotenvLoadList
    def initialize(env: nil)
      @env = env.to_sym unless env.nil?
    end

    def to_a
      list = []

      list << ".env.#{@env}.local" if env_defined?

      # .env.local is ignored by dotenv-rails too. So behaviour is the same.
      # https://github.com/bkeepers/dotenv/blob/08f22148fb14019dce1e9b1d8ac1a74788e49e1b/lib/dotenv/rails.rb#L69
      list << ".env.local" unless test?

      list << ".env.services"
      list << ".env.#{@env}" if env_defined?
      list << ".env"

      list
    end

    def include?(val)
      to_a.include? val
    end

    def index(val)
      to_a.index val
    end

    def test?
      @env == :test
    end

    def env_defined?
      !@env.nil?
    end
  end
end
