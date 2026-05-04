# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.0.rc1] - 2026-04-29

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
- **Breaking** `Fortnox.request_access_token` replaces
  `Fortnox::API::Repository::Authentication` for token management.
- **Breaking** Configuration moves from `Fortnox::API.configuration` to
  module-level setters such as `Fortnox.access_token=`.
- **Breaking** Country attributes on documents (`country_code`,
  `delivery_country`) now only accept ISO alpha-2 codes (e.g. `'NO'`,
  `'SE'`). The old gem also accepted country names like `'Norge'` or
  `'Norway'`.
- **Breaking** Exception classes are renamed and consolidated. Errors
  raised by the underlying rest-easy framework are translated into
  Fortnox-namespaced exceptions at the gem boundary, so callers do not
  see rest-easy classes. 0.x → 1.0 mapping:
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

### Added

- `Fortnox.request_access_token` for client credentials token requests
- `fortnox-setup` executable for initial OAuth authorization and tenant ID
  discovery
- `fortnox-update-env` executable for refreshing access tokens in env files
- `Fortnox::Struct` base class for nested models, extending `Dry::Struct`
  with a `:read_only` attribute flag for computed/server-side fields
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
