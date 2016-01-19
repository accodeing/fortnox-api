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

        def initialize( options = {} )
          super()
          @base_uri = options.fetch( :base_uri ){ '/' }
          @json_list_wrapper = options.fetch( :json_list_wrapper ){ '' }
          @json_unit_wrapper = options.fetch( :json_unit_wrapper ){ '' }
          @attr_to_json_map = options.fetch( :key_map ){ {} }
          @json_to_attr_map = @attr_to_json_map.invert
        end

      end
    end
  end
end
