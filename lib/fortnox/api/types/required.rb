module Fortnox
  module API
    module Types

      module Required
        String = Types::Strict::String.with( required: true )
      end
      
    end
  end
end
