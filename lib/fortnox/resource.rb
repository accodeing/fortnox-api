# frozen_string_literal: true

module Fortnox
  class Resource < RestEasy::Resource
    include Fortnox::Types
    include Serialisation::ResourceJSON

    settings do
      setting :instance_wrapper, reader: true
      setting :collection_wrapper, reader: true
      setting :scope, reader: true
    end

    @registered_resources = []

    before_parse do |data, meta|
      if data.key?(config.instance_wrapper)
        meta.partial = false
        next data[config.instance_wrapper]
      elsif data.key?(config.collection_wrapper)
        meta.partial = true
        next data[config.collection_wrapper]
      else
        raise Fortnox::RequestError, "Unknown response format: #{data}"
      end
    end

    after_serialise { |data| default_after_serialise(data) }

    # Translate rest-easy errors at the gem boundary so callers only see
    # Fortnox-namespaced exceptions.
    module ErrorTranslation
      private

      def with_translated_errors
        yield
      rescue RestEasy::ConstraintError => e
        raise Fortnox::ConstraintError.new(e.attribute_name, e.value, e.message)
      rescue RestEasy::MissingAttributeError => e
        raise Fortnox::MissingAttributeError, e.attribute_name
      rescue RestEasy::AttributeError => e
        raise Fortnox::AttributeError, e.message
      rescue RestEasy::RequestError => e
        raise Fortnox::RequestError, e.response || e.message
      end
    end

    include ErrorTranslation # instance-level methods
    extend ErrorTranslation # class-level methods

    class << self
      attr_reader :registered_resources

      def inherited(subclass)
        super
        Fortnox::Resource.registered_resources << subclass
      end

      def parse(response)
        with_translated_errors do
          pagination = extract_pagination(response)
          result = super
          result.is_a?(Array) ? Collection.new(result, **pagination) : result
        end
      end

      def new(...)
        with_translated_errors { super }
      end

      def stub(**model_data)
        with_translated_errors { super }
      end

      def save(instance)
        # A persisted record with no recorded changes has nothing to write.
        # Without this short-circuit rest-easy would PUT the entire record
        # back, re-sending every untouched attribute and risking clobbering
        # changes made elsewhere since it was loaded.
        return instance if !instance.meta.new? && instance.__changes__.empty?

        with_translated_errors { super }
      end

      def only(filter)
        response = get(path: config.path, params: { filter: })
        parse(response)
      end

      def search(hash)
        attribute, value = hash.first
        response = get(path: config.path, params: { attribute => value })
        parse(response)
      end

      def find(id_or_hash)
        return find_all_by(id_or_hash) if id_or_hash.is_a? Hash

        find_one_by(id_or_hash)
      end

      def find_one_by(id)
        response = get(path: "#{config.path}/#{id}")
        parse(response)
      end

      def find_all_by(hash)
        response = get(path: config.path.to_s, params: hash)
        parse(response)
      end

      [:get, :post, :put, :delete].each do |method|
        define_method(method) do |**options|
          options[:headers] ||= {}
          options[:headers]['Content-Type'] = 'application/json'
          options[:headers]['Accept'] = 'application/json'
          with_translated_errors { super(**options) }
        end
      end

      private

      def extract_pagination(data)
        return {} unless data.is_a?(Hash) && data.key?('MetaInformation')

        meta = data['MetaInformation']
        {
          total: meta['@TotalResources']&.to_i,
          pages: meta['@TotalPages']&.to_i,
          current_page: meta['@CurrentPage']&.to_i
        }
      end
    end

    def update(...)
      with_translated_errors { super }
    end

    def serialise(...)
      with_translated_errors { super }
    end

    private

    # Shared serialisation tail used by the base after_serialise hook. Exposed
    # as an instance method so subclass hooks can post-process the payload (e.g.
    # drop a field) and still reuse it — rest-easy hooks override, not chain.
    def default_after_serialise(data)
      if meta.new?
        # Strip nils for new records — rely on Fortnox defaults
        data = data.compact
      elsif __changes__.any?
        # Send only the attributes passed to .update — field-level dirty
        # tracking, not a value diff, so an attribute equal to its stored
        # value is still sent, and an explicit nil reaches Fortnox as a clear.
        data = data.slice(*__changes__.keys.filter_map { |name| self.class.all_attribute_definitions[name]&.api_name })
      end

      # TODO: rest-easy should do this wrapping for us.
      { config.instance_wrapper => data }
    end
  end
end
