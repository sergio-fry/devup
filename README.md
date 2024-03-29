# DevUp!  [![Travis (.com) branch](https://img.shields.io/travis/com/sergio-fry/devup/master)](https://travis-ci.com/github/sergio-fry/devup) [![Gem](https://img.shields.io/gem/v/devup)](https://rubygems.org/gems/devup) [![Code Climate coverage](https://img.shields.io/codeclimate/coverage/sergio-fry/devup)](https://codeclimate.com/github/sergio-fry/devup) [![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/sergio-fry/devup)](https://codeclimate.com/github/sergio-fry/devup) [![Gem](https://img.shields.io/gem/dt/devup)](https://rubygems.org/gems/devup) [![Hits-of-Code](https://hitsofcode.com/github/sergio-fry/devup)](https://hitsofcode.com/view/github/sergio-fry/devup)


Instead of installing and configuring local PostgreSQL, Redis and other external services, describe development dependencies with docker-compose. It is not required to remember any fancy command to start docker. Just start developing your app. Rails is a first-class citizen, but could be used without ruby.

1. `bundle add aasm --group=development,test`
2. Describe external services inside docker-compose.devup.yml
3. `devup up`
4. Confugure app to use ENV


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

# To prevent devup boot every time, you can require "devup/env" only:
# gem "devup", group: [:development, :test], require: "devup/env"
```

and

    $ bundle install


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


You are ready to use rails with PostgreSQL configured

    $ RAILS_ENV=test bundle exec rake db:create
    DevUp! INFO starting up...
    DevUp! INFO up

    $ Created database 'test'


## Without Rails

ENV vars from .env.services are loaded with dotenv automatically.


```ruby
require "devup"
require "sequel"

DB = Sequel.connect(adapter: "postgres", host: ENV.fetch("POSTGRES_HOST"), port: ENV.fetch("POSTGRES_PORT"), database: "blog", user: 'postgres')
```


## Without Ruby (PHP, nodejs, Java, ...)

Install DevUp!

    $ gem install devup

Start up services

    $ devup up
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

If you don't want devup to setup your dev services, you can disable it by using `DEVUP_ENABLED=false`. Just add it to .env.test.local file.

### Override some service

If you want to switch some service from DevUp! to another, you can override ENV in a local dotenv configs:

   * .env.local
   * .env.development.local
   * .env.test.local

Just put to your .env.local:

    export POSTGRES_HOST=0.0.0.0
    export POSTGRES_PORT=5432

### Get some DATABASE_URL working


Just put to your .env.test or .env.development something like:

    DATABASE_URL=postgres://postgres@$POSTGRES_HOST:$POSTGRES_PORT/test_db

### Debug

    $ export DEVUP_LOG_LEVEL=debug
    $ devup up

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sergio-fry/devup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sergio-fry/devup/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Devup project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sergio-fry/devup/blob/master/CODE_OF_CONDUCT.md).
