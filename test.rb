require 'dry-types'

module Types
  include Dry::Types.module

  class Struct < Dry::Types::Struct

    constructor_type(:symbolized)

    def initialize( input_attributes )
      if missing_key = first_missing_required_key( input_attributes )
        raise Dry::Types::SchemaKeyError.new( missing_key )
      end

      super
    end

  private

    def missing_keys( attributes )
      non_nil_attributes = attributes.select{|_,value| !value.nil?}

      attribute_keys = non_nil_attributes.keys
      schema_keys =  self.class.schema.keys

      schema_keys - attribute_keys
    end

    def first_missing_required_key( attributes )
      all_missing_keys = missing_keys( attributes )
      missing_required = all_missing_keys.select do |name|
        self.class.schema[ name ].options[:required]
      end

      missing_required.first
    end

  end

  CountryCodes = Types::Strict::String.enum(
    'AF','AX','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW',
    'AU','AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT',
    'BO','BQ','BA','BW','BV','BR','IO','BN','BG','BF','BI','CV','KH',
    'CM','CA','KY','CF','TD','CL','CN','CX','CC','CO','KM','CG','CD',
    'CK','CR','CI','HR','CU','CW','CY','CZ','DK','DJ','DM','DO','EC',
    'EG','SV','GQ','ER','EE','ET','FK','FO','FJ','FI','FR','GF','PF',
    'TF','GA','GM','GE','DE','GH','GI','GR','GL','GD','GP','GU','GT',
    'GG','GN','GW','GY','HT','HM','VA','HN','HK','HU','IS','IN','ID',
    'IR','IQ','IE','IM','IL','IT','JM','JP','JE','JO','KZ','KE','KI',
    'KP','KR','KW','KG','LA','LV','LB','LS','LR','LY','LI','LT','LU',
    'MO','MK','MG','MW','MY','MV','ML','MT','MH','MQ','MR','MU','YT',
    'MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA','NR','NP',
    'NL','NC','NZ','NI','NE','NG','NU','NF','MP','NO','OM','PK','PW',
    'PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','RE','RO',
    'RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA',
    'SN','RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','GS','SS',
    'ES','LK','SD','SR','SJ','SZ','SE','CH','SY','TW','TJ','TZ','TH',
    'TL','TG','TK','TO','TT','TN','TR','TM','TC','TV','UG','UA','AE',
    'GB','US','UM','UY','UZ','VU','VE','VN','VG','VI','WF','EH','YE',
    'ZM','ZW'
  )

  CountryCode = Types::Strict::String.constrained(included_in: CountryCodes.values).constructor{|v| v.to_s.upcase[0...2]}

  module Required
    String = Types::Strict::String.with( required: true )
  end

  module Defaulted
    String = Types::Strict::String.default('')
  end

  module Nullable
    String = Types::Strict::String
  end

end

class User < Dry::Types::Struct
  attribute :name, Types::Required::String
  #attribute :something, Types::Nullable::String
  #attribute :something_else, Types::Defaulted::String
  attribute :country_code, Types::CountryCode
end

#p Types::CountryCode['d2sg']

p Types::CountryCodes['SE']

user1 = User.new(name: 'Jane', country_code: 'se')
p user1.to_h
# => {:name=>"Jane", :something=>nil, :something_else=>""}

#user2 = User.new(name: nil)
# => Exception: Dry::Types::StructError: [User.new] :name is missing in Hash input
#p user2.to_h
