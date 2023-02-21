# Readme for Developers

## Testing

This gem has integration tests to verify the code against the real API. It uses
[vcr](https://github.com/vcr/vcr) to record API endpoint responses. These
responses are stored locally and are called vcr cassettes. If no cassettes are
available, vcr will record new ones for you. Once in a while, it's good to throw
away all cassettes and rerecord them. Fortnox updates their endpoints and we
need to keep our code up to date with the reality. There's a handy rake task for
removing all cassettes, see `rake -T`. Note that when rerecording all cassettes,
do it one repository at a time, otherwise you'll definitely get
`429 Too Many Requests` from Fortnox. Run them manually with something like
`bundle exec rspec spec/fortnox/api/repositories/article_spec.rb`. Also, you
will need to update some test data in specs, see notes in specs.

### Test environment variables

`.env.test` includes environment variables used for testing. If you want to run
tests against a real (or test) Fortnox account you need to provide valid
credentials in `.env`. See [Get tokens](get-tokens) for how to issue valid
tokens and `.env.template` for which values you need to provide. Then, you must
move these into `.env.test` since that's the environment file used for testing.

If you want the gem to refresh your tokens during testing, you can enable that
feature by setting the environment variable `REFRESH_TOKENS=true`.

### Seeding

There's a Rake task for seeding the Test Fortnox instance with data that the
test suite needs. See `rake -T` to find the task.

### Debug mode while running tests

There's a `DEBUG` environment variable to set if you want to debug during
testing.

## Rubocop

When updating Rubocop in `fortnox-api.gemspec`, you need to set the explicit
version that codeclimate runs in `.codeclimate.yml`

## Updating Ruby version

When updating the required Ruby version, you need to do the following:

- Bump Ruby version in `fortnox-api.gemspec`
- Update gems if needed
- Verify that the test suite is passing
- Bump `TargetRubyVersion` in `.rubocop.yml` and verify that the Rubocop version
  we are using is supporting that Ruby version. Otherwise you need to upgrade
  Rubocop as well, see [Rubocop instructions](#rubocop). The version here should
  be the lowest version we support.
- Update `.tool-versions` to the **newest version we support**
- Update `.travis.yml` with the new Ruby versions
- Update required Ruby version in the readme
- Verify that all GitHub integrations works in the pull request you are creating

# Contributing

See the [CONTRIBUTE](CONTRIBUTE.md) readme.
