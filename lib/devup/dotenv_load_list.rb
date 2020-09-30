module Devup
  class DotenvLoadList
    def initialize(env: nil)
      @env = env.to_sym unless env.nil?
    end

    def to_a
      list = []

      list << ".env.#{@env}.local" if env_defined?
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
