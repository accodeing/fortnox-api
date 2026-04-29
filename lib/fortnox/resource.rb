# frozen_string_literal: true

module Fortnox
  class Resource < RestEasy::Resource
    include Fortnox::Types

    settings do
      setting :instance_wrapper, reader: true
      setting :collection_wrapper, reader: true
    end

    before_parse do |data|
      # Extract pagination info if it exists
      # if data.has_key?("MetaInformation")
      #   meta.total = data["MetaInformation"]["@TotalResources"]
      #   meta.pages = data["MetaInformation"]["@TotalPages"]
      #   meta.current_page = data["MetaInformation"]["@CurrentPage"]
      # end

      # Unwrap response body
      if data.key?(config.instance_wrapper)
        next data[config.instance_wrapper]
      elsif data.key?(config.collection_wrapper)
        next data[config.collection_wrapper]
      else
        raise Fortnox::RequestError, "Unknown response format: #{data}"
      end
    end

    after_serialise do |data|
      if meta.new?
        # Strip nils for new records — rely on Fortnox defaults
        data = data.compact
      elsif __changes__.any?
        # Only send changed attributes on update, preserving explicit nils
        changed_api_names = __changes__.keys.filter_map do |model_name|
          self.class.all_attribute_definitions[model_name]&.api_name
        end
        data = data.slice(*changed_api_names)
      end

      # TODO: rest-easy should do this wrapping for us.
      { config.instance_wrapper => data }
    end

    class << self
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
          super(**options)
        end
      end
    end
  end
end
