# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Housework types grouped by tax reduction type.**
  `Fortnox::Types::HOUSEWORK_TYPES_BY_TAX_REDUCTION` maps `'rot'`, `'rut'`
  and `'green'` to the housework types a document of that type may carry,
  with `ROT_HOUSEWORK_TYPES`, `RUT_HOUSEWORK_TYPES`, `GREEN_HOUSEWORK_TYPES`
  and `ANY_TAX_REDUCTION_HOUSEWORK_TYPES` available individually. Fortnox
  enforces the grouping — a document declaring one reduction type is
  rejected outright if it carries a row from another ("Dokument med
  skattereduktionstypen 'rut' får inte innehålla rader med ...") — but the
  gem previously exposed only the flat `CURRENT_HOUSEWORK_TYPES`, leaving
  every consumer to hard-code the split in order to build a UI that cannot
  produce an unsaveable document. `OTHERCOSTS` and `EMPTYHOUSEWORK` mark a
  row as not being housework and appear under every reduction type.

## [1.0.0.rc15] - 2026-08-18

### Fixed

- **Cached resources no longer raise on the first cache hit.** The
  `rest-easy` dependency is now `~> 1.4.1`, which stops `RestEasy::Meta`
  claiming to implement methods it has no value for. Because it claimed
  `marshal_dump`, marshalling a parsed resource silently wrote `nil` where
  the meta state should be, and reading it back raised `NoMethodError:
  undefined method '[]' for nil:NilClass`. Every parsed Fortnox resource
  carries a `meta` — it is where the `partial` flag lives — so any consumer
  caching resources in a store that marshals its entries (Rails'
  `:memory_store` and `:file_store` among them) wrote an unusable entry on
  the first request and raised on every cache hit after that.

  **Upgrading with a warm cache:** entries written before this release are
  not recoverable and now fail with `TypeError: instance of RestEasy::Meta
  needs to have method 'marshal_load'`. Flush the cache or bump its key
  namespace when upgrading. A process-local `:memory_store` clears itself on
  restart and needs nothing.

## [1.0.0.rc14] - 2026-08-11

### Changed

- The `base64` runtime dependency is now bounded to `~> 0.2`, matching what
  `rest-easy` already requires. It was declared open-ended when it was added
  in 1.0.0.rc7, so a future `base64` 1.0 with a breaking change would have
  been resolved into consumers' bundles unannounced.

### Added

- **Breaking** `Fortnox::UnknownAttributeError`, raised when `new`, `stub` or
  `update` is passed an attribute the resource or struct doesn't declare.
  Previously the attribute was silently discarded: the request went out
  without it and Fortnox accepted the result, so a typo cost a field with no
  indication anything was wrong. Worst on nested rows, where
  `stub(order_rows: [{ artcile_number: '1' }])` sent `"OrderRows":[{}]` and
  created an order with empty rows. Subclasses `Fortnox::AttributeError` and
  carries `.attribute_names` (all of them) and `.attribute_name` (the first).
  Consumers passing a wider hash than the resource declares must slice it
  first. Parsing an API response is unaffected and stays tolerant of fields
  the gem doesn't declare — Fortnox adds them over time, and a response must
  not fail to parse because of one.
- Attribute hashes now accept string keys as well as symbols, on `new`,
  `stub`, `update` and struct constructors. Previously a string key matched
  nothing and was dropped, which is how a Rails controller passing `params`
  through produced records missing every field.
- Optional Rails integration, `require 'fortnox/rails'`. Defines `as_json` on
  resources, collections and nested structs so `render json:` works when they
  are nested inside another structure — ActiveSupport walks nested objects
  with `as_json`, and without a definition falls through to `Object#as_json`,
  which serialises instance variables and leaks `api_data`,
  `model_attributes`, `changes` and `meta` into response bodies. The file is
  not loaded with the rest of the gem and ActiveSupport is not a runtime
  dependency; requiring it is opt-in for apps that already have Rails.

### Fixed

- `to_json` on a resource holding nested structs no longer renders them
  through `to_s`. An invoice or order with rows serialised them as
  `"#<Fortnox::Structs::InvoiceRow:0x…>"`. `Fortnox::Struct#to_json` and
  `Fortnox::Collection#to_json` are defined for the same reason — both
  previously fell back to the default `Object#to_json`, producing an
  inspect string rather than JSON. All three render the model representation
  (snake_case attribute names); `to_api` still produces the Fortnox wire
  format. This affects all consumers, not only Rails apps.
- Nested structs (`Fortnox::Structs::*`) now coerce boolean attributes from
  the string spellings params arrive as (`'true'`, `'false'`, `'yes'`,
  `'no'`, `'1'`, `'0'`, `'on'`, `'off'`), matching what resource attributes
  have always accepted. Previously the struct-level type was strict and
  rejected every string, so `Order.stub(order_rows: [{ housework: 'true' }])`
  failed while the equivalent value on a resource attribute coerced cleanly
  — callers passing Rails controller params had to cast booleans by hand
  before building rows. Affects `DocumentRow#housework` and the `InvoiceRow`
  and `OrderRow` subclasses. This asymmetry was introduced in 1.0.0.rc1 and
  did not exist in 0.x.
- Struct construction now raises Fortnox-namespaced errors. A bad value in a
  nested struct — reached directly via `Fortnox::Structs::OrderRow.new` or
  indirectly via `stub`/`update` with a nested hash — previously raised
  `Dry::Struct::Error`, which is a `TypeError` outside the `Fortnox::Error`
  hierarchy, so `rescue Fortnox::AttributeError` blocks didn't catch it. It
  now raises `Fortnox::ConstraintError` carrying `.attribute_name` and
  `.value`, with the same message format as the resource-level error. This
  extends the error translation added in 1.0.0.rc13, which covered resources
  but not structs.

## [1.0.0.rc13] - 2026-08-04

### Changed

- **Breaking** String attributes now normalise `''` to `nil` at the type level. This
  is the mechanism behind the reset fix below: Fortnox silently ignores
  empty strings in update payloads — updating an attribute to `''` kept
  the original value — and a field can only be cleared with an explicit
  `null`. Normalising in the type also changes the read side: unset
  string attributes read as `nil` in the model, never `''`. Fortnox
  spells "unset" as `""` or `null` depending on endpoint and record
  history, so the model value was previously unpredictable. Consumers
  comparing against `''` must switch to `nil` checks (or call `.to_s`
  if they prefer empty strings). On create, an attribute set to `''`
  is now omitted from the POST body entirely (new records strip
  `nil`s), leaving the field to Fortnox's default — previously `""`
  was sent, which Fortnox ignores, with the same end result.
  Enum-typed attributes whose value set
  includes `''` (`payment_way`, `accounting_method`, `invoice_type`,
  `tax_reduction_type`, `delivery_state`) are exempt: there `''` is a
  real Fortnox value, not an unset spelling. For required string attributes
  (`Customer#name`, `Article#description`, `Unit#code`/`#description`,
  `TermsOfPayment#code`) this means updating to `''` now raises
  `Fortnox::MissingAttributeError` before any request is made —
  previously the empty string was sent and silently ignored by Fortnox
  (clearing a required field is invalid: Fortnox rejects `null` for
  them with a 400 and ignores `""`).

### Fixed

- Resetting a string attribute to `''` on update now clears the value in
  Fortnox. Previously the empty string was silently ignored by Fortnox
  and the old value was left intact (reported for `Customer#comments`).
  Since `''` now coerces to `nil` (see above), both `update(attr: '')`
  and `update(attr: nil)` reach Fortnox as `null`, which clears. This
  includes the country attributes on documents (`country_code`,
  `delivery_country`), whose mapper previously turned `nil` back into
  `""` on the wire, so countries could never be cleared at all.
- Numeric attributes no longer raise `Fortnox::ConstraintError` when
  Fortnox returns `""` for an unset value — blank coerces to `nil`,
  extending the 1.0.0.rc10 `Types::AccountNumber` fix to all integer
  and float attributes (e.g. `Customer#invoice_discount`,
  `Invoice#balance`). Like that bug, this was introduced in 1.0.0.rc1
  and did not exist in 0.x, which coerced `""` to `0`/`0.0`.
- `#update`, `#serialise` (and `#to_api`, which goes through it) and
  `.new` now raise Fortnox-namespaced errors. A coercion failure like
  `customer.update(email: 'not-an-email')` previously leaked
  `RestEasy::ConstraintError`, which `rescue Fortnox::ConstraintError`
  blocks don't catch — error translation only covered `save`, `parse`,
  `find`, `stub` and the other class-level paths.

## [1.0.0.rc12] - 2026-06-26

### Fixed

- `Fortnox::Customer` no longer sends `OrganisationNumber` when updating a
  customer that has an active e-fakturakoppling
  (`default_delivery_types.invoice == ELECTRONICINVOICE`). Fortnox rejects edits
  to the org/personal number for such customers, and field-level dirty tracking
  meant an unchanged `OrganisationNumber` was always included on update,
  blocking every other update to those customers.

## [1.0.0.rc11] - 2026-06-26

### Changed

- Upgraded `rest-easy` dependency to `~> 1.4.0`. `Fortnox::MissingAttributeError`
  is now raised at save time when a `:required` attribute is missing on the
  outgoing payload, before any HTTP request reaches Fortnox. `stub` /
  `init_from_model` stay permissive so callers can build an instance and
  fill required attributes incrementally. Restores the 0.x behaviour that
  rc1's rewrite to rest-easy dropped: missing required attributes were
  previously only caught when parsing API responses, letting outbound
  writes reach Fortnox and surface as generic `RequestError`.

## [1.0.0.rc10] - 2026-05-27

### Changed

- Upgraded `rest-easy` dependency to `~> 1.3.1`.

### Fixed

- `Types::AccountNumber` no longer raises `Fortnox::ConstraintError` when
  Fortnox returns `""` for an unset attribute using that type. Observed in production on
  `Customer#sales_account`. Blank strings now coerce to `nil`.
  This bug was introduced in 1.0.0.rc1 and did not exist in 0.x.

## [1.0.0.rc9] - 2026-05-20

### Added

- `Fortnox::ALLOWED_CHARACTERS_REGEXP` constant, exposing the character
  set Fortnox accepts in text fields. Sourced from the official Fortnox
  docs. Useful for pre-validating strings before sending them to the API.

### Changed

- `Customer#default_delivery_types.invoice` now accepts `'ELECTRONICINVOICE'`
  when returned by Fortnox. The value is read-only — attempting to set it from
  consumer code raises `Fortnox::ConstraintError` at save time,
  rather than letting Fortnox reject the request.
  Unchanged values round-trip through `save` as before.

## [1.0.0.rc8] - 2026-05-19

### Changed

- `fortnox-setup` now prints the authorization URL and asks before
  opening a browser when a non-localhost redirect URI is used, defaulting
  to not opening it. Previously it always opened the URL locally, so the
  browser immediately followed the redirect and the URL was lost — making
  it impossible to hand off to whoever should log in (e.g. a customer).
  The local-server flow is unchanged.

## [1.0.0.rc7] - 2026-05-19

### Changed

- **Breaking** Minimum Ruby version raised to 3.2. Ruby 3.1 reached
  end-of-life in March 2025 and is no longer supported or tested.
- Upgraded `rest-easy` dependency to `~> 1.3.0`.

### Fixed

- Declare `base64` as a runtime dependency. It is `require`d by the gem
  and used for OAuth credential encoding, but `base64` was removed from
  Ruby's default gems in 3.4, so the gem failed to load on Ruby 3.4 with
  `LoadError: cannot load such file -- base64`.
- Saving a persisted record with no changes is again a no-op, matching
  0.9. In that version `save` returned early for an unchanged persisted record
  without issuing a request. The 1.0.0.rc1 rest-easy rewrite regressed
  this: `save` on a record fetched via `find` re-sent every attribute
  via a full-record `PUT`, which could clobber fields changed elsewhere
  since it was loaded.

## [1.0.0.rc6] - 2026-05-18

### Added

- HTTP wire logging via `Fortnox.configure { logger ... }`, with an
  optional `log_bodies` toggle for request/response bodies. Standard
  auth headers are redacted automatically. Inherited from `rest-easy`
  1.2.

### Changed

- Upgraded `rest-easy` dependency to `~> 1.2.0`.

## [1.0.0.rc5] - 2026-05-15

### Changed

- Upgraded `rest-easy` dependency to `~> 1.1.2`.

## [1.0.0.rc4] - 2026-05-15

### Changed

- Upgraded `rest-easy` dependency to `~> 1.1.1`. This drops the runtime
  dependency on `dry-inflector`, which was never used.

## [1.0.0.rc3] - 2026-05-08

### Changed

- `Fortnox::RequestError#message` now includes the API's
  `ErrorInformation.Message` and code from the response body when present,
  normalising Fortnox's inconsistent key casing (PascalCase vs lowercase)
  across endpoints. Previously the message was only `"Request failed: <status>"`,
  hiding the cause from logs and uncaught backtraces.
- `Article#commodity_code`, `Customer#phone`, `Invoice#accounting_method`,
  `Invoice#invoice_period_reference`, `Invoice#invoice_reference`,
  `Document#time_basis_reference`, `Document#total_to_pay`, and
  `Document#warehouse_ready` are now flagged read-only to match the Fortnox
  API. Values set on these attributes are silently excluded from save
  requests; previously they were sent and rejected by the API.

### Fixed

- `Order` and `Invoice` rows now serialise the VAT field as `VAT` instead of
  `Vat`. Saving rows with a `vat` value previously failed with Fortnox
  rejecting the request as `"Felaktigt fältnamn"`. This bug was introduced in the 1.0.0.rc1,
  it did not exist in 0.x.

## [1.0.0.rc2] - 2026-05-05

### Added

- Per-resource OAuth scope declarations via the `scope` setting in
  `Fortnox::Resource`, plus `Fortnox.scopes` returning a
  `{ scope_string => [resource_classes] }` mapping derived from the
  registered resources.

### Changed

- `fortnox-setup` lists the OAuth scopes covered by the gem's resources
  and accepts a space-separated selection or `all`, replacing the
  prescriptive default that didn't reflect the actual resource set. Other
  Fortnox scopes (`salary`, `bookkeeping`, etc.) can still be entered
  manually.
- `TermsOfPayment.code` now has a 25-character limit, matching Fortnox
  API documentation.
- `Unit.code` now has a 20-character limit, matching Fortnox API
  documentation.
- `Unit.description` is now `Sized::String[100]` and required, matching
  Fortnox API documentation. In 0.x and rc1 this was nullable client-side,
  but the Fortnox API rejected unset descriptions anyway.

### Fixed

- `TermsOfPayment.code` is required again, matching Fortnox API
  documentation. The rest-easy rewrite for rc1 briefly lost the required
  flag.
- `Unit.code` is required again, matching Fortnox API documentation. The
  rest-easy rewrite for rc1 briefly lost the required flag.

## [1.0.0.rc1] - 2026-05-04

Version 1.0 is a complete rewrite of the gem and is **not** a drop-in
replacement for the 0.x series. Almost every public entry point has changed.
See [MIGRATING_TO_1.0.md](MIGRATING_TO_1.0.md) for a guided upgrade and the sections below
for the full list of breaking changes.

### Changed

- **Breaking** Complete rewrite based on [rest-easy](https://github.com/accodeing/rest-easy),
  replacing the HTTParty + Data Mapper architecture with a single resource
  class per entity. The top-level namespace moves from `Fortnox::API` to
  `Fortnox` (e.g. `Fortnox::API::Repository::Customer` →
  `Fortnox::Customer`).
- **Breaking** Minimum Ruby version raised to 3.1.
- **Breaking** Authorization now uses the new Fortnox client credentials flow.
  Refresh tokens are no longer needed, nor supported. A tenant ID is now required;
  obtain one with the new `fortnox-setup` executable.
- **Breaking** Environment variables lose the `_API_` infix:
  `FORTNOX_API_CLIENT_ID` → `FORTNOX_CLIENT_ID`, `FORTNOX_API_CLIENT_SECRET`
  → `FORTNOX_CLIENT_SECRET`, `FORTNOX_API_ACCESS_TOKEN` →
  `FORTNOX_ACCESS_TOKEN`. `FORTNOX_API_REFRESH_TOKEN`,
  `FORTNOX_API_REDIRECT_URI`, and `FORTNOX_API_SCOPES` are removed —
  refresh tokens are no longer supported, and the redirect URI and scopes
  are now selected interactively in `fortnox-setup`. The new
  `FORTNOX_TENANT_ID` is required for the client credentials flow.
- **Breaking** `Fortnox.request_access_token` replaces
  `Fortnox::API::Repository::Authentication` for token management.
- **Breaking** Configuration moves from `Fortnox::API.configuration` to
  module-level setters such as `Fortnox.access_token=`.
- **Breaking** Country attributes on documents (`country_code`,
  `delivery_country`) now only accept ISO alpha-2 codes (e.g. `'NO'`,
  `'SE'`). The old gem also accepted country names like `'Norge'` or
  `'Norway'`.
- **Breaking** Exception classes are renamed and consolidated.
  0.x → 1.0 mapping:
  - `Fortnox::API::Exception` → `Fortnox::Error`. Still the base class
    for everything below; rescue it to catch any gem-raised error.
  - `Fortnox::API::AttributeError` → `Fortnox::AttributeError`.
  - `Fortnox::API::RemoteServerError` → `Fortnox::RequestError`, now
    carries the response object as `.response`.
  - `Fortnox::API::MissingAttributeError` → `Fortnox::MissingAttributeError`,
    now carries `.attribute_name`.
  - `Fortnox::API::MissingAccessToken` → `Fortnox::MissingAccessToken`.
    In 0.x this was raised eagerly when constructing a repository; in 1.0
    it is raised lazily, on the first API call from a thread that has not
    set a token.
  - `Fortnox::API::MissingConfiguration` is removed — the configurable
    surface is much smaller in 1.0 and the previous misconfigurations
    are no longer expressible.
  - *new* `Fortnox::ConstraintError < Fortnox::AttributeError` — raised
    when an attribute value violates a type constraint. Carries
    `.attribute_name` and `.value`.
- Nested structs (EDIInformation, EmailInformation, InvoiceRow, etc.) are
  now plain `Dry::Struct` subclasses; key-mapping and serialisation logic
  lives in dedicated classes under `Fortnox::Mappers`.
- **Breaking** Collection-returning methods (`.all`, `.search`, `.only`,
  and `.find(hash)`) now return a `Fortnox::Collection` instead of a plain
  `Array`. Collection is `Enumerable` and delegates `each`, `first`, `last`,
  `size`, `length`, `empty?`, `[]`, and `to_a`, so most existing Array
  usage works unchanged. Code that explicitly checks `is_a?(Array)` or
  compares with `==` against an Array literal needs updating.
- **Breaking** `Invoice.accounting_method` is now an enum accepting only
  `''`, `'ACCRUAL'`, or `'CASH'`. In 0.x this was a free-form
  `Nullable::String` so any value passed client-side.
- **Breaking** `Invoice.invoice_type` is now an enum accepting only `''`,
  `'INVOICE'`, `'AGREEMENTINVOICE'`, `'INTRESTINVOICE'`, `'SUMMARYINVOICE'`,
  or `'CASHINVOICE'`. In 0.x this was a free-form `Nullable::String`.
- `your_order_number` on Invoice and Order (inherited from Document) max
  length raised from 30 to 75 characters to match the current Fortnox API.
- Article dimension fields (`depth`, `height`, `weight`, `width`) max raised
  from 99,999,999 to 999,999,999 to match the documented Fortnox range.

### Added

- `Fortnox.request_access_token` for client credentials token requests
- `fortnox-setup` executable for initial OAuth authorization and tenant ID
  discovery
- `fortnox-update-env` executable for refreshing access tokens in env files
- `Fortnox::Struct` base class for nested models, extending `Dry::Struct`
  with a `:read_only` attribute flag for computed/server-side fields
- `Fortnox::Collection` class wrapping the result of multi-record API calls
  and exposing pagination metadata via `.total`, `.pages`, and `.current_page`
- `instance.meta.partial?` flag — true for instances parsed from a
  collection response (which Fortnox returns with fewer attributes than
  single-resource fetches), false for instances from `find(id)`
- Label resource

### Fixed

- Setting an attribute to `nil` on update now correctly sends `null` to
  Fortnox, clearing the field. In 0.x this silently re-sent the original
  value due to a bug in the mapper diff. (#172)
- Read-only attributes like `total`, `balance`, and `booked` now load
  correctly from Fortnox API responses. In 0.x these returned `nil` due
  to missing writers for private attributes. (#50)
- API base URL updated from `apps.fortnox.se/3` to `api.fortnox.se/3`,
  avoiding the redirect introduced by Fortnox in February 2026. (#249)
- All current housework types are now supported, including types added
  after the 0.x release. (#196)
- The `Currencies` enum no longer accepts `KUR`. It is not an ISO-4217
  currency code and the Fortnox API would have rejected it; 0.x accepted
  it client-side.

For changes prior to the 1.0 rewrite, see the
[0.x changelog](https://github.com/accodeing/fortnox-api/blob/v0.9.2/CHANGELOG.md).

[Unreleased]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc15...HEAD
[1.0.0.rc15]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc14...v1.0.0.rc15
[1.0.0.rc14]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc13...v1.0.0.rc14
[1.0.0.rc13]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc12...v1.0.0.rc13
[1.0.0.rc12]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc11...v1.0.0.rc12
[1.0.0.rc11]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc10...v1.0.0.rc11
[1.0.0.rc10]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc9...v1.0.0.rc10
[1.0.0.rc9]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc8...v1.0.0.rc9
[1.0.0.rc8]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc7...v1.0.0.rc8
[1.0.0.rc7]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc6...v1.0.0.rc7
[1.0.0.rc6]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc5...v1.0.0.rc6
[1.0.0.rc5]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc4...v1.0.0.rc5
[1.0.0.rc4]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc3...v1.0.0.rc4
[1.0.0.rc3]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc2...v1.0.0.rc3
[1.0.0.rc2]: https://github.com/accodeing/fortnox-api/compare/v1.0.0.rc1...v1.0.0.rc2
[1.0.0.rc1]: https://github.com/accodeing/fortnox-api/releases/tag/v1.0.0.rc1
