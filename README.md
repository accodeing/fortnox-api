# Fortnox API
 > Wrapper gem for Fortnox AB's version 3 REST(ish) API. If you need to integrate an existing or new Ruby or Rails app against Fortnox this gem will save you a lot of time, you are welcome. Feel free to repay the community with some nice PRs of your own :simple_smile:


![Hacktoberfest logo](http://github-pages.ucl.ac.uk/hacktoberfest-2018/Hacktoberfest_2018_banner2_1518x190.png)
Thanks to the relatively simple structure of our library it is really easy to add new resources from the API to the gem, and we are missing a bunch! So head over to [the fortnox documentation](https://developer.fortnox.se/documentation/) and pick a resource that is missing and give us a hand :heart:

# Status for master
[![Gem version](https://img.shields.io/gem/v/fortnox-api.svg?style=flat-square)](https://rubygems.org/gems/fortnox-api)
[![Build status](https://img.shields.io/travis/my-codeworks/fortnox-api/master.svg?style=flat-square)](https://travis-ci.org/my-codeworks/fortnox-api)

# Status for development
[![Build status](https://img.shields.io/travis/my-codeworks/fortnox-api/development.svg?style=flat-square)](https://travis-ci.org/my-codeworks/fortnox-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/50d44a1d00620b4a6bde/maintainability)](https://codeclimate.com/github/my-codeworks/fortnox-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/50d44a1d00620b4a6bde/test_coverage)](https://codeclimate.com/github/my-codeworks/fortnox-api/test_coverage)

The rough status of this project is as follows (as of October 2018):
* Development is not as active as it used to be, but the project is not forgotten. We have an app running this gem in production and it works like a charm for what we do.
* We are planning on generalize REST API's in general with our [rest_easy gem](https://github.com/accodeing/rest_easy).
* Basic structure complete. Things like getting customers and invoices, updating and saving etc.
* Some advanced features implemented, for instance support for multiple Access Tokens and filtering entities.
* We have ideas for more advanced features, like sorting entities, pagination of results but nothing in the pipeline right now.
* A few models implemented. Right now we pretty good support for `Customer`, `Invoice`, `Order`, `Article`, `Label` and `Project`. Adding more models in general is quick and easy (that's the whole point with this gem), see the developer guide further down.
* Massive refactorings no longer occurs weekly :)

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

This gem is build for Ruby 2.2 or higher, it's tested agains Ruby 2.2.5, 2.3.0 and 2.3.1. Since it uses the keywords argument feature and since Ruby 2.1
is [officially outdated and unsupported](https://www.ruby-lang.org/en/news/2016/03/30/ruby-2-1-9-released/)
it won't work on older versions.

If you want or need Ruby 1.9 compatibility please submit a pull request.
Instructions can be found below :)

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

## Getting an AccessToken
To make calls to the API server you need a `ClientSecret` and an `AccessToken`. When you sign up for an API-account with Fortnox you should get a client secret and an authorization code. To get the access token, that is reusable, you need to do a one time exchange with the API-server and exchange your authorization code for an access token. For more information about how to get access tokens, see Fortnox developer documentation.

## Configuration
To configure the gem you can use the `configure` block. A `client_secret` and `access_token` (or `access_tokens` in plural, see [Multiple AccessTokens](#multiple-accesstokens)) are required configurations for the gem to work so at the very minimum you will need something like:

```ruby
Fortnox::API.configure do |config|
  config.client_secret = 'P5K5wE3Kun'
  config.access_token = '3f08d038-f380-4893-94a0a0-8f6e60e67a'
end
```
Before you start using the gem.

### Multiple AccessTokens

Fortnox uses quite low [API rate limits](https://developer.fortnox.se/blog/important-implementation-of-rate-limits/). The limit is for each access token, and according to Fortnox you can use as many tokens as you like to get around this problem. This gem supports handeling multiple access tokens natively. Just set the `access_tokens` (in plural, compared to `access_token` that only takes a String) to a list of strings:
```ruby
Fortnox::API.configure do |config|
  config.client_secret = 'P5K5wE3Kun'
  config.access_tokens ['a78d35hc-j5b1-ga1b-a1h6-h72n74fj5327', 's2b45f67-dh5d-3g5s-2dj5-dku6gn26sh62']
end
```
The gem will then automatically rotate between these tokens. In theory you can declare as many as you like. Remember that you will need to use one authorization code to get each token! See Fortnox developer documentation for more information about how to get access tokens.

### AccessTokens for multiple Fortnox accounts
Yes, we support working with several accounts at once as well. Simply set `access_tokens` to a hash where the keys (called a *token store*) represents different fortnox accounts and the value(s) for a specific key is an array or a string with access token(s) linked to that specific Fortnox account. For instance: `{ account1: ['token1', 'token2'], account2: 'token2' }`. If you provide a `:default` token store, this is used as default by all repositories.

```ruby
Fortnox::API.configure do |config|
  config.client_secret = 'P5K5wE3Kun'
  config.access_tokens = {
    default: ['3f08d038-f380-4893-94a0a0-8f6e60e67a', 'a78d35hc-j5b1-ga1b-a1h6-h72n74fj5327'],
    another_account: ['s2b45f67-dh5d-3g5s-2dj5-dku6gn26sh62']
  }
end

Fortnox::API::Repository::Customer.new # Using token store :default
Fortnox::API::Repository::Customer.new( token_store: :another_account ) # Using token store :another_account
```
The tokens per store are rotated between calls to the backend as well. That way you can create a web app that connects to multiple Fortnox accounts and uses multiple tokens for each account as well.

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

# Contributing
See the [CONTRIBUTE](CONTRIBUTE.md) readme.
