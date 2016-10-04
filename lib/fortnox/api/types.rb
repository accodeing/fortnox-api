require 'dry-struct'
require 'dry-types'

module Fortnox
  module API
    module Types
      include Dry::Types.module

      require 'fortnox/api/types/required'
      require 'fortnox/api/types/defaulted'
      require 'fortnox/api/types/nullable'

      require 'fortnox/api/types/enums'

      require 'fortnox/api/types/sized'

      AccountNumber = Strict::Int.constrained( gt: 0, lteq: 9999 ).optional

      CountryCode = Strict::String.constrained( included_in: CountryCodes.values ).optional.constructor( EnumConstructors.sized(2) )
      Currency = Strict::String.constrained( included_in: Currencies.values ).optional.constructor( EnumConstructors.sized(3) )
      CustomerType = Strict::String.constrained( included_in: CustomerTypes.values ).optional.constructor( EnumConstructors.default )

      DiscountType = Strict::String.constrained( included_in: DiscountTypes.values ).optional.constructor( EnumConstructors.default )

      Email = Strict::String.constrained( max_size: 1024, format: /\A^$|[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i ).optional.constructor{ |v| v.to_s.downcase unless v.nil? }

      HouseWorkType = Strict::String.constrained( included_in: HouseWorkTypes.values ).optional.constructor( EnumConstructors.default )

      VATType = Strict::String.constrained( included_in: VATTypes.values ).optional.constructor( EnumConstructors.default )

      require 'fortnox/api/types/model'
    end
  end
end
