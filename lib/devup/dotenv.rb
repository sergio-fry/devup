require "dotenv"
require "devup/dotenv_load_list"

begin
  Dotenv.instrumenter = ActiveSupport::Notifications
  ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename # if Rails.application
  end
rescue LoadError, ArgumentError, NameError
  # Spring is not available
end

env = (ENV["RAILS_ENV"] || "development").to_sym
list = Devup::DotenvLoadList.new(env: env)
Dotenv.load(*list.to_a)
