# DevUp!

[![Travis (.com) branch](https://img.shields.io/travis/com/sergio-fry/devup/master)](https://travis-ci.com/github/sergio-fry/devup)
[![Gem](https://img.shields.io/gem/v/devup)](https://rubygems.org/gems/devup)
[![Code Climate coverage](https://img.shields.io/codeclimate/coverage/sergio-fry/devup)](https://codeclimate.com/github/sergio-fry/devup)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/sergio-fry/devup)](https://codeclimate.com/github/sergio-fry/devup)
[![Gem](https://img.shields.io/gem/dt/devup)](https://rubygems.org/gems/devup)

**DevUp!** is a tool to run dev dependencies. It builds ENV vars with dynamic exposed ports for services defined in a docker-compose.yml to access from application.

![demo](demo.gif)

## Installation

    $ gem install devup

## Usage

Create a docker-compose.yml with app dependencies like:

```yaml
version: '3'

services:
  postgres:
    image: postgres
    ports:
      - "5432"
```

Run services from docker-compose.yml

    $ devup 


### Rails

Update your database.yml to use ENV:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch("POSTGRES_HOST") %>
  port: <%= ENV.fetch("POSTGRES_PORT") %>
  username: postgres
  password:

development:
  <<: *default
  database: development

test:
  <<: *default
  database: test
```

Add devup/dotenv to your Gemfile:

    gem "devup"


### Non Rails


Load ENV vars from generated .env.services

```bash
$ source .env.services
```

Make youur app to use ENV configs app.rb

```ruby
database_url = "postgres://#{ENV["PG_HOST"]}:#{ENV["PG_PORT"]}/db"
puts database_url
```

Now you can run app

```bash
$ ruby app.rb
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sergio-fry/devup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sergio-fry/devup/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Devup project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sergio-fry/devup/blob/master/CODE_OF_CONDUCT.md).
