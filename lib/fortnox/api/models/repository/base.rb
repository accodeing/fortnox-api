require "fortnox/api/base"
require "fortnox/api/models/repository/json_convertion"
require "fortnox/api/models/repository/loaders"
require "fortnox/api/models/repository/savers"

module Fortnox
  module API
    module Repository
      class Base < Fortnox::API::Base

        include JSONConvertion
        include Loaders
        include Savers

        # TODO: Convert to keyword arguments.
        # TODO: Add exceptions for missing required arguments.
        def initialize( options = {} )
          super()
          
          @base_uri = options.fetch( :base_uri ){ '/' }
          @json_list_wrapper = options.fetch( :json_list_wrapper ){ '' }
          @json_unit_wrapper = options.fetch( :json_unit_wrapper ){ '' }
          @unique_id = options.fetch( :unique_id ){ 'id' }
          @attr_to_json_map = options.fetch( :attribut_name_to_json_key_map ){ {} }
          @json_to_attr_map = @attr_to_json_map.invert
          @keys_filtered_on_save = options.fetch( :keys_filtered_on_save ){ {} }
        end

      end
    end
  end
end
