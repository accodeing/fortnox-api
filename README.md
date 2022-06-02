# Fortnox API
 > Wrapper gem for Fortnox AB's version 3 REST(ish) API. If you need to integrate an existing or new Ruby or Rails app against Fortnox this gem will save you a lot of time, you are welcome. Feel free to repay the community with some nice PRs of your own :simple_smile:

# Status for master
[![Gem version](https://img.shields.io/gem/v/fortnox-api.svg?style=flat-square)](https://rubygems.org/gems/fortnox-api)
[![Build Status](https://app.travis-ci.com/ehannes/fortnox-api.svg?branch=master)](https://app.travis-ci.com/github/accodeing/fortnox-api)

# Status for development
[![Build Status](https://app.travis-ci.com/ehannes/fortnox-api.svg?branch=development)](https://app.travis-ci.com/github/accodeing/fortnox-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/89d30a43fedf210d470b/maintainability)](https://codeclimate.com/github/accodeing/fortnox-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/89d30a43fedf210d470b/test_coverage)](https://codeclimate.com/github/accodeing/fortnox-api/test_coverage)

The rough status of this project is as follows (as of December 2020):
* Development is not as active as it used to be, but the project is not forgotten. We have an app running this gem in production and it works like a charm for what we do.
* We hope to be able to continue with our work with [rest_easy gem](https://github.com/accodeing/rest_easy), which generalize REST API's in general.
* Basic structure complete. Things like getting customers and invoices, updating and saving etc.
* Some advanced features implemented, for instance support for multiple Fortnox accounts and filtering entities.
* We have ideas for more advanced features, like sorting entities, pagination of results but nothing in the pipeline right now.
* A few models implemented. Right now we pretty good support for `Customer`, `Invoice`, `Order`, `Article`, `Label` and `Project`. Adding more models in general is quick and easy (that's the whole point with this gem), see the developer guide further down.

# Architecture overview
The gem is structured with distinct models for the tasks of data, JSON mapping and saving state. These are called: model, type, mapper and repository.

If you come from a Rails background and have not been exposed to other ways of structuring the solution to the CRUD problem this might seem strange to you since ActiveRecord merges these roles into the `ActiveRecord::Base` class.

To keep it simple: The active record pattern (as implemented by Rails) is easier to work with if you only have one data source, the database, in your application. The data mapper pattern is easier to work with if you have several data sources, such as different databases, external APIs and flat files on disk etc, in your application. It's also easier to compose the data mapper components into active record like classes than to separate active records parts to get a data mapper style structure.

If you are interested in a more detailed description of the difference between the two architectures you can read this post that explains it well using simple examples: [What’s the difference between Active Record and Data Mapper?](http://culttt.com/2014/06/18/whats-difference-active-record-data-mapper/)

## Model
The model role classes serve as dumb data objects. They do have some logic to coheres values etc, but they do not contain validation logic nor any business logic at all.

### Attribute
Several of the models share attributes. One example is account, as in a `Bookkeeping` account number. These attributes have the same definition, cohesion and validation logic so it makes sense to extract them from the models and put them in separate classes. For more information, see Types below.

### Immutability
The model instances are immutable. That means:
```ruby
customer.name # => "Old Name"
customer.name = 'New Name' # => "New Name"

customer.name == "New Name" # => false
```
Normally you would expect an assignment to mutate the instance and update the `name` field. Immutability explicitly means that you can't mutate state this way, any operation that attempts to update state needs to return a new instance with the updated state while leaving the old instance alone.

So you might think you should do this instead:
```ruby
customer = customer.name = 'New Name' # => "New Name"
```
But if you are familiar with chaining assignments in Ruby you will see that this does not work. The result of any assignment, `LHS = RHS`, operation in Ruby is `RHS`. Even if you implement your own `=` method and explicitly return something else. This is a feature of the language and not something we can get around. So instead you have to do:
```ruby
customer.name # => "Old Name"
updated_customer = customer.update( name: 'New Name' ) # => <Fortnox::API::Model::Customer:0x007fdf22949298 ... >
updated_customer.name == "New Name" # => true
```
And note that:
```ruby
customer.name # => "Old Name"
customer.update( name: 'New Name' ) # => <Fortnox::API::Model::Customer:0x007fdf21100b00 ... >
customer.name == "New Name" # => false
```
This is how all the models work, they are all immutable.

### Exceptions

Models can throw `Fortnox::API::AttributeError` if an attribute is invalid in some way (for instance if you try to assign a too long string to a limited string attribute) and `Fortnox::API::MissingAttributeError` if a required attribute is missing.

## Type
The types automatically enforce the constraints on values, lengths and, in some cases, content of the model attributes. Types forces your models to be correct before sending data to the API, which saves you a lot of API calls and rescuing the exception we throw when we get a 4xx/5xx response from the server (you can still get errors from the server; our implementation is not perfect. Also, Fortnox sometimes requires a specific combination of attributes).

## Repositories
Used to load, update, create and delete model instances. These are what is actually wrapping the HTTP REST API requests against Fortnox's server.

### Exceptions

Repositories can throw `Fortnox::API::RemoteServerError` if something went wrong at Fortnox.

## Mappers
These are responsible for the mapping between our plain old Ruby object models and Fortnox JSON requests. The repositories use the mappers to map models to JSON requests and JSON to model instances when working with the Fortnox API, you will not need to use them directly.

# Requirements

This gem is built for Ruby 2.6 or higher (see Travis configuration file for what versions we are testing against).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fortnox-api'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install fortnox-api
```

# Usage

## Authorization
> :warning: Before 2022, Fortnox used a client ID and a fixed access token for authorization. This way of is now deprecated. The old access tokens have a life span of 10 years according to Fortnox. They can still be used, but you can't issue any new long lived tokens and they recommend to migrate to the new authorization process. This gem will no longer support the old way of authorization since v0.9.0.

You need to have a Fortnox app and to create such an app, you need to register as a Fortnox developer. It might feel as if "I just want to create an integration to Fortnox, not build a public app to in the marketplace". Yeah, we agree... You don't need to release the app on the Fortnox Marketplace, but you need that Fortnox app. Also, see further Fortnox app requirements down below.

Start your journey at [Fortnox getting started guide](https://developer.fortnox.se/getting-started/). Note that there's a script to authorize the Fortnox app to your Fortnox account bundled with this gem to help you getting started, see [Initialization](#initialization). Also read [Authorizing your integration](https://developer.fortnox.se/general/authentication/).

Things you need:
- A Fortnox developer account
- A Fortnox app with:
  - Service account setting enabled (it's used in server to server integrations, which this is)
  - Correct scopes set
  - A redirect URL (just use a dummy URL if you want to, you just need the parameters send to that URL)
- A Fortnox test environment so that you can test your integration.

When you have authorized your integration you get an access token. It's a JWT with an expiration time of 1 hour. You also get a refresh token that lasts for **31 days**. When a new access token is requested, a new refresh token is also provided and the old one is invalidated. As long as the refresh token is valid, the gem will do all of this automatically. *You just need to make sure the gem makes a request the Fortnox API before the current refresh token expires*, otherwise you need to start over again with the [Initialization](#initialization).

## Initialization
As described in the [Authorization](#authorization) section, the gem refreshes the tokens automatically, but you need to initialize the process. There a script provided in `bin/get_tokens` to get your initial tokens.

### Configuration
The gem is configured in a `configure` block.

Due to Fortnox use of refresh tokens, the gem needs a storage of some sort to keep the tokens. The only thing the storage needs to expose is `access_token` and `refresh_token`. A very simplistic storage would look like this:

```ruby
class MyStorage
  require 'redis'

  attr_accessor :__access_token
  attr_accessor :__refresh_token

  alias_method :access_token, :__access_token
  alias_method :refresh_token, :__refresh_token

  def initialize
    @redis = Redis.new

    __access_token = @redis.get('access_token')
    __refresh_token = @redis.get('refresh_token')
  end

  def access_token= token
    __access_token = token
    @redis.set('access_token', token)
  end

  def refresh_token= token
    __refresh_token = token
    @redis.set('refresh_token', token)
  end
end
```

And could then be used like this:

```ruby
Fortnox::API.configure do |config|
  config.storage = MyStorage.new
end
```

The gem will then automatically refresh the tokens and keep them in the provided storage.

### Support for multiple Fortnox accounts
Yes, we support working with several accounts at once. Simply set `storages` (note the plural "s") and set it to a hash where the keys (called *token store*) represents different Fortnox accounts. Each needs a separate refresh and access token. If you provide a `:default` token store, this is used as default by all repositories.

```ruby
class MyStorage
  require 'redis'

  attr_accessor :__access_token
  attr_accessor :__refresh_token

  alias_method :access_token, :__access_token
  alias_method :refresh_token, :__refresh_token

  def initialize(account: nil)
    @redis = Redis.new

    @prefix = account.empty? ? :default : "#{account}"

    __access_token = @redis.get(access_token_key)
    __refresh_token = @redis.get(refresh_token_key)
  end

  def access_token=(token)
    __access_token = token
    @redis.set(access_token_key, token)
  end

  def refresh_token=(token)
    __refresh_token = token
    @redis.set(refresh_token_key, token)
  end

  private
    def access_token_key
      "#{@prefix}_access_token"
    end

    def refresh_token_key
      "#{@prefix}_refresh_token"
    end
end

Fortnox::API.configure do |config|
  config.storages = {
    default: MyStorage.new,
    another_account: MyStorage.new(account: :another_account)
  }
end

Fortnox::API::Repository::Customer.new # Using token store :default
Fortnox::API::Repository::Customer.new( token_store: :another_account ) # Using token store :another_account
```

Note that when you provide multiple token stores, you need to keep *all those refresh tokens* alive.

### Multiple access tokens
As of november 2021 and the new OAuth 2 flow, Fortnox has made [adjustments to the rate limit](https://developer.fortnox.se/blog/adjustments-to-the-rate-limit/) and it is no longer calculated per access token (if you are not using the old auth flow, but that flow is deprecated in this gem since v0.9.0).

# Usage
## Repositories
Repositories are used to load,save and remove entities from the remote server. The calls are subject to network latency and are blocking. Do make sure to rescue appropriate network errors in your code.

```ruby
# Instanciate a repository
repo = Fortnox::API::Repository::Customer.new

# Get a list of all the entities
repo.all #=> <Fortnox::API::Collection:0x007fdf2104575638 @entities: [<Fortnox::API::Customer::Simple:0x007fdf21033ee8>, <Fortnox::API::Customer::Simple:0x007fdf22994310>, ... ]

# Get entity by id
repo.find( 5 ) #=> <Fortnox::API::Model::Customer:0x007fdf21100b00>

# Get entities by attribute
repo.find_by( customer_number: 5 ) #=> <Fortnox::API::Collection:0x007fdf22994310 @entities: [<Fortnox::API::Customer::Simple:0x007fdf22949298>]
```
If you are eagle eyed you might have spotted the different classes for the entities returned in a collection vs the one we get from find. The `Simple` version of a class is used in thouse cases where the API-server doesn't return a full set of attributes for an entity. For customers the simple version has 10 attributes while the full have over 40.

> ​:info: ** Collections not implemented yet.

You should try to get by using the simple versions for as long as possible. Both the `Collection` and `Simple` classes have a `.full` method that will give you full versions of the entities. Bare in mind though that a collection of 20 simple models that you run `.full` on will call out to the server 20 times, in sequence.

> ​:info: ** We have opened a dialog with Fortnox about this API practice to allow for full models in the list request, on demand, and/or the ability for the client to specify the fields of interest when making the request, as per usual in REST APIs with partial load.

## Entities
All the repository methods return instances or collections of instances of some resource
class such as customer, invoice, item, voucher and so on.

Instances are immutable and any update returns a new instance with the
appropriate attributes changed (see the Immutable section under Architecture above for more details). To change the properties of a model works like this:

```ruby
customer #=> <Fortnox::API::Model::Customer:0x007fdf228db310>
customer.name #=> "Nelly Bloom"
customer.update( name: "Ned Stark" ) #=> <Fortnox::API::Model::Customer:0x0193a456ff0307>
customer.name #=> "Nelly Bloom"

updated_customer = customer.update( name: "Ned Stark" ) #=> <Fortnox::API::Model::Customer:0x0193a456fe3791>
updated_customer.name #=> "Ned Stark"
```

The update method takes an implicit hash of attributes to update, so you can update as many as you like in one go.

# Development
## Testing
This gem has integration tests to verify the code against the real API. It uses [vcr](https://github.com/vcr/vcr) to record API endpoint responses. These responses are stored locally and are called vcr cassettes. If no cassettes are available, vcr will record new ones for you. Once in a while, it's good to throw away all cassettes and rerecord them. Fortnox updates their endpoints and we need to keep our code up to date with the reality. There's a handy rake task for removing all cassettes, see `rake -T`. Note that when rerecording all cassettes, do it one repository at a time, otherwise you'll definitely get `429 Too Many Requests` from Fortnox. Run them manually with something like `bundle exec rspec spec/fortnox/api/repositories/article_spec.rb`. Also, you will need to update some test data in specs, see notes in specs.

### Seeding
There's a Rake task for seeding the Test Fortnox instance with data that the test suite needs. See `rake -T` to find the task.

## Rubocop
When updating Rubocop in `fortnox-api.gemspec`, you need to set the explicit version that codeclimate runs in `.codeclimate.yml`

## Updating Ruby version
When updating the required Ruby version, you need to do the following:
- Bump Ruby version in `fortnox-api.gemspec`
- Update gems if needed
- Verify that the test suite is passing
- Bump `TargetRubyVersion` in `.rubocop.yml` and verify that the Rubocop version we are using is supporting that Ruby version. Otherwise you need to upgrade Rubocop as well, see [Rubocop instructions](#rubocop).
- Update your local `.ruby-version` if you are using rbenv
- Update `.travis.yml` with the new Ruby versions
- Update required Ruby version in this readme
- Verify that all GitHub integrations works in the pull request you are creating

# Contributing
See the [CONTRIBUTE](CONTRIBUTE.md) readme.
