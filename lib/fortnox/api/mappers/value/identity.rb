module Fortnox
  module API
    module Mapper
      Identity = ->(value) { value }

      Registry.register(:integer, Fortnox::API::Mapper::Identity)
      Registry.register(:int, Fortnox::API::Mapper::Identity)
      Registry.register(:float, Fortnox::API::Mapper::Identity)
      Registry.register(:string, Fortnox::API::Mapper::Identity)
      Registry.register(:boolean, Fortnox::API::Mapper::Identity)
      Registry.register(:falseclass, Fortnox::API::Mapper::Identity)
      Registry.register(:trueclass, Fortnox::API::Mapper::Identity)
      Registry.register(:nilclass, Fortnox::API::Mapper::Identity)

      Registry.register(:account_number, Fortnox::API::Mapper::Identity)
      Registry.register(:country_code, Fortnox::API::Mapper::Identity)
      Registry.register(:currency, Fortnox::API::Mapper::Identity)
      Registry.register(:customer_type, Fortnox::API::Mapper::Identity)
      Registry.register(:discount_type, Fortnox::API::Mapper::Identity)
      Registry.register(:email, Fortnox::API::Mapper::Identity)
      Registry.register(:housework_type, Fortnox::API::Mapper::Identity)
      Registry.register(:vat_type, Fortnox::API::Mapper::Identity)
    end
  end
end
