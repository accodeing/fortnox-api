# Fortnox gem - Migration to 1.0 (rest-easy)

## TODO

### Missing files (present on development, needed for 1.0)
* [ ] README.md (rewrite for new rest-easy architecture)
* [ ] CHANGELOG.md (start fresh for 1.0, reference old changelog)
* [ ] LICENSE.txt
* [ ] .env.template (document required env vars for contributors)
* [ ] .gitignore (currently missing — .env, coverage/, *.gem, tmp/ should be ignored)
* [ ] .rspec
* [ ] Rakefile
* [ ] bin/ scripts (console, get_tokens, renew_tokens — adapt for rest-easy)

### Auth & testing
* [ ] Set up proper authentication in lib/fortnox.rb (Bearer token via Fortnox OAuth2 access token)
* [ ] Set up proper authentication in spec_helper.rb for recording VCR cassettes
* [ ] Set up .env loading for tests (FORTNOX_ACCESS_TOKEN or similar)
* [ ] Re-record VCR cassettes with real auth to verify the gem works
* [ ] Decide on token refresh strategy (see notes below)

### Code issues
* [ ] Fix typo in `lib/fortnox/resources/parsers/date.rb` — `date_sting` should be `date_string`
* [ ] Fix typo in `lib/fortnox/resources/parsers/boolean.rb` — `boolean_sting` should be `boolean_string`
* [ ] Implement `# TODO: new attribute` items across resources (25+ attributes pending)
* [ ] Uncomment/implement pagination support in `lib/fortnox/resource.rb` (MetaInformation parsing)

### Nice to have / later
* [ ] CI setup (GitHub Actions to replace Travis CI)
* [ ] CONTRIBUTE.md
* [ ] Rubocop config
* [ ] Consider adding `bin/console` for development convenience
* [ ] Gem version bump strategy (currently 0.0.1, target 1.0.0)
* [ ] Clean up old .gem files from repo root

---

## Token refresh (design notes)

```ruby
Fortnox::RefreshToken.call(
  refresh_token: credentials.refresh_token,
  client_id: ENV.fetch('FORTNOX_API_CLIENT_ID'),
  client_secret: ENV.fetch('FORTNOX_API_CLIENT_SECRET')
)
```

Alternative:
```ruby
class Fortnox::Token < Fortnox::Resource
  def refresh(refresh_token:, client_id:, client_secret:)
    # post...
  end
end

Fortnox::Token.refresh(
  refresh_token: credentials.refresh_token,
  client_id: ENV.fetch('FORTNOX_API_CLIENT_ID'),
  client_secret: ENV.fetch('FORTNOX_API_CLIENT_SECRET')
)
```

## Access Token

```ruby
Fortnox.configure do |config|
  # some configs
end

access_token = FetchAccessToken.call(
  refresh_token: credentials.refresh_token,
  client_id: ENV.fetch('FORTNOX_API_CLIENT_ID'),
  client_secret: ENV.fetch('FORTNOX_API_CLIENT_SECRET')
)

# We could do:
authentication = Fortnox::Auth::PSK.new(access_token:)
Fortnox.config.authentication = authentication

# But better would be:
Fortnox.access_token = access_token
```
