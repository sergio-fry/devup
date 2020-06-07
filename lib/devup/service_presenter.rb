module Devup
  class ServicePresenter
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def call
      res = []

      res << "export #{service.name.upcase}_HOST=0.0.0.0"

      if service.ports.size > 0
        res << "export #{service.name.upcase}_PORT=#{service.ports.first.to}"

        service.ports.each do |port|
          res << "export #{service.name.upcase}_PORT_#{port.from}=#{port.to}"
        end
      end

      res.join "\n"
    end
  end
end
