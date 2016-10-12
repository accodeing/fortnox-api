module Fortnox
  module API
    module Repository
      module Savers

        def save( entity )
          return true if entity.saved?

          hash = @mapper.entity_to_hash( entity, @keys_filtered_on_save )

          return save_new( hash ) if entity.new?
          update_existing( entity, hash )
        end

      private

        def save_new( hash )
          instansiate_saved( post( self.class::URI, { body: hash.to_json } ) )
        end

        def update_existing( entity, hash )
          parent_hash = @mapper.entity_to_hash( entity.parent, @keys_filtered_on_save )
          diff = @mapper.diff( hash, parent_hash )
          instansiate_saved( put( update_url( entity ), { body: diff.to_json } ) )
        end

        def update_url( entity )
          "#{ self.class::URI }#{ entity.unique_id }"
        end

        def instansiate_saved( wrapped_json_hash )
          instansiate(
            @mapper.wrapped_json_hash_to_entity_hash(
              wrapped_json_hash
            )
          )
        end
      end
    end
  end
end
