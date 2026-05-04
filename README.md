# fortnox-api

Ruby gem for Fortnox's version 3 REST API, built on
[rest-easy](https://github.com/accodeing/rest-easy). If you need to integrate an existing or new Ruby
or Rails app against Fortnox this gem will save you a lot of time.

Feel free to repay the community with some nice PRs of your own.

## Supported resources

Article, Customer, Invoice, Label, Order, Project, TermsOfPayment, Unit

Adding more resources is quick and easy, see the
[Contributing](#contributing) section.

## Status

Version 1.0 is a complete rewrite, currently in release candidate
(`1.0.0.rc1`). It is built on
[rest-easy](https://github.com/accodeing/rest-easy), replacing the old
HTTParty + Data Mapper architecture with a single resource class per entity.
Authorization uses the Fortnox client credentials flow.

## Migrating from 0.x

See the [Migration guide](MIGRATING_TO_1.0.md).

## Architecture overview

The gem uses the [rest-easy](https://github.com/accodeing/rest-easy) framework to map between Ruby
objects and the Fortnox JSON API. Each resource is a class that declares its
attributes with types and constraints. rest-easy handles the HTTP requests,
JSON serialisation, and attribute convention mapping (PascalCase in the API,
snake_case in Ruby).

### Immutability

The model instances are immutable. That means:

```ruby
customer.model.name # => "Old Name"
customer.model.name = 'New Name' # => NoMethodError
```

Any operation that updates state returns a new instance with the updated
attributes while leaving the old instance alone:

```ruby
customer.model.name # => "Old Name"
updated_customer = customer.update(name: 'New Name')
updated_customer.model.name # => "New Name"
customer.model.name # => "Old Name"
```

This is how all resources work, they are all immutable.

### Types

Types automatically enforce constraints on values, lengths and, in some cases,
content of the resource attributes. Types force your data to be correct before
sending it to the API, which saves you API calls and time debugging. You can
still get errors from the server; our implementation is not perfect. Also,
Fortnox sometimes requires a specific combination of attributes.

#### Exceptions

The gem raises the following exceptions:

- `Fortnox::Error` — base class for everything below. Rescue this to catch
  any error raised by the gem.
- `Fortnox::RequestError` — 4xx/5xx responses from the Fortnox API. Carries
  the response object as `.response`.
- `Fortnox::AttributeError` — base for attribute validation failures.
  - `Fortnox::ConstraintError` — an attribute value violates a type
    constraint (max size, format, etc.). Carries `.attribute_name` and
    `.value`.
  - `Fortnox::MissingAttributeError` — a required attribute is missing
    from an API response. Carries `.attribute_name`.
- `Fortnox::MissingAccessToken` — `Fortnox.access_token=` was not called
  on the current thread before an API call.

## Requirements

Ruby 3.1 or higher.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'fortnox-api'
```

And then execute:

```shell
bundle install
```

## Authorization

Fortnox uses OAuth2 for authorization. This gem supports the **client
credentials** flow, which is the recommended way to authenticate server-to-server
integrations. The older refresh token flow is no longer supported. Read more
about this change in the
[Fortnox blog post](https://www.fortnox.se/developer/blog/say-goodbye-to-refresh-tokens-).

With client credentials you can request a new access token at any time using
three pieces of information: your **client ID**, **client secret**, and the
**tenant ID** of the Fortnox account you are integrating with.

### Prerequisites

You need:

- A Fortnox developer account
  ([register here](https://developer.fortnox.se/getting-started/))
- A Fortnox app in the developer portal with:
  - Service account setting enabled
  - Correct scopes configured
  - A redirect URL
- A Fortnox test environment for testing your integration

Read the
[Fortnox getting started guide](https://developer.fortnox.se/getting-started/)
and
[authorization documentation](https://www.fortnox.se/developer/authorization/get-access-token-using-client-credentials)
for more details.

### Initial setup

Before you can use client credentials you need to perform a one-time
authorization code exchange. This grants your app access to a specific Fortnox
account and gives you the **tenant ID** you need for all future token requests.

This gem includes an executable to help with this:

```shell
fortnox-setup
```

The script will:

1. Ask for your client ID, client secret, and scopes
2. Offer to use a local server on `http://localhost:4242` to catch the
   authorization response automatically. If you choose this, set your Fortnox
   app's redirect URL to `http://localhost:4242`. Otherwise, enter your existing
   redirect URL and paste the authorization code manually.
3. Open your browser to the Fortnox authorization page
4. You log in to Fortnox and grant your app access
5. The script exchanges the authorization code for an access token and extracts
   the tenant ID from the JWT
6. The tenant ID is printed for you to store in your application's configuration

After this you have a tenant ID and never need to run this script again (unless
you need to authorize against a different Fortnox account).

### Requesting access tokens

Once you have a tenant ID, you can request access tokens programmatically.
Access tokens expire after 1 hour, but you can request a new one at any time:

```ruby
require 'fortnox'

token = Fortnox.request_access_token(
  client_id: 'your-client-id',
  client_secret: 'your-client-secret',
  tenant_id: 'your-tenant-id'
)

Fortnox.access_token = token
```

It is up to you to manage the token lifecycle in your application. A common
approach is to request a new token before each batch of API calls, or to cache
the token and refresh it when it expires.

### Updating access tokens in env files

For development and testing, the gem includes an executable that reads your
credentials from an env file, requests a new access token, and writes it back:

```shell
fortnox-update-env              # reads/writes .env
fortnox-update-env .env.local   # reads/writes a specific file
```

See [.env.test.local.template](.env.test.local.template) for the required
variables.

### Multiple Fortnox accounts

The access token is stored per thread, so concurrent threads — Sidekiq
workers, Puma threads, etc. — can use different tokens without leaking to
each other. Each thread must set its own token before making API calls.

Within a single thread you can switch tokens between calls. Each call uses
the token currently set on the calling thread:

```ruby
Fortnox.access_token = 'account1_token'
Fortnox::Customer.all

Fortnox.access_token = 'account2_token'
Fortnox::Customer.all
```

## Usage

Set the access token before making any API calls:

```ruby
require 'fortnox'

Fortnox.access_token = 'your-access-token'
```

### Listing all records

```ruby
Fortnox::Customer.all
```

`.all`, `.search`, `.only`, and `.find(hash)` return a `Fortnox::Collection`
— an iterable wrapper that also exposes the pagination metadata Fortnox
returns alongside collection responses:

```ruby
customers = Fortnox::Customer.all
customers.first.model.name # => "Acme Corp"
customers.size             # => 50
customers.total            # => 327
customers.pages            # => 7
customers.current_page     # => 1
```

`Collection` is `Enumerable`, so `.each`, `.map`, `.select`, `.first`, etc.
all work as expected.

Fortnox's collection endpoints return fewer attributes per record than
single-resource endpoints, so instances from a `Collection` are flagged as
partial. Check `instance.meta.partial?` and re-fetch via `find(id)` if you
need the full record:

```ruby
customers = Fortnox::Customer.all
customers.first.meta.partial?            # => true
Fortnox::Customer.find(1).meta.partial?  # => false
```

### Finding a record

```ruby
# By ID
customer = Fortnox::Customer.find(1)

# By query parameters (pagination, limits, etc.)
customers = Fortnox::Customer.find(limit: 10, offset: 0)
```

Note that `find` supports a hash as an argument, which adds the given keys as
HTTP parameters to the call. This lets you use limits, offsets, and pagination.
See the
[Fortnox documentation](https://developer.fortnox.se/general/parameters/)
for available parameters.

The returned object wraps the model. Access attributes through `.model`:

```ruby
customer = Fortnox::Customer.find(1)
customer.model.name       # => "Acme Corp"
customer.model.city       # => "Stockholm"
customer.unique_id        # => "1"
```

### Creating a record

Use `.stub` to build a new instance and `.save` to persist it:

```ruby
customer = Fortnox::Customer.stub(name: 'Acme Corp', city: 'Stockholm')
result = Fortnox::Customer.save(customer)
result.model.customer_number # => "1"
```

### Updating a record

Fetch, update, and save. Models are immutable, so `.update` returns a new
instance:

```ruby
customer = Fortnox::Customer.find(1)
updated = customer.update(name: 'Acme Inc')
Fortnox::Customer.save(updated)
```

### Searching

```ruby
Fortnox::Customer.search(name: 'Acme')
```

### Filtering

Some resources support server-side filters:

```ruby
Fortnox::Invoice.only('unpaid')
```

### Gotchas

See [docs/gotchas.md](docs/gotchas.md) for known quirks and edge cases in the
Fortnox API.

### Resources

Each resource maps to a Fortnox API endpoint. Attributes are typed and
validated before sending data to the API. Read-only attributes (like `url`)
cannot be set when creating or updating records.

Resources that share structure inherit from a common base. For example,
`Invoice` and `Order` both extend `Document`, which defines shared attributes
like administration fee, delivery address, and row items.

## Changelog

See the [Changelog](CHANGELOG.md).

## Development

See the [Developer readme](DEVELOPER_README.md).

## Contributing

See the [Contribute readme](CONTRIBUTE.md).

## License

[LGPL-3.0](LICENSE.md). Copyright (c) 2015-2026 Accodeing to you KB.
