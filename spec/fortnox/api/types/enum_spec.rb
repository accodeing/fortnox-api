require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/examples/enum'

describe Fortnox::API::Types do
  it_behaves_like 'enum', 'CountryCode', 'CountryCodes', auto_crop: true
  it_behaves_like 'enum', 'Currency', 'Currencies', auto_crop: true
  it_behaves_like 'enum', 'CustomerType', 'CustomerTypes'
  it_behaves_like 'enum', 'DiscountType', 'DiscountTypes'
  it_behaves_like 'enum', 'HouseWorkType', 'HouseWorkTypes'
  it_behaves_like 'enum', 'VATType', 'VATTypes'
end