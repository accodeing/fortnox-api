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
    end
  end
end
