require 'dry-types'

module Fortnox
  module API
    module Types
      include Dry::Types.module

      require 'fortnox/api/types/required'
      require 'fortnox/api/types/defaulted'
      require 'fortnox/api/types/nullable'

      require 'fortnox/api/types/enums'

      AccountNumber = Strict::Int.constrained( gt: 0, lteq: 9999 ).optional
      ArticleNumber = Strict::String.constrained( max_size: 50 ).optional

      CountryCode = Strict::String.constrained( included_in: CountryCodes.values ).optional.constructor{|v| v.to_s.upcase[0...2] unless v.nil? }
      Currency = Strict::String.constrained( included_in: Currencies.values ).optional.constructor{|v| v.to_s.upcase[0...3] unless v.nil? }

      DiscountType = Strict::String.constrained( included_in: DiscountTypes.values ).optional.constructor{|v| v.to_s.upcase unless v.nil? }
      HouseWorkType = Strict::String.constrained( included_in: HouseWorkTypes.values ).optional.constructor{|v| v.to_s.upcase unless v.nil? }

      require 'fortnox/api/types/model'
    end
  end
end
