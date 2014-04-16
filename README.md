# Fortnox::API

Wrapper gem for Fortnox AB's version 3 API.

## Features

Quick overview of the current status of this gem vs the API it integrates
against:

API resource | Status
---------------------
Exchange AuthorizationCode for AccessToken | **DONE**
Customers | **WIP**

## Requirements

This gem is build for Ruby 2.0 or higher. It uses the keywords argument feature.

While porting it to older versions of Ruby is not a prioritie above getting the
wrapper feature complete, it might happen if demand is high.

If you want or need Ruby 1.9 compatability please contact us or better yet,
submit a pull request. Instructions are below.

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

## Usage

### Getting an AccessToken

Unless you have an AccessToken already you will need to exchange your
AuthorizationCode for one to make calls. In a ruby shell do the following

```ruby
require 'fortnox-api' # Load the gem, it needs to be installed first
Fortnox::API.get_access_token(
  base_url: 'https://api.fortnox.se/3',
  client_secret: 'P5K5wE3Kun',
  authorization_code: 'ea3862b1-189c-464b-8e25-1b9702365fa1',
)
```

This will output a new token like `3f08d038-f380-4893-94a0a0-8f6e60e67a` that is
your access token, **save it!** You will need to save it since it will be used
every time you instansiate a Fortnox::API object.

### Using environment variables

You can save your settings in environment variables that will be used by the gem
when you instansiate it. The following variables are recognized:

```
FORTNOX_API_BASE_URL
FORTNOX_API_CLIENT_SECRET
FORTNOX_API_ACCESS_TOKEN
FORTNOX_API_AUTHORIZATION_CODE
```

Their values should match their name. Note that the authorization code is only
ever used once and only when you call the `get_access_token` method described
above.

### Collections

To get something to work with you instansiate a new Fortnox::API object

```ruby
fortnox = Fortnox::API.new(
  base_url: 'https://api.fortnox.se/3',
  client_secret: 'P5K5wE3Kun',
  access_token: '3f08d038-f380-4893-94a0a0-8f6e60e67a',
)
```

On this you can then call things like

```ruby
# Get a list of all the customers (slow, don't use unless you have to)
fortnox.customer.all #=> [<Fortnox::API::Customer:0x007fdf21033ee8>, <Fortnox::API::Customer:0x007fdf22994310>, ... ]

# Get single customer by id
fortnox.customer.find( 5 ) #=> <Fortnox::API::Customer:0x007fdf21100b00>

# Get single customer by customer number
fortnox.customer.find_by( customer_number: 5 ) #=> <Fortnox::API::Customer:0x007fdf22949298>

# Get all customers matching some criterino
fortnox.customer.find_all_by( name: 'test' ) #=> [<Fortnox::API::Customer:0x007fdf22949298>, ... ]
```

### Entities

All the above methods return instances or arrays of instances of some resource
class such as customer, invoice, item, voucher and so on.

Each entity class has it's own methods and properties but they also all respond
to a few common methods, such as for persistance.

```ruby
customer #=> <Fortnox::API::Customer:0x007fdf228db310>
customer.name = "Ned Stark"
customer.save #=> true on success or false on failure
customer.save! #=> true on success or raises Fortnox::API::RequestFailed exception on failure
```

## Contributing

1. Fork it ( http://github.com/my-codeworks/fortnox-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
