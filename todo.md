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
* [x] Implement `Fortnox.request_access_token` (client credentials flow)
* [x] Implement `fortnox-setup` executable (initial OAuth + tenant ID discovery)
* [x] Implement `fortnox-update-env` executable

### Testing — VCR cassette re-recording
* [x] Label — all passing (4 tests)
* [x] Unit — all passing (11 tests)
* [x] Project — all passing (12 tests)
* [x] TermsOfPayment — all passing (9 tests)
* [x] Article — all passing (21 tests)
* [x] Customer — all passing (23 tests)
* [x] Invoice — mostly passing, 7 pending (country code parser, EDI update, reset tests)
* [x] Order — mostly passing, 7 pending (EmailInformation update, nested model price, search/filter data)
* [x] Auth — all passing (2 tests)
* [ ] Re-record all cassettes after rest-easy fixes (headers, update diff)

### Code issues — found during re-recording
* [x] Remove dead boolean parser
* [x] Fix date parser
* [x] Label: split single `attr` line into two, add `path` and `:key`
* [x] Strip nil values in `after_serialise` — Fortnox rejects explicit nulls
* [x] Add `require 'dry-struct'` to struct files
* [x] Generic `Parsers::Struct.for(klass)` and `Parsers::StructArray.for(klass)` with unit tests
* [x] KEY_MAP for EDIInformation and EmailInformation (acronym key serialisation)
* [x] Wire struct parsers to resources (customer, document, invoice, order)
* [x] Invoice/Order filter tests — seeded data manually (fully paid invoices, cancelled orders)
* [x] Invoice/Order search — fixed search terms to match seeded data
* [x] Country code handling: parser used `iso_short_name` (e.g. 'United Kingdom of Great Britain and Northern Ireland') instead of `translations['en']` ('United Kingdom')
* [ ] Order nested model test uses price that exceeds Fortnox limit after VAT — fix test data
* [ ] Implement `# TODO: new attribute` items across resources (25+ attributes pending)
* [ ] Pagination metadata and Collection class:
  - Basic pagination works — users can pass `find(page: 2, limit: 50)` and get the correct page back.
  - Fortnox returns `MetaInformation` (`@TotalResources`, `@TotalPages`, `@CurrentPage`) in collection responses, but this is currently stripped in `before_parse`.
  - To expose this metadata: parse MetaInformation and return it alongside results.
  - rest-easy: needs a Collection class that's iterable but also carries pagination info. Currently `all`/`find_all_by` return plain arrays.
  - Fortnox collection endpoints return partial models (fewer attributes than single-resource endpoints). The Collection class should account for this — models from collections are not the same as fully fetched models.
* [x] Missing `:key` flag — all resources now have key defined (Invoice/Order inherit from Document, Label has `:key` on `id`)

