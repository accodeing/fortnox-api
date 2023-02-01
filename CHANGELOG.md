# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Script in `bin/get_tokens` to issue access and refresh tokens
- Script in `bin/renew_tokens` (convenience feature for developers)
- `Fortnox::API::Repository::Authentication.renew_token`, used for token renewal

### Changed

- **Breaking** The auth process is rewritten to support
  [the new auth flow](https://developer.fortnox.se/general/authentication/) that
  Fortnox has implemented. The configuration part of the gem is new, have a look
  at the readme.

### Fixed

- Missing runtime dependencies `dry-configurable` and `dry-container` is added.
  Those were indirect dependencies before via other dry libs, but we use them
  explicitly in the gem, so they should be included as real dependencies. Also,
  newer versions of these gems did actually break the gem.

### Removed

- **Breaking** Drops support for Ruby 2.6 since it's reached end of life
- Token rotation is removed since Fortnox counts rate limit on tenant and client
  id. Before, you could get around this by using multiple access tokens. That's
  not possible anymore, so token rotation is simply removed.

## [0.8.0]

### Changed

- `Fortnox::API::CURRENT_HOUSEWORK_TYPES` is now renamed to `HOUSEWORK_TYPES`
  and is instead a Hash with keys for the different categories of types. It also
  includes legacy types, which means `Fortnox::API::LEGACY_HOUSEWORK_TYPES` is
  removed.

### Removed

- Drops support for Ruby < `2.5.0` since they are deprecated

## [0.7.2]

### Fixed

- Invalid validation for Customer's account number attribute

## [0.7.1]

### Fixed

- Invalid validation for Customer's country attributes

## [0.7.0]

### Added

- Adds build test for Ruby `2.6.0`, `2.6.3` and `2.7.0-preview`.

### Removed

- Drops support for Ruby < `2.4.0` since they are deprecated

### Fixed

- Country attribute for `Invoice` and `Order` is now validated correctly.
- Fixes deprecation warnings
- Unlocks pinned `HTTParty` version
- Invalid email validation

## [0.6.3]

### Changed

- Pins `dry-types` to `< 0.13.0` due to breaking changes

### Fixed

- Model attribute `url` is no longer null

[0.8.0]: https://github.com/accodeing/fortnox-api/compare/v0.7.2...v0.8.0
[0.7.2]: https://github.com/accodeing/fortnox-api/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/accodeing/fortnox-api/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/accodeing/fortnox-api/compare/v0.6.3...v0.7.0
[0.6.3]: https://github.com/accodeing/fortnox-api/compare/v0.6.2...v0.6.3
