# Developer readme

## Setup

```shell
bundle install
```

### Getting a Fortnox access token

To run tests against a real Fortnox account you need an access token. First,
get your tenant ID by running the setup script from within the gem directory:

```shell
bundle exec ruby bin/fortnox-setup
```

Then create `.env.test.local` from the template and fill in your credentials:

```shell
cp .env.test.local.template .env.test.local
```

Use `fortnox-update-env` to request a fresh access token. See the
[README](README.md#updating-access-tokens-in-env-files) for details.

## Testing

This gem has integration tests to verify the code against the real API. It uses
[VCR](https://github.com/vcr/vcr) to record API endpoint responses. These
responses are stored locally and are called VCR cassettes. If no cassettes are
available, VCR will record new ones for you.

Once in a while, it's good to throw away all cassettes and re-record them.
Fortnox updates their endpoints and we need to keep our code up to date with
reality. There's a handy rake task for removing all cassettes, see `rake -T`.

Note that when re-recording cassettes, do it one resource at a time, otherwise
you'll get `429 Too Many Requests` from Fortnox. Run them manually with
something like `bundle exec rspec spec/fortnox/resources/article_spec.rb`.

### Running tests

```shell
bundle exec rake
```

### Continuous integration

GitHub Actions (`.github/workflows/ci.yml`) runs RuboCop and the full
RSpec suite (Ruby 3.1–3.4) on every pull request and on pushes to
`development` and `rest-easy`. The suite runs entirely offline against
the committed VCR cassettes and the dummy values in `.env.test`, so CI
needs no Fortnox credentials.

### Test environment variables

`.env.test` includes environment variables used for testing with dummy values.
If you want to run tests against a real (or test) Fortnox account you need to
provide a valid access token in `.env.test.local`. This file is gitignored and
takes precedence over `.env.test`.

```shell
# .env.test.local
FORTNOX_ACCESS_TOKEN=your-real-access-token
```

### Re-recording VCR cassettes

```shell
bundle exec rake throw_vcr_cassettes
bundle exec rspec spec/fortnox/resources/article_spec.rb
```

### Seeding test data

There's a Rake task for seeding the test Fortnox instance with data that the
test suite needs:

```shell
bundle exec rake seed_fortnox_test_instance
```

## Updating Ruby version

When updating the required Ruby version:

- Bump Ruby version in `fortnox.gemspec`
- Update gems if needed
- Verify that the test suite is passing
- Bump `TargetRubyVersion` in `.rubocop.yml` (should be the lowest version we
  support)
- Update `.tool-versions` to the newest version we support
- Update required Ruby version in the README

## Schema-drift warnings

rest-easy can warn whenever an API response contains fields a resource
doesn't declare with `attr` or `ignore`, or is missing a declared
(non-required) attribute. This is useful when Fortnox adds or renames
fields and we need to update the resource. Enable per resource:

```ruby
Fortnox::Customer.configure do
  debug true
end
```

This is a maintainer-facing knob — consumers can't act on the warnings
without patching the resource class. If a user reports an issue that
looks like drift, enable it locally, reproduce, and use the output to
update the resource's `attr` declarations.

## Adding a new resource

Resources live under `lib/fortnox/resources/`. A new resource typically
needs:

1. A resource class extending `Fortnox::Resource` (or a shared base like
   `Fortnox::Document` for invoice-shaped entities), declaring the
   Fortnox endpoint, attributes with types, and any OAuth scopes.
2. Any new shared structs under `lib/fortnox/structs/`.
3. An integration spec under `spec/fortnox/resources/` with VCR
   cassettes (see "Re-recording VCR cassettes").
4. A mention in the README's "Supported resources" list.
5. A CHANGELOG entry.

Look at an existing resource (e.g. `Fortnox::Customer`) as a reference
when adding a new one.

## Updating the rest-easy dependency

The gem is built on [rest-easy](https://github.com/accodeing/rest-easy).
When bumping:

1. Update the version constraint in `fortnox.gemspec`.
2. Run `bundle update rest-easy`.
3. Run the full test suite. VCR matches on the request body,
   so a change to the serialised request shape surfaces automatically as a
   cassette-match failure — re-record only once you've confirmed the new
   shape is the intended one. Response-parsing changes instead show up as
   assertion failures (re-recording won't address those).
4. If the bump exposes new rest-easy configuration to consumers (as the
   1.2 bump did with HTTP wire logging), document it in the README and
   add a CHANGELOG entry.

## Branching model

- `development` is the default branch — PRs target it (see
  [CONTRIBUTE.md](CONTRIBUTE.md)).
- Releases are tagged `v<VERSION>` (e.g. `v1.0.0.rc6`).
- Long-lived feature branches like `rest-easy` exist for large rewrites
  and get merged back into `development` when ready.

## Release process

1. Update `CHANGELOG.md` — move unreleased entries under a new
   `## [<VERSION>] - <YYYY-MM-DD>` heading.
2. Bump `Fortnox::VERSION` in `lib/fortnox/version.rb`.
3. Commit with a `Release <VERSION>` message.
4. Tag the commit: `git tag v<VERSION>`.
5. Build and push:
   ```shell
   gem build fortnox.gemspec
   gem push fortnox-api-<VERSION>.gem
   ```
6. Push the commit and tag: `git push && git push --tags`.

Built `.gem` files are gitignored and should not be committed.

## Maintainer notes on `bin/`

`fortnox-setup` and `fortnox-update-env` are shipped as consumer-facing
executables (see the [README](README.md#authorization)). When changing
them, run them locally against a test Fortnox account before releasing —
they bypass the gem's logger and talk directly to the OAuth token
endpoint, so issues won't show up in HTTP wire logs.
