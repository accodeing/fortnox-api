module Fortnox
  module API
    module Repository
      module Savers

        def save( entity )
          return true if entity.saved?

          hash = entity_to_hash( entity )
          json = hash.to_json

          response = if entity.new?
            save_new( json )
          else
            update_existing( json )
          end

          # error handling
        end

      private

        def save_new( json )
          post( @base_uri, { body: json } )
        end

        def update_existing( json )
          put( @base_uri, { body: json } )
        end

      end
    end
  end
end
