# Fortnox::API

Wrapper gem for Fortnox AB's version 3 API.

[![Gem Version](https://badge.fury.io/rb/fortnox-api.png)](http://badge.fury.io/rb/fortnox-api)
[![Build Status](https://travis-ci.org/my-codeworks/fortnox-api.png)](https://travis-ci.org/my-codeworks/fortnox-api)
[![Code Climate](https://codeclimate.com/github/my-codeworks/fortnox-api.png)](https://codeclimate.com/github/my-codeworks/fortnox-api)
[![Dependency Status](https://gemnasium.com/my-codeworks/fortnox-api.svg)](https://gemnasium.com/my-codeworks/fortnox-api)

## Features

Quick overview of the current status of this gem vs the API it integrates
against:

API resource                               | Status
------------------------------------------ | --------
Exchange AuthorizationCode for AccessToken | :white_check_mark:
Entity base class with immutability        | :white_check_mark:
Validator base class based on Vanguard     | :white_check_mark:
Customer::Validator                        | :white_check_mark:
Customers                                  | :hourglass:
Repository READ from API functionality     | :hourglass:

## Requirements

This gem is build for Ruby 2.0 or higher, it's tested agains Ruby 2.1.8, 2.2.4
and 2.3.0. Since it uses the keywords argument feature it won't work on older
versions.

If you want or need Ruby 1.9 compatability please submit a pull request.
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

## Usage

### Getting an AccessToken

Unless you have an AccessToken already you will need to exchange your
AuthorizationCode for one to make calls. In a ruby shell do the following

```ruby
require 'fortnox' # Load the gem, it needs to be installed first
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
when you instantiate it. The following variables are recognized:

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

To get something to work with you instantiate a new Fortnox::API object

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

# Get all customers matching some criteria
fortnox.customer.find_all_by( name: 'test' ) #=> [<Fortnox::API::Customer:0x007fdf22949298>, ... ]
```

### Entities

All the above methods return instances or arrays of instances of some resource
class such as customer, invoice, item, voucher and so on.

Instances are immutable and any update returns a new instance with the
appropriate attributes changed.

> :warning: Ruby implements assignment statements so that `LHS = RHS`
> always returns `RHS`. This is regardless of what an assignment method is
> implemented to return.
>
> This means that assignments like `customer.name = 'Test'` will return
> `'Test'` and not a new instance of `Customer`, which is what you want in this
> case. So assignment methods to update objects is not possible. Use the
> `.update()` method instead.

Each entity class has it's own methods and properties but they also all respond
to a few common methods, such as for persistence.

```ruby
customer #=> <Fortnox::API::Customer:0x007fdf228db310>
customer.name #=> "Nelly Bloom"
customer.update( name: "Ned Stark" ) #=> <Fortnox::API::Customer:0x0193a456ff0307>
customer.name #=> "Nelly Bloom"
updated_customer = customer.update( name: "Ned Stark" )
updated_customer.name #=> "Nelly Bloom"
updated_customer.save #=> true on success or false on failure
updated_customer.save! #=> true on success or raises Fortnox::API::RequestFailed exception on failure
```

## Contributing

1. Fork it ( http://github.com/my-codeworks/fortnox-api/fork )
2. Clone your fork (`git clone https://github.com/<your GitHub user
   name>/fortnox-api.git`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

### Adding upstream remote

If you want to keep contributing, it is a good idea to add the original repo as
remote server to your clone ( `git remote add upstream
https://github.com/my-codeworks/fortnox-api` ). Then you can do something like
this to update your fork:

1. Fetch branches from upstream (`git fetch upstream`)
2. Checkout your master branch (`git checkout master`)
3. Update it (`git rebase upstream/master`)
4. And push it to your fork (`git push origin master`)

If you want to update another branch:
```
git checkout branch-name
git rebase upstream/branch-name
git push origin branch-name
```
