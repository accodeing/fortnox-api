require "fortnox/api/base"
require "fortnox/api/repositories/base/json_convertion"
require "fortnox/api/repositories/base/loaders"
require "fortnox/api/repositories/base/savers"

module Fortnox
  module API
    module Repository
      class Base < Fortnox::API::Base

        include JSONConvertion
        include Loaders
        include Savers

        def initialize(
          base_uri:,
          json_list_wrapper:,
          json_unit_wrapper:,
          unique_id:,
          attribut_name_to_json_key_map: {},
          keys_filtered_on_save: [ :url ],
        )
          super()

          @base_uri = base_uri
          @json_list_wrapper = json_list_wrapper
          @json_unit_wrapper = json_unit_wrapper
          @unique_id = unique_id
          @attr_to_json_map = attribut_name_to_json_key_map
          @json_to_attr_map = @attr_to_json_map.invert
          @keys_filtered_on_save = keys_filtered_on_save
        end

      end
    end
  end
end
