# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Complete rewrite based on [rest-easy](https://gem.coop), replacing the
  HTTParty + Data Mapper architecture with a single resource class per entity
- Minimum Ruby version raised to 3.1
- Authorization now uses the Fortnox client credentials flow, replacing the
  old refresh token flow
- `Fortnox.request_access_token` replaces
  `Fortnox::API::Repository::Authentication` for token management
- Country attributes on documents (`country_code`, `delivery_country`) now
  only accept ISO alpha-2 codes (e.g. `'NO'`, `'SE'`). The old gem also
  accepted country names like `'Norge'` or `'Norway'`.
- Update requests now only send changed fields, matching the old gem's
  behaviour. The full resource is no longer sent on every update.
- Nested structs (EDIInformation, EmailInformation, InvoiceRow, etc.) now use
  `Fortnox::Struct` base class with `attr` DSL and `<=>` for custom key
  mappings

### Added

- `Fortnox.request_access_token` for client credentials token requests
- `fortnox-setup` executable for initial OAuth authorization and tenant ID
  discovery
- `fortnox-update-env` executable for refreshing access tokens in env files
- `Fortnox::Struct` base class for nested models with `attr` DSL, custom key
  mappings via `<=>`, and `:read_only` flag support
- Generic struct parsers (`Parsers::Struct.for`, `Parsers::StructArray.for`)
- Label resource with specs
- VCR JSON body matcher to catch serialisation regressions during cassette
  replay
- Row limit tests for invoice (delivered_quantity and price rounding)

### Removed

- Refresh token support (replaced by client credentials)
- `bin/renew_tokens` script (use `Fortnox.request_access_token` instead)
- Separate model, type, mapper, and repository classes (replaced by single
  resource classes)

For changes prior to the 1.0 rewrite, see the
[0.x changelog](https://github.com/accodeing/fortnox-api/blob/v0.9.2/CHANGELOG.md).
