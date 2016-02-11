module Fortnox
  module API
    module Repository
      class Base
        class Options

          attr_accessor :uri, :json_list_wrapper, :json_unit_wrapper,
                        :unique_id, :attr_to_json_map, :json_to_attr_map,
                        :keys_filtered_on_save

          def initialize(
                uri:,
                json_list_wrapper:,
                json_unit_wrapper:,
                unique_id:,
                attribute_name_to_json_key_map: {},
                keys_filtered_on_save: [ :url ]
              )

            @uri = uri
            @json_list_wrapper = json_list_wrapper
            @json_unit_wrapper = json_unit_wrapper
            @unique_id = unique_id
            @attr_to_json_map = attribute_name_to_json_key_map
            @json_to_attr_map = @attr_to_json_map.invert
            @keys_filtered_on_save = keys_filtered_on_save
          end

        end
      end
    end
  end
end
