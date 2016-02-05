module Fortnox
  module API
    module Repository
      module Savers

        def save( entity )
          return true if entity.saved?

          hash = entity_to_hash( entity )
          json = hash.to_json

          response = entity.new? ? save_new( json ) : update_existing( json )
        end

      private

        def save_new( json )
          post( @uri, { body: json } )
        end

        def update_existing( json )
          put( @uri, { body: json } )
        end

      end
    end
  end
end
