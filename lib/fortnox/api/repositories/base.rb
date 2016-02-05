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

        require "fortnox/api/repositories/base/options"

        def initialize( options )
          super()

          @options = options
        end

        private

          def instansiate( hash )
            hash[ 'new' ] = false
            self.class.MODEL.new( hash )
          end

      end
    end
  end
end
