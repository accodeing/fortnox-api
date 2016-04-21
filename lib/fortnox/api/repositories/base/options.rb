module Fortnox
  module API
    module Repository
      class Base
        class Options

          attr_accessor :uri, :json_collection_wrapper, :json_entity_wrapper,
                        :unique_id, :attr_to_json_map, :json_to_attr_map,
                        :keys_filtered_on_save

          #rubocop:disable Metrics/ParameterLists
          def initialize(
                uri:,
                json_collection_wrapper:,
                json_entity_wrapper:,
                unique_id:,
                attribute_name_to_json_key_map: {},
                keys_filtered_on_save: [ :url ]
              )

            @uri = uri
            @json_collection_wrapper = json_collection_wrapper
            @json_entity_wrapper = json_entity_wrapper
            @unique_id = unique_id
            @attr_to_json_map = attribute_name_to_json_key_map
            @json_to_attr_map = @attr_to_json_map.invert
            @keys_filtered_on_save = keys_filtered_on_save
          end
          #rubocop:enable Metrics/ParameterLists

        end
      end
    end
  end
end
