require "bundler/setup"
require "devup"

Dotenv.load(".env.custom")

puts ENV[ARGV[0]]
