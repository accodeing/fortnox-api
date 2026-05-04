# Fortnox gem - Migration to 1.0 (rest-easy)

## TODO

* [ ] Pagination metadata and Collection class:
  - Basic pagination works — users can pass `find(page: 2, limit: 50)` and get the correct page back.
  - Fortnox returns `MetaInformation` (`@TotalResources`, `@TotalPages`, `@CurrentPage`) in collection responses, but this is currently stripped in `before_parse`.
  - To expose this metadata: parse MetaInformation and return it alongside results.
  - rest-easy: needs a Collection class that's iterable but also carries pagination info. Currently `all`/`find_all_by` return plain arrays.
  - Fortnox collection endpoints return partial models (fewer attributes than single-resource endpoints). The Collection class should account for this — models from collections are not the same as fully fetched models.
  - Removes the commented-out pagination block in `lib/fortnox/resource.rb:12-18`.
* [ ] CI setup (GitHub Actions to replace Travis CI)

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
