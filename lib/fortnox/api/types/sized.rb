module Fortnox
  module API
    module Types
      module Sized
        module String
          def self.[]( size )
            Types::Strict::String.constrained( max_size: size ).optional.constructor{ |value| value.to_s unless value.nil? }
          end
        end

        module Integer
          def self.[]( low, high )
            Types::Strict::Int.constrained( gteq: low, lteq: high ).optional.constructor{ |value| value.to_i unless value.nil? }
          end
        end

        module Float
          def self.[]( low, high )
            Types::Strict::Float.constrained( gteq: low, lteq: high ).optional.constructor{ |value| value.to_f unless value.nil? }
          end
        end
      end
    end
  end
end