### Tests to port from old gem
* [ ] Housework type tests — 18+ types tested against Fortnox API, each with own VCR cassette. Verifies each type is accepted and catches legacy/deprecated types. Was in separate `housework_types_spec.rb`, not in order spec. Includes ROT/RUT tax reduction type validation and edge cases (OTHERCOSTS can't have housework=true, wrong tax reduction type raises error).

### Pending test issues (4 pending)
* Invoice: reset to nil (2 tests — pre-existing pending, testing Fortnox behaviour)
* Order: nested model save (2 tests) — price `-9_999_999_999` worked with old gem (sent only specified fields) but now rest-easy sends all attributes, causing Fortnox to calculate VAT that exceeds the limit. Fix after rest-easy gets diff support, then re-record cassette. Separate commit since this is a Fortnox behaviour change.

### Testing strategy
* All failures found during re-recording were serialisation issues (sending data TO Fortnox), never parsing issues (reading data FROM Fortnox). VCR cassettes only protect against parsing regressions — serialisation bugs are invisible during replay because VCR matches on method + URL, not request body.
* [x] Enable VCR request body matching — added custom `:json_body` matcher that compares parsed JSON (ignoring key order). Catches serialisation regressions during cassette replay.

### rest-easy fixes needed (blocking cassette re-recording)
* [ ] Default headers — add a `default_headers` setting to rest-easy that defaults to `{ 'Accept' => 'application/json', 'Content-Type' => 'application/json' }`. Client gems can override or extend via configure, same pattern as authentication.
* [ ] Update sends all attributes — add a `full_update` setting (default `true` for backwards compatibility). When `false`, use `__changes__` to only send changed fields. Fortnox gem should set `full_update false`.
* [ ] Error classes — rest-easy defines `RemoteServerError` and `RateLimitError` but never uses them. Consider removing them to avoid confusion.
* [ ] Missing test: stub → update → save flow (updating an unsaved instance and saving it). Not tested in rest-easy specs.
* [ ] Nested object serialisation — `Attribute#to_json_value` falls back to `.to_s` for unknown types, silently producing garbage like `"#<Fortnox::Structs::...>"`. Add a check for `respond_to?(:to_hash)` and call `value.to_hash`. No new dependencies needed. Currently worked around with parsers in Fortnox gem.
* [ ] Type as parser — when a type argument to `attr` responds to `.parse` and `.serialise`, rest-easy should use it as both type and parser. Currently it consumes it as the parser and leaves no type, requiring an explicit parser argument. This would allow `attr :edi_information, Structs::EDIInformation` instead of `attr :edi_information, Structs::EDIInformation, Parsers::Struct.for(Structs::EDIInformation)`.
* [ ] Nil stripping — currently worked around in `Fortnox::Resource.after_serialise`. Should be resolved by `full_update false` — unchanged nil attributes won't be sent. Remove the workaround after that.

### Struct improvements
* [x] Read-only/computed fields on structs — added `:read_only` flag to `Fortnox::Struct.attr`. Fields like `total`, `contribution_percent`, `price_excluding_vat` are now excluded from serialisation. Replaces the old `.with(private: true)` which was never enforced.

### Naming
* [ ] Rename `Parsers` to `Mappers` to align with rest-easy documentation terminology
* [ ] Rename project from `fortnox` to `fortnox-api` — partially done, some places still reference the old name

### Infrastructure
* [x] Rakefile
* [x] .gitignore
* [ ] License — should be LGPL-3.0, same as old gem. Currently set to MIT.
* [ ] CI setup (GitHub Actions to replace Travis CI)
* [ ] Gem version bump strategy (currently 0.0.1, target 1.0.0)
* [ ] Consider adding `bin/console` for development convenience
* [ ] Create PR of current work and send to Jonas for review

### Collection
```Ruby
# frozen_string_literal: true

module Fortnox
  class Collection
    extend Forwardable

    attr_reader :instances, :klass, :meta

    def_delegator :@instances, :each

    # usage ex:
    # Fortnox::Collection.new( Fortnox::Invoice.all )

    def initialize( array )
      raise Error.new("Fortnox::Collection only accepts an array of Fortnox::Resource instances") unless array.ia_a?(Array)
      return nil unless array.length > 1
      array.each do |instance|
      @class ||= instance.class
      raise Error.new("Fortnox::Collection can only contain Fortnox::Resource instances") unless instance.is_a?(Resource)
      raise Error.new("Fortnox::Collection can only contain one type of Fortnox::Resource instances") unless instance.class == @klass
    end

    @instances = array
    @meta = instances.first.meta
  end
end
```

```Ruby
  invoices = Fortnox::Collection.new(Fortnox::Invoice.all) # returns first page
  invoices.all # => [#<Fortnox::Invoice ...>, #<Fortnox::Invoice ...>, ...]
  # Internal runs instance.all
  invoices.total # => 205

  invoices.first.meta.total # => 100
  invoices.first # => #<Fortnox::Invoice ...>
  # Somewhere we need to support pagination here...

  Fortnox::Collection.new()
```

### Filters
This is not something we need to do now, we can take it later.

```Ruby
module Fortnox
  class Resource < RestEasy::Resource
    include Fortnox::Types

    DEFAULT_FILTERS = {
      lastmodified: Date,
      financialyear: Integer,
      financialyeardate: Date,
      fromdate: Date,
      todate: Date,
    }

    settings do
      setting :instance_wrapper, reader: true
      setting :collection_wrapper, reader: true
      setting :filters, default: {}, constructor: proc { |value|  value.merge(DEFAULT_FILTERS)}
      setting :sortby
    end

    before_parse do |data, meta|
      # Extract pagination info if it exists
      if data.has_key?("MetaInformation")
        meta.total_resources = data["MetaInformation"]["@TotalResources"]
        meta.pages = data["MetaInformation"]["@TotalPages"]
        meta.current_page = data["MetaInformation"]["@CurrentPage"]
      end

      # Unwrap response body
      if data.has_key?(config.instance_wrapper)
        next data[config.instance_wrapper]
      elsif data.has_key?(config.collection_wrapper)
        next data[config.collection_wrapper]
      else
        raise Fortnox::RequestError, "Unknown response format: #{ data }"
      end
    end

    after_parse do
      meta.partial = false
      # Attribute API names for attributes that are only present if the API response was a full response
      full_response_only_api_keys = self.class.attributes_with_flag(:partial_canary).values.map(&:api_name)

      # Exit early if the model doesn't have any attributes marked as full only, assumes it's always full
      next if full_response_only_api_keys.length == 0

      # Did the API response contain any of these keys?
      response_had_full_response_only_api_key = @api_data.any?{ |(key, value)| full_response_only_api_keys.include? key }

      # If it had any of these keys the response was full, so if it didn't it's a partial response
      meta.partial = !response_had_full_response_only_api_key
    end

    after_serialise do |data|
      # Wrap request body
      { config.instance_wrapper => data }
    end

    class << self
      def only(filter)
        type = config.filters[:filter]
        if type and type.is_a?(Dry::Types::Enum)
          type.call(filter.to_s)
        else
          raise Fortnox::ArgumentError.new("The \"filter:\" definition on \"#{self}\" is not an Enum")
        end
        response = get( path: config.path, params: { filter: } )
        parse(response)
      rescue Dry::Types::ConstraintError => e
        raise Fortnox::ArgumentError.new("\"#{filter}\" is not a valid filter, only #{type.values.map{|s| "\"#{s}\""}.join(", ")} are allowed")
      end

      def search(hash)
        attribute, value = hash.first
        response = get( path: config.path, params: { attribute => value } )
        parse(response)
      end

      def find(id_or_hash)
        return find_all_by(id_or_hash) if id_or_hash.is_a? Hash

        find_one_by(id_or_hash)
      end

      def find_one_by(id)
        response = get( path: "#{config.path}/#{id}" )
        parse(response)
      end

      def find_all_by(hash)
        if config.filters.length == 0
          raise Fortnox::ArgumentError.new("\"#{self}\" does not define any filterable attributes")
        end
        response = get( path: "#{config.path}", params: hash )
        parse(response)
      end
    end
  end
end
```

Usage example:
```Ruby
configure do
      path "customers"
      instance_wrapper "Customer"
      collection_wrapper "Customers"
      filters ({
        filter: String.enum("active", "inactive"),
        customernumber: String,
        name: String,
        zipcode: String,
        city: String,
        email: String,
        phone: String,
        organisationnumber: String,
        gln: String,
        glndelivery: String,
        lastmodified: String,
      })
      sortby String.enum("customernumber", "name")
    end
```
