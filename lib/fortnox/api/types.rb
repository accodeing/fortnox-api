require 'dry-types'

module Fortnox
  module API
    module Types
      include Dry::Types.module

      require 'fortnox/api/types/required'
      require 'fortnox/api/types/defaulted'
      require 'fortnox/api/types/nullable'

      require 'fortnox/api/types/enums'

      CountryCode = Strict::String.constrained( included_in: CountryCodes.values ).optional.constructor{|v| v.to_s.upcase[0...2] unless v.nil? }
      Currency = Strict::String.constrained( included_in: Currencies.values ).optional.constructor{|v| v.to_s.upcase[0...3] unless v.nil? }

      require 'fortnox/api/types/model'
    end
  end
end
