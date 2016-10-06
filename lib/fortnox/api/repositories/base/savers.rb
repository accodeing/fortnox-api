module Fortnox
  module API
    module Repository
      module Savers

        def save( entity )
          return true if entity.saved?

          hash = @mapper.entity_to_hash( entity, @keys_filtered_on_save )

          return save_new( hash ) if entity.new?
          update_existing( hash )
        end

      private

        def save_new( hash )
          post( self.class::URI, { body: hash.to_json } )
        end

        def update_existing( hash )
          put(
              entity_url( hash ),
              { body: hash.to_json }
            )
        end

        def entity_url( hash )
          id = cut_id_from_hash( hash )
          "#{ self.class::URI }#{ id }"
        end

        def cut_id_from_hash( hash )
          hash[ @mapper.json_entity_wrapper ].delete( self.class::UNIQUE_ID )
        end
      end
    end
  end
end
