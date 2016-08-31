module Fortnox
  module API
    module Repository
      class Base
        class Options

          attr_accessor :uri, :unique_id, :keys_filtered_on_save

          def initialize(
                uri:,
                unique_id:,
                keys_filtered_on_save: [ :url ]
              )

            @uri = uri
            @unique_id = unique_id
            @keys_filtered_on_save = keys_filtered_on_save
          end

        end
      end
    end
  end
end
