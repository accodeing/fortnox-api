require "fortnox/api/base"
require "fortnox/api/repositories/base/loaders"
require "fortnox/api/repositories/base/savers"

module Fortnox
  module API
    module Repository
      class Base < Fortnox::API::Base

        include Loaders
        include Savers

        require "fortnox/api/repositories/base/options"

        attr_reader :options, :mapper

        def initialize( uri, unique_id, keys_filtered_on_save: [ :url ] )
          super()

          @options = self.class::Options.new( uri, unique_id, keys_filtered_on_save )
          @mapper = self.class::MAPPER.new
        end

        private

          def instansiate( hash )
            hash[ :new ] = false
            hash[ :unsaved ] = false
            self.class::MODEL.new( hash )
          end

      end
    end
  end
end
