# Migrating to v1.0

Version 1.0 is a complete rewrite. The gem is now built on
[rest-easy](https://github.com/accodeing/rest-easy), replacing the old HTTParty + Data Mapper
architecture.

For the old code and documentation, see the
[v0.9.2 release](https://github.com/accodeing/fortnox-api/tree/v0.9.2).

## Ruby version

The minimum Ruby version is now 3.1.

## Require path

```ruby
# Before
require 'fortnox/api'

# After
require 'fortnox'
```

## Authorization

The gem now uses the Fortnox client credentials flow. Refresh tokens are no
longer supported. A tenant ID is now required — this identifies which Fortnox
company/tenant you are connecting to.

If you don't have a tenant ID yet, run `fortnox-setup` to perform the one-time
OAuth authorization and retrieve it. See the [README](README.md#authorization)
for details.

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

## Environment variables

If you read credentials from environment variables (for example via
`fortnox-update-env` or your own loader), the variable names changed —
the `_API_` infix is gone:

- `FORTNOX_API_CLIENT_ID` → `FORTNOX_CLIENT_ID`
- `FORTNOX_API_CLIENT_SECRET` → `FORTNOX_CLIENT_SECRET`
- `FORTNOX_API_ACCESS_TOKEN` → `FORTNOX_ACCESS_TOKEN`

Removed:

- `FORTNOX_API_REFRESH_TOKEN` — refresh tokens are no longer supported
- `FORTNOX_API_REDIRECT_URI` — passed interactively to `fortnox-setup`
- `FORTNOX_API_SCOPES` — selected interactively in `fortnox-setup`

New:

- `FORTNOX_TENANT_ID` — required for the client credentials flow

## Resources replace repositories

The separate model, type, mapper, and repository classes have been replaced by
a single resource class per entity. The top-level namespace moves from
`Fortnox::API` to `Fortnox`.

```ruby
# Before
repo = Fortnox::API::Repository::Customer.new
repo.all
repo.find(1)
repo.save(customer)

# After
Fortnox::Customer.all
Fortnox::Customer.find(1)
Fortnox::Customer.save(customer)
```

## Return values

`find`, `save`, and `all` now return resource instances instead of model
objects. Attributes are accessed directly on the instance, so existing reads
generally keep working:

```ruby
# Before
invoice = repo.find(1)
invoice.total          # => 100.0
invoice.customer_name  # => 'Acme'

# After
invoice = Fortnox::Invoice.find(1)
invoice.total          # => 100.0
invoice.customer_name  # => 'Acme'
```

Resource instances also have `.meta` (tracks whether the record is new or
saved) and `.unique_id` (the primary key).

`all`, `find(hash)`, `search`, and `only` return a `Fortnox::Collection` of
resource instances. Collection is `Enumerable` and delegates `each`, `first`,
`last`, `size`, `length`, `empty?`, `[]`, and `to_a`, so iteration and most
existing Array usage works unchanged. Each element is a resource, not a
model. Collections also expose pagination metadata:

```ruby
customers = Fortnox::Customer.all
customers.first.name   # => 'Acme'
customers.total        # => 327
customers.pages        # => 7
customers.current_page # => 1
```

Code that explicitly checks `is_a?(Array)` or compares with `==` against an
Array literal needs updating.

## Creating and updating

Use `stub` to create a new unsaved instance. `new` is not used directly.

```ruby
# Before
customer = Fortnox::API::Model::Customer.new(name: 'Acme')
saved = repo.save(customer)

# After
customer = Fortnox::Customer.stub(name: 'Acme')
saved = Fortnox::Customer.save(customer)
```

Updating works the same way — call `update` on a saved instance, then save:

```ruby
updated = saved.update(name: 'Acme Inc')
Fortnox::Customer.save(updated)
```

## Nested models

Nested models like invoice rows are now `Dry::Struct` subclasses under
`Fortnox::Structs`:

```ruby
# Before
row = Fortnox::API::Types::InvoiceRow.new(article_number: '101', price: 10)
invoice = Fortnox::API::Model::Invoice.new(
  customer_number: '1',
  invoice_rows: [row]
)

# After
row = Fortnox::Structs::InvoiceRow.new(article_number: '101', price: 10)
invoice = Fortnox::Invoice.stub(
  customer_number: '1',
  invoice_rows: [row]
)
```

## Stricter attribute validation

Several attributes that 0.x accepted permissively are now validated client-side
to match the Fortnox API specification. Code that was accidentally relying on
the lenient 0.x behavior will raise `Fortnox::ConstraintError` (or
`Fortnox::MissingAttributeError` for required fields) before the request
goes out.

### Country attributes

`country_code` and `delivery_country` on documents only accept ISO alpha-2
codes. The old gem also accepted country names.

```ruby
# Before — accepted codes, Swedish names, and English names
invoice = Fortnox::API::Model::Invoice.new(country: 'Norge')
invoice = Fortnox::API::Model::Invoice.new(country: 'Norway')
invoice = Fortnox::API::Model::Invoice.new(country: 'NO')

# After — only ISO alpha-2 codes
invoice = Fortnox::Invoice.stub(country_code: 'NO')
```

### `Invoice.accounting_method`

Now an enum. Only `''`, `'ACCRUAL'`, and `'CASH'` are accepted; 0.x took any
string.

```ruby
# Before — any string passed client-side
invoice = Fortnox::API::Model::Invoice.new(accounting_method: 'whatever')

# After — only the documented values
invoice = Fortnox::Invoice.stub(accounting_method: 'ACCRUAL')
```

### `Invoice.invoice_type`

Now an enum. Accepted values: `''`, `'INVOICE'`, `'AGREEMENTINVOICE'`,
`'INTRESTINVOICE'`, `'SUMMARYINVOICE'`, `'CASHINVOICE'`.

```ruby
# After
invoice = Fortnox::Invoice.stub(invoice_type: 'INVOICE')
```

### `Unit.description`

Now required. 0.x accepted `nil` client-side, but the Fortnox API rejected
unset descriptions anyway — the new behavior fails earlier.

```ruby
# Before — accepted client-side, rejected by the API
unit = Fortnox::API::Model::Unit.new(code: 'PCS')

# After — must include description
unit = Fortnox::Unit.stub(code: 'PCS', description: 'Pieces')
```

## Nil updates

In 0.x, setting an attribute to `nil` on update silently re-sent the original
value due to a bug in the mapper diff. This is now fixed — setting a field to
`nil` sends `null` to Fortnox and clears the field.

```ruby
invoice = Fortnox::Invoice.find(1)
updated = invoice.update(comments: nil)
Fortnox::Invoice.save(updated)
# comments is now cleared in Fortnox
```

## Exceptions

```ruby
# Before
Fortnox::API::AttributeError
Fortnox::API::RemoteServerError

# After
Fortnox::AttributeError
Fortnox::RequestError
```
