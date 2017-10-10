# Fortnox API
 > Wrapper gem for Fortnox AB's version 3 REST(ish) API. If you need to integrate an existing or new Ruby or Rails app against Fortnox this gem will save you a lot of time, you are welcome. Feel free to repay the community with some nice PRs of your own :simple_smile:

# Status for master
[![Gem version](https://img.shields.io/gem/v/fortnox-api.svg?style=flat-square)](https://rubygems.org/gems/fortnox-api)
[![Build status](https://img.shields.io/travis/my-codeworks/fortnox-api/master.svg?style=flat-square)](https://travis-ci.org/my-codeworks/fortnox-api)
[![Dependency status](https://img.shields.io/gemnasium/my-codeworks/fortnox-api.svg?style=flat-square)](https://gemnasium.com/my-codeworks/fortnox-api)

# Status for development
[![Build status](https://img.shields.io/travis/my-codeworks/fortnox-api/development.svg?style=flat-square)](https://travis-ci.org/my-codeworks/fortnox-api)
[![Code Climate](https://img.shields.io/codeclimate/github/my-codeworks/fortnox-api.svg?style=flat-square)](https://codeclimate.com/github/my-codeworks/fortnox-api)
[![Test coverage](https://img.shields.io/codeclimate/coverage/github/my-codeworks/fortnox-api.svg?style=flat-square)](https://codeclimate.com/github/my-codeworks/fortnox-api/coverage)

The rough status of this project is as follows (as of November 2016):
* In active development (just check out the commit log)
* Two developers. At least twice as good as one.
* Basic structure complete. Things like getting customers and invoices, updating and saving etc.
* Some advanced features implemented, for instance support for multiple Access Tokens and filtering entities.
* Advanced features around the corner. Things like sorting entities, pagination of results etc.
* A few models implemented. Right now we have nearly full support for `Customer`, `Invoice` and `Order`. Adding more models in general is quick and easy, see the developer guide further down.
* Massive refactorings no longer occurs weakly :) We are running this gem in production for live test.

The goal is to have a production ready version that covers at least the `Invoice`, `Order`,  `Customer` and `Project` models by January.

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

## Type
The types automatically enforce the constraints on values, lengths and, in some cases, content of the model attributes. Types forces your models to be correct before sending data to the API, which saves you a lot of API calls and rescuing the exception we throw when we get a 4xx/5xx response from the server (you can still get errors from the server; our implementation is not perfect. Also, Fortnox sometimes requires a specific combination of attributes).

## Repositories
Used to load, update, create and delete model instances. These are what is actually wrapping the HTTP REST API requests against Fortnox's server.

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
To make calls to the API server you need a `ClientSecret` and an `AccessToken`. When you sign up for an API-account with Fortnox you should get a client secret and an authorization code. To get the access token, that is reusable, you need to do a one time exchange with the API-server and exchange your authorization code for an access token. This can be done in several ways but we provide a method for it in the gem that you can use.

> ​:warning: **Do not do this more than once!** If you try to do the auth code/access token exchange more than once, regardless of method, it will lock your API-account! So if you get the token using curl or whatever do not use this method as well. If your account is not working and you think it might be due to this you will have to contact Fortnox support and have them reset the authorization code for you. If you want to use several access tokens, you need to use a new authorization code for each one of them!

```ruby
# Load the special class from the gem. You need to install the gem first ofc.
require 'fortnox/api/access_token'

puts Fortnox::API::AccessToken.get(
  client_secret: 'P5K5wE3Kun', # Replace with your client secret
  authorization_code: 'ea3862b1-189c-464b-8e25-1b9702365fa1' # Replace with your auth code
)
```

> ​:info: **This will be made into an executable part of the gem for version 1.0

This will output a new token like `3f08d038-f380-4893-94a0a0-8f6e60e67a` that is your access token, **save it!** Set it in the configuration by following the instructions in the next step.

## Configuration
To configure the gem you can use the `configure` block. A `client_secret` and `access_token` are required configurations for the gem to work so at the very minimum you will need something like:

```ruby
Fortnox::API.configure do
  client_secret 'P5K5wE3Kun'
  access_token '3f08d038-f380-4893-94a0a0-8f6e60e67a'
end
```
Before you start using the gem.

### Multiple AccessTokens

Fortnox uses quite low [API rate limits](https://developer.fortnox.se/blog/important-implementation-of-rate-limits/). The limit is for each access token, and according to Fortnox you can use as many tokens as you like to get around this problem. This gem supports handeling multiple access tokens natively. Just set them using the `access_tokens` helper as a list of strings:
```ruby
Fortnox::API.configure do
  client_secret 'P5K5wE3Kun'
  access_tokens 'a78d35hc-j5b1-ga1b-a1h6-h72n74fj5327', 's2b45f67-dh5d-3g5s-2dj5-dku6gn26sh62'
end
```
The gem will then automatically rotate between these tokens. In theory you can declare as many as you like. Remember that you will need to use one authorization code to get each token! See "Getting an AccessToken" above.

### AccessTokens for multiple Fortnox accounts
Yes, we support working with several accounts at once as well. This is when you need to understand the token store that is used internally. All the access tokens are stored in the token store. The store is a hash with arrays of strings, the tokens, as values. In the previous two cases, single and multiple tokens for a single Fortnox account, the tokens are simply stored under the `default` key. Any constructor knows to fall back to that store if no store is specifically given but you can also give the constructors a specific store to use:

```ruby
Fortnox::API.configure do
  client_secret 'P5K5wE3Kun'
  token_store default: ['3f08d038-f380-4893-94a0a0-8f6e60e67a', 'a78d35hc-j5b1-ga1b-a1h6-h72n74fj5327'], another: ['s2b45f67-dh5d-3g5s-2dj5-dku6gn26sh62']
end

Fortnox::API::Repository::Customer.new # Using default
Fortnox::API::Repository::Customer.new( store: :another ) # Using another
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
