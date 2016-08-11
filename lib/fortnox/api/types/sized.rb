module Fortnox
  module API
    module Types
      module Sized
        module String
          def self.[]( size )
            Types::Strict::String.constrained( max_size: size ).optional
          end
        end

        module Integer
          def self.[]( low, high )
            Types::Strict::Int.constrained( gteq: low, lteq: high ).optional
          end
        end

        module Float
          def self.[]( low, high )
            Types::Strict::Float.constrained( gteq: low, lteq: high ).optional
          end
        end
      end
    end
  end
end
