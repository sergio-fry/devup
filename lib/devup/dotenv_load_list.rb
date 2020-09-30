module Devup
  class DotenvLoadList
    def to_a
      list = []

      list << ".env.local"
      list << ".env.services"
      list << ".env"

      list
    end

    def include?(val)
      to_a.include? val
    end

    def index(val)
      to_a.index val
    end
  end
end
