# Fortnox gem - Migration to 1.0 (rest-easy)

## TODO

### Documentation
* [x] README.md
* [x] CHANGELOG.md
* [x] LICENSE.txt
* [x] CONTRIBUTE.md
* [x] DEVELOPER_README.md
* [x] MIGRATING.md
* [x] .rspec
* [x] docs/gotchas.md
* [x] docs/scopes.md (removed — use Fortnox developer docs instead)

### Auth
* [x] Set up proper authentication in lib/fortnox.rb (`Fortnox.access_token = token`)
* [x] Set up proper authentication in spec_helper.rb for recording VCR cassettes
* [x] Set up .env loading for tests (dotenv with .env.test / .env.test.local)
* [ ] Implement `Fortnox.request_access_token` (client credentials flow)
* [ ] Implement `fortnox-setup` executable (initial OAuth + tenant ID discovery)

### Testing
* [ ] Write label spec
* [ ] Re-record VCR cassettes with real auth to verify the gem works

### Code issues
* [x] Remove dead boolean parser
* [x] Fix date parser
* [ ] Implement `# TODO: new attribute` items across resources (25+ attributes pending)
* [ ] Uncomment/implement pagination support in `lib/fortnox/resource.rb` (MetaInformation parsing)
* [ ] Improve error handling: rest-easy raises `RequestError` for all non-2xx responses (has `RemoteServerError` and `RateLimitError` classes but doesn't use them). Fix in rest-easy to raise different errors for 4xx vs 5xx, then use those in the Fortnox gem.

### Infrastructure
* [x] Rakefile
* [x] .gitignore
* [ ] CI setup (GitHub Actions to replace Travis CI)
* [ ] Gem version bump strategy (currently 0.0.1, target 1.0.0)
* [ ] Consider adding `bin/console` for development convenience
