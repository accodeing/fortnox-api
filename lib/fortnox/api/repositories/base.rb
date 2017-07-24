require "fortnox/api/base"
require "fortnox/api/repositories/base/loaders"
require "fortnox/api/repositories/base/savers"

module Fortnox
  module API
    module Repository
      class Base < Fortnox::API::Base

        include Loaders
        include Savers

        attr_reader :mapper, :keys_filtered_on_save

        def initialize( keys_filtered_on_save: [ :url ] )
          super()

          @keys_filtered_on_save = keys_filtered_on_save
          @mapper = Registry[ Mapper::Base.canonical_name_sym( self.class::MODEL )].new
        end

        private

          def instantiate( hash )
            hash[ :new ] = false
            hash[ :unsaved ] = false
            self.class::MODEL.new( hash )
          end

      end
    end
  end
end
