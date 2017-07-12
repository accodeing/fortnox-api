module Fortnox
  module API
    module Repository
      module Savers

        def save( entity )
          return true if entity.saved?

          return save_new( entity ) if entity.new?
          update_existing( entity )
        end

      private
        def execute_save( entity )
          body = get_changes_on( entity ).to_json
          result = yield body
          instantiate_saved( result )
        end

        def save_new( entity )
          execute_save( entity ) do |body|
            post( self.class::URI, { body: body })
          end
        end

        def update_existing( entity )
          execute_save( entity ) do |body|
            put( get_update_url_for( entity ), { body: body })
          end
        end

        def get_changes_on( entity )
          hash = @mapper.entity_to_hash( entity, @keys_filtered_on_save )
          parent_hash = @mapper.entity_to_hash( entity.parent, @keys_filtered_on_save )

          @mapper.wrapp_entity_json_hash( @mapper.diff( hash, parent_hash ) )
        end

        def get_update_url_for( entity )
          "#{ self.class::URI }#{ entity.unique_id }"
        end

        def instantiate_saved( wrapped_json_hash )
          instantiate(
            @mapper.wrapped_json_hash_to_entity_hash(
              wrapped_json_hash
            )
          )
        end
      end
    end
  end
end
