module Fortnox
  module API
    module Types

      module Nullable
        String = Types::Strict::String.optional
        Float = Types::Strict::Float.optional
        Integer = Types::Strict::Int.optional
        Boolean = Types::Bool.optional
      end

    end
  end
end
