# Fortnox gem - Migration to 1.0 (rest-easy)

## TODO

- [ ] Release 1.0.0
  - [ ] Consolidate the breaking changes for 1.0.0 final under their own
    `### Breaking changes` header at the top of the release entry, ahead of
    `Added`/`Changed`/`Fixed`. Today they are `**Breaking**`-prefixed bullets
    scattered across the rc entries (rc1, rc7, rc13) — fine per-rc, too easy
    to miss for someone upgrading from 0.x in one jump. Cross-reference
    `MIGRATING_TO_1.0.md`.
- [ ] Adjust github workflow to include `development` and `main`, not `rest-easy`.
- [ ] Close the resource/struct coercion asymmetry (surfaced by Portal's 1.0
  migration; documented as a gotcha in `MIGRATING_TO_1.0.md`, not yet fixed).
  Resource attributes coerce via dry-types Params — `active: 'true'` → `true`,
  junk raises `Fortnox::ConstraintError`. Nested structs (`Fortnox::Structs::*`)
  use strict `Types::Bool` and reject every string. Same shape as the `:required`
  asymmetry fixed in rc11. Two parts:
  - Params-coerce struct attributes, or at least booleans. Note
    `Fortnox::Types::THE_TRUTH` in `lib/fortnox/types.rb` is dead code that
    already encodes the `'true'`/`'false'` mapping — it is defined and never
    referenced, so this was started and dropped.
  - Struct construction raises `Dry::Struct::Error`, which is not a
    `Fortnox::Error` and escapes `rescue Fortnox::Error`. rc13 translated
    `#update`/`#serialise`/`.new` on resources; the struct path was missed.
- [ ] Decide whether to ship a `require 'fortnox/rails'` bridge defining
  `Resource#as_json`. Every Rails consumer needs the same three-line adapter
  or `render json:` leaks `{api_data:, model_attributes:, changes:, meta:}`
  into responses (ActiveSupport walks children with `as_json`, which resources
  don't define, so `Object#as_json` serialises ivars). Documented in the Rails
  appendix of `MIGRATING_TO_1.0.md` as an initializer; shipping it would mean
  an optional-require file and a decision on whether `as_json` should emit
  model names or API names (`to_json` uses model names; `to_api` uses API ones).
- [ ] Consider making unknown keys in nested-struct hashes raise instead of
  being silently dropped. `stub(order_rows: [{'article_number' => '101'}])`
  (string keys, e.g. Rails params) yields `"OrderRows":[{}]` and Fortnox
  cheerfully creates the record with empty rows. dry-struct ignores unknown
  keys by default; `schema schema.strict` would make it raise. Needs thought
  about the parse path, which must stay tolerant of unknown API fields.
- [ ] Decide how to expose Fortnox field length limits to callers (open design question).

  **Context:** Downstream consumers need to enforce or truncate user input
  before it reaches the API, and currently have to duplicate Fortnox's field-length
  limits. Examples in consumer today:
  - `Orders::Types::INVOICE_REMARKS_MAX_LENGTH = 75` (mirrors `Document#your_order_number`,
    `Sized::String[75]` in `lib/fortnox/resources/document.rb`), with a code comment
    explicitly noting it comes from Fortnox — pure duplication, prone to silent drift.
  - truncating `InvoiceRow#description` to 252 chars ` …` because Fortnox caps it at 255.

  **The naive approach** — pick a handful of "important" fields and expose constants like
  `Fortnox::Structs::DocumentRow::DESCRIPTION_MAX_LENGTH = 255` — was rejected because
  the gem would have to hard-code which attributes get exposed and which don't. Every
  new field a consumer wants to enforce becomes a gem PR. That doesn't scale and
  pushes a policy decision (which fields are "user-facing enough" to deserve a constant)
  into the wrong repo.

  **Better directions to explore** (pick whichever fits the gem's design philosophy):
  1. **Programmatic introspection helper.** Expose something like
     `Fortnox::Structs::DocumentRow.max_size_for(:description) # => 255` that walks the
     dry-struct schema for the requested attribute and pulls `max_size` out of the
     constraint. Works for every `Sized::String[N]` attribute without per-field
     bookkeeping. Risk: depends on dry-types internals — but the gem already owns those
     definitions, so encapsulating the brittleness here (instead of in every consumer)
     is exactly the point.
  2. **A field-metadata DSL.** Replace `attribute? :description, Types::Sized::String[255]`
     with something like `string_attribute :description, max_size: 255` that records the
     limit in a class-level registry while still building the same dry-struct type.
     Heavier change, but gives consumers a clean `Fortnox::Resources::Document.limits`
     API and removes the dry-types dependency from the surface.
  3. **Validation/truncation helpers on the gem side.** Instead of exposing the number,
     expose a behaviour: `Fortnox::Structs::InvoiceRow.truncate(:description, str)` or
     a `fits?` predicate. Moves the policy (truncate vs. raise vs. ellipsis) to the
     caller, but the "how long is too long" stays inside the gem.

  **Working direction from design discussion.** Lean toward (1), with the dry-types
  brittleness concern addressed by tagging types with `.meta(max_size: N)` at construction
  time and reading `schema.key(:foo).type.meta[:max_size]` (struct) /
  `all_attribute_definitions[:foo].type.meta[:max_size]` (resource). `.meta` is the
  blessed dry-types API, not an internal.

  - **Single chokepoint, dual lookup.** Meta-tagging happens once in the `Sized` builders
    in `lib/fortnox/types.rb`. Lookup is two thin methods with the same public signature —
    one on `Fortnox::Struct`, one on `Fortnox::Resource` — so callers don't have to care
    which kind of object they hold.
  - **Opt-in per type, not automatic-from-constraints.** Tag only "user-input bounds the
    caller should enforce":
    - Tagged: `Sized::String[N]` (every `Sized::String` field, automatically); `Email`
      (manual `.meta(max_size: 1024)`).
    - Untagged: `AccountNumber` (0–9999 is a domain range, not a length cap);
      `Sized::Integer` / `Sized::Float` (numeric ranges, same reasoning). Add later only
      if a real consumer need surfaces.
  - **API shape.** `max_size_for(:field) # => Integer | nil`. Raise on unknown attribute
    names — `nil` is reserved for "exists but has no cap," and silently swallowing typos
    would re-create the silent-drift problem.
  - **Approach (3) layers on top, doesn't replace.** `fits?` / `truncate` are one-liners
    against `max_size_for`. Truncation policy (`…` vs. `[truncated]` vs. hard cut vs.
    raise) stays with the caller; the gem only owns "how long is too long." A consumer
    gets its ellipsis behaviour by composing these.

  Whichever direction is chosen, the goal is: **no consumer should ever need to
  write a literal Fortnox field length in its own source.**

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
