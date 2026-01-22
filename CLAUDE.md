# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ruby gem wrapping Fortnox AB's version 3 REST API. Uses the data mapper pattern (not ActiveRecord) with separate concerns for models, types, mappers, and repositories.

## Common Commands

```bash
# Run all tests
bundle exec rspec

# Run a single test file
bundle exec rspec spec/fortnox/api/repositories/customer_spec.rb

# Run tests matching a pattern
bundle exec rspec --example "Customer"

# Run linter
bundle exec rubocop

# Run linter with auto-fix
bundle exec rubocop -a

# List rake tasks
rake -T

# Remove all VCR cassettes (for re-recording)
rake throw_vcr_cassettes

# Seed test Fortnox instance with required data
rake seed_fortnox_test_instance

# Get new OAuth tokens (requires credentials in .env)
bin/get_tokens
```

## Architecture

### Data Mapper Pattern

Unlike Rails' ActiveRecord, this gem separates concerns:

- **Models** (`lib/fortnox/api/models/`): Immutable data objects. Use `model.update(attr: value)` to get a new instance with changed attributes.
- **Types** (`lib/fortnox/api/types/`): Enforce constraints on attribute values, lengths, and content.
- **Mappers** (`lib/fortnox/api/mappers/`): Convert between Ruby objects and Fortnox JSON. Used internally by repositories.
- **Repositories** (`lib/fortnox/api/repositories/`): Handle HTTP requests. Methods: `all`, `find(id)`, `find_by(attr: value)`, `save`.

### Key Classes

- `Fortnox::API` - Main module with configuration and thread-local access token
- `Fortnox::API::Repository::Authentication` - Token renewal via `renew_tokens`
- Available models: Article, Customer, Invoice, Label, Order, Project, TermsOfPayment, Unit

### Exception Hierarchy

- `Fortnox::API::AttributeError` - Invalid attribute value
- `Fortnox::API::MissingAttributeError` - Required attribute missing
- `Fortnox::API::RemoteServerError` - Server-side error from Fortnox

## Testing

- Uses VCR to record API responses as cassettes in `spec/vcr_cassettes/`
- When re-recording cassettes, do one repository at a time to avoid 429 rate limits
- Environment variables for testing go in `.env.test` (see `.env.template`)
- Set `DEBUG=true` for debug output during tests
- Set `REFRESH_TOKENS=true` to enable token refresh during testing

## Fortnox API Gotchas

See `docs/gotchas.md` for detailed API quirks including:
- `SalesAccount` default values may reference non-existent accounts
- Legacy `HouseWorkType` values that can't be used for new orders/invoices
- `VATIncluded` affects all price fields (no VAT-inclusive fields when false)
- `TermsOfPayments.code` is case-sensitive (`30DAYS` not `30days`)
- Row descriptions limited to 255 characters (undocumented)
- Only one active refresh token per Fortnox account per integration
