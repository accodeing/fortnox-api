module Fortnox
  module API
    module Repository
      module Savers

        def save( entity )
          return true if entity.saved?

          hash = entity_to_hash( entity )
          json = hash.to_json

          entity.new? ? save_new( json ) : update_existing( hash )
        end

      private

        def save_new( json )
          post( @options.uri, { body: json } )
        end

        def update_existing( hash )
          put(
              entity_url( hash ),
              { body: hash.to_json }
            )
        end

        def entity_url( hash )
          id = cut_id_from_hash( hash )
          "#{ @options.uri }#{ id }"
        end

        def cut_id_from_hash( hash )
          hash[ @options.json_entity_wrapper ].delete( @options.unique_id )
        end
      end
    end
  end
end
