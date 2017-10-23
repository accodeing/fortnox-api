require 'fortnox/api/types'

module Fortnox
  module API
    module Mapper
      Identity = ->(value){ value }

      Date = ->(value){ value.to_s }

      Array = ->(array) do
        array.each_with_object( [] ) do |item, converted_array|
          name = Fortnox::API::Mapper::Base.canonical_name_sym( item )
          converted_array << Fortnox::API::Registry[ name ].call( item )
        end
      end

      Registry.register( :integer, Fortnox::API::Mapper::Identity )
      Registry.register( :int, Fortnox::API::Mapper::Identity )
      Registry.register( :float, Fortnox::API::Mapper::Identity )
      Registry.register( :string, Fortnox::API::Mapper::Identity )
      Registry.register( :boolean, Fortnox::API::Mapper::Identity )
      Registry.register( :falseclass, Fortnox::API::Mapper::Identity )
      Registry.register( :trueclass, Fortnox::API::Mapper::Identity )
      Registry.register( :nilclass, Fortnox::API::Mapper::Identity )
      Registry.register( :array, Fortnox::API::Mapper::Array )
      Registry.register( :date, Fortnox::API::Mapper::Date )

      Registry.register( :account_number, Fortnox::API::Mapper::Identity )
      Registry.register( :country_code, Fortnox::API::Mapper::Identity )
      Registry.register( :currency, Fortnox::API::Mapper::Identity )
      Registry.register( :customer_type, Fortnox::API::Mapper::Identity )
      Registry.register( :discount_type, Fortnox::API::Mapper::Identity )
      Registry.register( :email, Fortnox::API::Mapper::Identity )
      Registry.register( :house_work_type, Fortnox::API::Mapper::Identity )
      Registry.register( :vat_type, Fortnox::API::Mapper::Identity )
      Registry.register( :labels, Fortnox::API::Mapper::Array )
    end
  end
end

require 'fortnox/api/mappers/customer'
require 'fortnox/api/mappers/default_delivery_types'
require 'fortnox/api/mappers/default_templates'
require 'fortnox/api/mappers/edi_information'
require 'fortnox/api/mappers/email_information'
require 'fortnox/api/mappers/invoice_row'
require 'fortnox/api/mappers/invoice'
require 'fortnox/api/mappers/order_row'
require 'fortnox/api/mappers/order'
require 'fortnox/api/mappers/project'
