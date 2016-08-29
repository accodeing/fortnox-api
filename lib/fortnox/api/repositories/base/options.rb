module Fortnox
  module API
    module Repository
      class Base
        class Options

          attr_accessor :uri, :json_collection_wrapper, :json_entity_wrapper,
                        :unique_id, :keys_filtered_on_save

          def initialize(
                uri:,
                json_collection_wrapper:,
                json_entity_wrapper:,
                unique_id:,
                keys_filtered_on_save: [ :url ]
              )

            @uri = uri
            @json_collection_wrapper = json_collection_wrapper
            @json_entity_wrapper = json_entity_wrapper
            @unique_id = unique_id
            @keys_filtered_on_save = keys_filtered_on_save
          end

        end
      end
    end
  end
end
