# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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

[0.7.2]: https://github.com/accodeing/fortnox-api/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/accodeing/fortnox-api/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/accodeing/fortnox-api/compare/v0.6.3...v0.7.0
[0.6.3]: https://github.com/accodeing/fortnox-api/compare/v0.6.2...v0.6.3
