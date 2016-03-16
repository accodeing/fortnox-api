# Fortnox API
 > Wrapper gem for Fortnox AB's version 3 REST(ish) API. If you need to integrate an existing or new Ruby or Rails app against Fortnox this gem will save you a lot of time, you are welcome. Feel free to repay the community with some nice PRs of your own :simple_smile:

# Status
[![Gem Version](https://badge.fury.io/rb/fortnox-api.png)](http://badge.fury.io/rb/fortnox-api)
[![Build Status](https://travis-ci.org/my-codeworks/fortnox-api.png)](https://travis-ci.org/my-codeworks/fortnox-api)
[![Code Climate](https://codeclimate.com/github/my-codeworks/fortnox-api.png)](https://codeclimate.com/github/my-codeworks/fortnox-api)
[![Test Coverage](https://codeclimate.com/github/my-codeworks/fortnox-api/badges/coverage.svg)](https://codeclimate.com/github/my-codeworks/fortnox-api/coverage)
[![Dependency Status](https://gemnasium.com/my-codeworks/fortnox-api.svg)](https://gemnasium.com/my-codeworks/fortnox-api)

The rough status of this project is as follows (as of Marsh 2016):
 * In active development (just check out the commit log)
 * Two developers. At least twice as good as one.
 * Basic structure mostly complete. Things like getting customers and invoices, updating and saving etc.
 * Advanced features around the corner. Things like filtering entities or sorting, pagination of results etc.
 * A few models implemented. Right now it's Customer and Invoice that are the furthest along. Order and Offer will be done quickly once Invoice is completed and adding more models in general is quick and easy, see the developer guid further down.
 * Massive refactorings of the code occurs weakly :) This is not at all stable for production yet.

The goal is to have a production ready version that covers at least the Invoice, Order, Offer, Customer, Account and Bookkeeping models by July or August.

# Architecture overview
The gem is structured with three distinct models for the tasks of data, validation and saving state. These are, as is traditional, called: model, validator and repository.

If you come from a Rails background and have not been exposed to other ways of structuring the solution to the CRUD problem this might seem strange to you since ActiveRecord merges these three roles into the `ActiveRecord::Base` class.

To keep it simple: The active record pattern (as implemented by Rails) is easier to work with if you only have one data source, the database, in your application. The data mapper pattern is easier to work with if you have several data sources, such ass different databases, external APIs and flat files on disk etc, in your application. It's also easier to compose the data mapper components into active record like classes than to separate active records parts to get a data mapper style structure.

If you are interested in a more detailed description of the difference between the two architectures you can read this post that explains it well using simple examples: [What’s the difference between Active Record and Data Mapper?](http://culttt.com/2014/06/18/whats-difference-active-record-data-mapper/)

## Model
The model role classes serve as dumb data objects. They do have some logic to coheres values etc, but they do not contain validation logic nor any business logic at all.

### Attribute
Several of the models share attributes. One example is account, as in a bookkeeping account number. These attributes have the same definition, cohesion and validation logic so it makes sense to extract them from the models and put them in separate classes.

You can find several of these under the `/models/attributes` directory where the implementation of the definition and cohesion lives. For the validation part see Validator below.

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
customer = customer.update( name: 'New Name' ) # => <Fortnox::API::Customer:0x007fdf22949298 ... >
customer.name == "New Name" # => true
```
And note that:
```ruby
customer.name # => "Old Name"
customer.update( name: 'New Name' ) # => <Fortnox::API::Customer:0x007fdf21100b00 ... >
customer.name == "New Name" # => false
```
This is how all the models work, they are all immutable.
## Validator
The validators enforce the constraints on values, lengths and, in some cases, content of the model attributes. You should run the validator on the model before trying to persist it using the repository. You can send any model instance off to the repository and you will get errors back from Fortnox's API server, but using the validator you get a nice list of errors that you can present to the end user instead of pinging the API once for every error and rescuing the exception we throw when we get a 4xx/5xx response from the server.

### Attribute
As the model separates some attributes out into separate classes it makes sense that the validators for these models are similarly composable. The attribute validators can be found in `/validators/attributes` and each match one of the model attributes.

## Repositories
Used to load, update, create and delete model instances. This is what's actually wrapping the HTTP REST API actions.

# Requirements

This gem is build for Ruby 2.0 or higher, it's tested agains Ruby 2.1.8, 2.2.4
and 2.3.0. Since it uses the keywords argument feature it won't work on older
versions.

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

> :warning: **Do not do this more than once!** If you try to do the auth code/access token exchange more than once, regardless of method, it will lock your API-account! So if you get the token using curl or whatever do not use this method as well. If your account is not working and you think it might be due to this you will have to contact Fortnox support and have them reset the authorization code for you.

```ruby
# Load the special class from the gem. You need to install the gem first ofc.
require 'fortnox/api/access_token'

Fortnox::API::AccessToken.new(
  base_url: 'https://api.fortnox.se/3',
  client_secret: 'P5K5wE3Kun', # Replace with your client secret
  authorization_code: 'ea3862b1-189c-464b-8e25-1b9702365fa1', # Replace with your auth code
)
```
This will output a new token like `3f08d038-f380-4893-94a0a0-8f6e60e67a` that is your access token, **save it!** Set it in the environment by following the instructions in the next step.

## Environment variables
The authentication for this gem is stored in the environment. See the documentation for your OS to get instructions for how to set environment variables in it.

You can choose to use the [`dotenv` gem](https://github.com/bkeepers/dotenv) that we include for development but it is NOT recommended to use in production. You should set proper environment variables in production so you don't have to commit the environment file to source control.

The environment variables we use are:
```bash
FORTNOX_API_CLIENT_SECRET
FORTNOX_API_ACCESS_TOKEN
```
Their values should match their name.

# Usage
## Repositories
Repositories are used to load,save and remove entities from the remote server. The calls are subject to network latency and are blocking. Do make sure to rescue appropriate network errors in your code.

```ruby
# Instanciate a repository
repo = Fortnox::API::Repository::Customer.new

# Get a list of all the entities
repo.all #=> <Fortnox::API::Collection:0x007fdf2104575638 @entities: [<Fortnox::API::Customer::Simple:0x007fdf21033ee8>, <Fortnox::API::Customer::Simple:0x007fdf22994310>, ... ]

# Get entity by id
repo.find( 5 ) #=> <Fortnox::API::Customer:0x007fdf21100b00>

# Get entities by attribute
repo.find_by( customer_number: 5 ) #=> <Fortnox::API::Collection:0x007fdf22994310 @entities: [<Fortnox::API::Customer::Simple:0x007fdf22949298>]
```
If you are eagle eyed you might have spotted the different classes for the entities returned in a collection vs the one we get from find. The `Simple` version of a class is used in thouse cases where the API-server doesn't return a full set of attributes for an entity. For customers the simple version has 10 attributes while the full have over 40.

You should try to get by using the simple versions for as long as possible. Both the `Collection` and `Simple` classes have a `.full` method that will give you full versions of the entities. Bare in mind though that a collection of 20 simple models that you run `.full` on will call out to the server 20 times, in sequence.

## Entities
All the repository methods return instances or collections of instances of some resource
class such as customer, invoice, item, voucher and so on.

Instances are immutable and any update returns a new instance with the
appropriate attributes changed (see the Immutable section under Architecture above for more details). To change the properties of a model works like this:

```ruby
customer #=> <Fortnox::API::Customer:0x007fdf228db310>
customer.name #=> "Nelly Bloom"
customer.update( name: "Ned Stark" ) #=> <Fortnox::API::Customer:0x0193a456ff0307>
customer.name #=> "Nelly Bloom"

updated_customer = customer.update( name: "Ned Stark" ) #=> <Fortnox::API::Customer:0x0193a456fe3791>
updated_customer.name #=> "Ned Stark"
```

The update method takes an implicit hash of attributes to update, so you can update as many as you like in one go.
# Contributing
See the [CONTRIBUTE](CONTRIBUTE.md) readme.
