# Fortnox API

Wrapper gem for Fortnox AB's version 3 REST(ish) API. If you need to integrate
an existing or new Ruby or Rails app against Fortnox this gem will save you a
lot of time, you are welcome. Feel free to repay the community with some nice
PRs of your own 😃

# Status for master

[![Gem version](https://img.shields.io/gem/v/fortnox-api.svg?style=flat-square)](https://rubygems.org/gems/fortnox-api)
[![Build Status](https://app.travis-ci.com/ehannes/fortnox-api.svg?branch=master)](https://app.travis-ci.com/github/accodeing/fortnox-api)

# Status for development

[![Build Status](https://app.travis-ci.com/ehannes/fortnox-api.svg?branch=development)](https://app.travis-ci.com/github/accodeing/fortnox-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/89d30a43fedf210d470b/maintainability)](https://codeclimate.com/github/accodeing/fortnox-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/89d30a43fedf210d470b/test_coverage)](https://codeclimate.com/github/accodeing/fortnox-api/test_coverage)

The rough status of this project is as follows (as of spring 2023):

- `master` branch and the released versions should be production ready.
- We are actively working on our generalization of this gem:
  [rest_easy gem](https://github.com/accodeing/rest_easy). It will be a base for
  REST API's in general.
- Basic structure complete. Things like getting customers and invoices, updating
  and saving etc.
- Some advanced features implemented, for instance support for multiple Fortnox
  accounts and filtering entities.
- We have ideas for more advanced features, like sorting entities, pagination of
  results but it's not implemented...
- A few models implemented. Right now we pretty good support for `Customer`,
  `Invoice`, `Order`, `Article`, `Label` and `Project`. Adding more models in
  general is quick and easy (that's the whole point with this gem), see the
  developer guide further down.

# Architecture overview

The gem is structured with distinct models for the tasks of data, JSON mapping
and saving state. These are called: model, type, mapper and repository.

If you come from a Rails background and have not been exposed to other ways of
structuring the solution to the CRUD problem this might seem strange to you
since ActiveRecord merges these roles into the `ActiveRecord::Base` class.

To keep it simple: The active record pattern (as implemented by Rails) is easier
to work with if you only have one data source, the database, in your
application. The data mapper pattern is easier to work with if you have several
data sources, such as different databases, external APIs and flat files on disk
etc, in your application. It's also easier to compose the data mapper components
into active record like classes than to separate active records parts to get a
data mapper style structure.

If you are interested in a more detailed description of the difference between
the two architectures you can read this post that explains it well using simple
examples:
[What’s the difference between Active Record and Data Mapper?](http://culttt.com/2014/06/18/whats-difference-active-record-data-mapper/)

## Model

The model role classes serve as dumb data objects. They do have some logic to
coheres values etc, but they do not contain validation logic nor any business
logic at all.

### Attribute

Several of the models share attributes. One example is account, as in a
`Bookkeeping` account number. These attributes have the same definition,
cohesion and validation logic so it makes sense to extract them from the models
and put them in separate classes. For more information, see Types below.

### Immutability

The model instances are immutable. That means:

```ruby
customer.name # => "Old Name"
customer.name = 'New Name' # => "New Name"

customer.name == "New Name" # => false
```

Normally you would expect an assignment to mutate the instance and update the
`name` field. Immutability explicitly means that you can't mutate state this
way, any operation that attempts to update state needs to return a new instance
with the updated state while leaving the old instance alone.

So you might think you should do this instead:

```ruby
customer = customer.name = 'New Name' # => "New Name"
```

But if you are familiar with chaining assignments in Ruby you will see that this
does not work. The result of any assignment, `LHS = RHS`, operation in Ruby is
`RHS`. Even if you implement your own `=` method and explicitly return something
else. This is a feature of the language and not something we can get around. So
instead you have to do:

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

Models can throw `Fortnox::API::AttributeError` if an attribute is invalid in
some way (for instance if you try to assign a too long string to a limited
string attribute) and `Fortnox::API::MissingAttributeError` if a required
attribute is missing.

## Type

The types automatically enforce the constraints on values, lengths and, in some
cases, content of the model attributes. Types forces your models to be correct
before sending data to the API, which saves you a lot of API calls and rescuing
the exception we throw when we get a 4xx/5xx response from the server (you can
still get errors from the server; our implementation is not perfect. Also,
Fortnox sometimes requires a specific combination of attributes).

## Repositories

Used to load, update, create and delete model instances. These are what is
actually wrapping the HTTP REST API requests against Fortnox's server.

### Exceptions

Repositories can throw `Fortnox::API::RemoteServerError` if something went wrong
at Fortnox.

## Mappers

These are responsible for the mapping between our plain old Ruby object models
and Fortnox JSON requests. The repositories use the mappers to map models to
JSON requests and JSON to model instances when working with the Fortnox API, you
will not need to use them directly.

# Requirements

This gem is built for Ruby 2.6 or higher (see Travis configuration file for what
versions we are testing against).

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

> :warning: Before 2022, Fortnox used a client ID and a fixed access token for
> authorization. This way of is now deprecated. The old access tokens have a
> life span of 10 years according to Fortnox. They can still be used, but you
> can't issue any new long lived tokens and they recommend to migrate to the new
> authorization process. This gem will no longer support the old way of
> authorization since v0.9.0.

You need to have a Fortnox app and to create such an app, you need to register
as a Fortnox developer. It might feel as if "I just want to create an
integration to Fortnox, not build a public app to in the marketplace". Yeah, we
agree... You don't need to release the app on the Fortnox Marketplace, but you
need that Fortnox app. Also, see further Fortnox app requirements down below.

Start your journey at
[Fortnox getting started guide](https://developer.fortnox.se/getting-started/).
Note that there's a script to authorize the Fortnox app to your Fortnox account
bundled with this gem to help you getting started, see
[Initialization](#initialization). Also read
[Authorizing your integration](https://developer.fortnox.se/general/authentication/).

Things you need:

- A Fortnox developer account
- A Fortnox app with:
  - Service account setting enabled (it's used in server to server integrations,
    which this is)
  - Correct scopes set
  - A redirect URL (just use a dummy URL if you want to, you just need the
    parameters send to that URL)
- A Fortnox test environment so that you can test your integration.

When you have authorized your integration you get an access token from Fortnox.
It's a JWT with a expiration time (currently **1 hour**). You also get a long
lived refresh token (currently lasts for **31 days** ). When you need a new
access token you send a renewal request to Fortnox. That request contains the
new access token as well as a new refresh token and some other data. Note that
**the old refresh token is invalidated when new tokens are requested**. As long
as you have a valid refresh token you will be available to request new tokens.

The gem exposes a specific repository for renewing tokens. You use it like this:

```ruby
require 'fortnox/api'

tokens = Fortnox::API::Repository::Authentication.new.renew_tokens(
  refresh_token: 'a valid refresh token',
  client_id: "the integration's client id",
  client_secret: "the integration's client secret"
)

# You probably want to persist your tokens somehow...
store_refresh_token(tokens[:refresh_token])
store_access_token(tokens[:access_token])

# Set the new access token
Fortnox::API.access_token = tokens[:access_token]

# The gem will now use the new access token
Fortnox::API::Repository::Customer.new.all
```

It's up to you to provide a valid token to the gem and to renew it regularly,
otherwise you need to start over again with the
[Initialization](#initialization).

## Get tokens

There's a script in `bin/get_tokens` to issue valid access and refresh tokens.
Provide valid credentials in `.env`, see `.env.template` or have a look in the
script itself to see what's needed.

### Configuration

The gem can be configured in a `configure` block, where `setting` is one of the
settings from the table below.

```ruby
Fortnox::API.configure do |config|
  config.setting = 'value'
end
```

| Setting     | Description                       | Required | Default                                                         |
| ----------- | --------------------------------- | -------- | --------------------------------------------------------------- |
| `base_url`  | The base url to Fortnox API       | No       | `'https://api.fortnox.se/3/'`                                   |
| `token_url` | The url to Fortnox token endpoint | No       | `'https://apps.fortnox.se/oauth-v1/token'`                      |
| `debugging` | For debugging                     | No       | `false`                                                         |
| `logger`    | The logger to use                 | No       | A simple logger that writes to `$stdout` with log level `WARN`. |

### Support for multiple Fortnox accounts

Yes, we support working with several accounts at once. Simply switch access
token between calls. The token is stored in the current thread, so it's thread
safe.

```ruby
repository = Fortnox::API::Repository::Customer.new

Fortnox::API.access_token = 'account1_access_token'
repository.all # Calls account1

Fortnox::API.access_token = 'account2_access_token'
repository.all # Calls account2
```

### Automatic access tokens rotation (deprecated)

As of november 2021 and the new OAuth 2 flow, Fortnox has made
[adjustments to the rate limit](https://developer.fortnox.se/blog/adjustments-to-the-rate-limit/)
and it is no longer calculated per access token (if you are not using the old
auth flow, but that flow is deprecated in this gem since v0.9.0).

# Usage

## Repositories

Repositories are used to load,save and remove entities from the remote server.
The calls are subject to network latency and are blocking. Do make sure to
rescue appropriate network errors in your code.

```ruby
require 'fortnox/api'

Fortnox::API.access_token = 'valid_access_token'

# Instanciate a repository
repo = Fortnox::API::Repository::Customer.new

# Get a list of all the entities
repo.all #=> <Fortnox::API::Collection:0x007fdf2104575638 @entities: [<Fortnox::API::Customer::Simple:0x007fdf21033ee8>, <Fortnox::API::Customer::Simple:0x007fdf22994310>, ... ]

# Get entity by id
repo.find( 5 ) #=> <Fortnox::API::Model::Customer:0x007fdf21100b00>

# Get entities by attribute
repo.find_by( customer_number: 5 ) #=> <Fortnox::API::Collection:0x007fdf22994310 @entities: [<Fortnox::API::Customer::Simple:0x007fdf22949298>]
```

If you are eagle eyed you might have spotted the different classes for the
entities returned in a collection vs the one we get from find. The `Simple`
version of a class is used in thouse cases where the API-server doesn't return a
full set of attributes for an entity. For customers the simple version has 10
attributes while the full have over 40.

> :info: \*\* Collections not implemented yet.

You should try to get by using the simple versions for as long as possible. Both
the `Collection` and `Simple` classes have a `.full` method that will give you
full versions of the entities. Bare in mind though that a collection of 20
simple models that you run `.full` on will call out to the server 20 times, in
sequence.

> :info: \*\* We have opened a dialog with Fortnox about this API practice to
> allow for full models in the list request, on demand, and/or the ability for
> the client to specify the fields of interest when making the request, as per
> usual in REST APIs with partial load.

## Entities

All the repository methods return instances or collections of instances of some
resource class such as customer, invoice, item, voucher and so on.

Instances are immutable and any update returns a new instance with the
appropriate attributes changed (see the Immutable section under Architecture
above for more details). To change the properties of a model works like this:

```ruby
require 'fortnox/api'

customer #=> <Fortnox::API::Model::Customer:0x007fdf228db310>
customer.name #=> "Nelly Bloom"
customer.update( name: "Ned Stark" ) #=> <Fortnox::API::Model::Customer:0x0193a456ff0307>
customer.name #=> "Nelly Bloom"

updated_customer = customer.update( name: "Ned Stark" ) #=> <Fortnox::API::Model::Customer:0x0193a456fe3791>
updated_customer.name #=> "Ned Stark"
```

The update method takes an implicit hash of attributes to update, so you can
update as many as you like in one go.

# Contributing

See the [CONTRIBUTE](CONTRIBUTE.md) readme.
