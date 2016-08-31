module Fortnox
  module API
    module Repository
      module Savers

        def save( entity )
          return true if entity.saved?

          hash = @mapper.entity_to_hash( entity, @options.keys_filtered_on_save )

          return save_new( hash ) if entity.new?
          update_existing( hash )
        end

      private

        def save_new( hash )
          post( @options.uri, { body: hash.to_json } )
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
          hash[ @mapper.json_entity_wrapper ].delete( @options.unique_id )
        end
      end
    end
  end
end
