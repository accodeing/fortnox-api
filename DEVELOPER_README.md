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
