# DevUp!  [![Travis (.com) branch](https://img.shields.io/travis/com/sergio-fry/devup/master)](https://travis-ci.com/github/sergio-fry/devup) [![Gem](https://img.shields.io/gem/v/devup)](https://rubygems.org/gems/devup) [![Code Climate coverage](https://img.shields.io/codeclimate/coverage/sergio-fry/devup)](https://codeclimate.com/github/sergio-fry/devup) [![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/sergio-fry/devup)](https://codeclimate.com/github/sergio-fry/devup) [![Gem](https://img.shields.io/gem/dt/devup)](https://rubygems.org/gems/devup)

Describe development dependencies with docker-compose. It is not required to remember any fancy command to start docker. Just start developing your app. Rails is a first-class citizen, but could be used without ruby.


## Requirements

* Docker (>= 19.03.8)
* Docker Compose (>= 1.25.5)



## Rails

Create a docker-compose.devup.yml with app dependencies like:

```yaml
version: "3"

services:
  postgres:
    image: postgres:10-alpine
    ports:
      - "5432"
```

Add **DevUp!** to your Gemfile

```ruby
gem "devup", group: [:development, :test]
```

and

    $ bundle install


Update your database.yml to use ENV:

```yaml
test:
  url: <%= ENV.fetch("DATABASE_URL") %>

development:
  url: <%= ENV.fetch("DATABASE_URL") %>

```


You are ready to use rails with PostgreSQL configured

    $ RAILS_ENV=test bundle exec rake db:create
    DevUp! INFO starting up...
    DevUp! INFO up

    $ Created database 'dummy_rails_test'


## Without Rails

ENV vars from .env.services are loaded with dotenv automatically.


```ruby
require "devup"
require "sequel"

DB = Sequel.connect(ENV.fetch("DATABASE_URL"))
```


## Without Ruby (PHP, nodejs, Java, ...)

Install DevUp!

    $ gem install devup

Start up services

    $ devup
    DevUp! INFO starting up...
    DevUp! INFO up

    $ cat .env.services
    export POSTGRES_HOST=0.0.0.0
    export POSTGRES_PORT=32944
    export POSTGRES_PORT_5432=32944
    export MEMCACHED_HOST=0.0.0.0
    export MEMCACHED_PORT=32943
    ...

Use your favourite dotenv extension to load vars from .env.services ([node-dotenv](https://www.npmjs.com/package/dotenv), [python-dotenv](https://pypi.org/project/python-dotenv/), [phpdotenv](https://github.com/vlucas/phpdotenv), ...)

Or load ENV vars manually

    $ source .env.services

Now you can run app

## How To

### Disable **DevUp!**

If you don't want devup to setup your dev services, you can disable it by using `DEVUP_ENABLED=false`. Just add it to .env.local file.

### Debug

    $ export DEVUP_LOG_LEVEL=debug
    $ devup

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sergio-fry/devup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sergio-fry/devup/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Devup project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sergio-fry/devup/blob/master/CODE_OF_CONDUCT.md).
