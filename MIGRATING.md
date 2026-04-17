# Migrating to v1.0

Version 1.0 is a complete rewrite. The gem is now built on
[rest-easy](https://gem.coop), replacing the old HTTParty + Data Mapper
architecture.

For the old code and documentation, see the
[v0.9.2 release](https://github.com/accodeing/fortnox-api/tree/v0.9.2).

## Gem name

The gem has been renamed from `fortnox-api` to `rest-easy-fortnox`.

```ruby
# Before
gem 'fortnox-api'

# After
gem 'rest-easy-fortnox'
```

## Ruby version

The minimum Ruby version is now 3.1 (was 2.7).

## Resources replace repositories

The separate model, type, mapper, and repository classes have been replaced by
a single resource class per entity.

```ruby
# Before
require 'fortnox/api'
repo = Fortnox::API::Repository::Customer.new
repo.all
repo.find(1)
repo.save(customer)

# After
require 'fortnox'
Fortnox::Customer.all
Fortnox::Customer.find(1)
Fortnox::Customer.save(customer)
```

## Creating and updating models

```ruby
# Before
customer = Fortnox::API::Model::Customer.new(name: 'Acme')
updated = customer.update(name: 'Acme Inc')

# After
customer = Fortnox::Customer.stub(name: 'Acme')
updated = customer.update(name: 'Acme Inc')
```

## Authorization

The gem now uses the Fortnox client credentials flow. Refresh tokens are no
longer supported.

```ruby
# Before
tokens = Fortnox::API::Repository::Authentication.new.renew_tokens(
  refresh_token: 'your-refresh-token',
  client_id: 'your-client-id',
  client_secret: 'your-client-secret'
)
Fortnox::API.access_token = tokens[:access_token]

# After
token = Fortnox.request_access_token(
  client_id: 'your-client-id',
  client_secret: 'your-client-secret',
  tenant_id: 'your-tenant-id'
)
Fortnox.access_token = token
```

If you don't have a tenant ID yet, run `fortnox-setup` to perform the one-time
authorization and retrieve it. See the [README](README.md#authorization) for
details.

## Exceptions

```ruby
# Before
Fortnox::API::AttributeError
Fortnox::API::RemoteServerError

# After
Fortnox::AttributeError
Fortnox::RequestError
```
