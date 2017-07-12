module Fortnox
  module API
    module Types

      module EnumConstructors
        def self.sized( size )
          -> (value){ return nil if value == ''; value.to_s.upcase[0...size] unless value.nil? }
        end

        def self.default
          -> (value){ return nil if value == ''; value.to_s.upcase unless value.nil? }
        end
      end

      DiscountTypes = Types::Strict::String.enum(
        'AMOUNT','PERCENT'
      )
      CURRENT_HOUSE_WORK_TYPES = [
        'CONSTRUCTION','ELECTRICITY','GLASSMETALWORK','GROUNDDRAINAGEWORK',
        'MASONRY','PAINTINGWALLPAPERING','HVAC','CLEANING','TEXTILECLOTHING',
        'SNOWPLOWING','GARDENING','BABYSITTING','OTHERCARE', 'OTHERCOSTS'
      ].freeze
      LEGACY_HOUSE_WORK_TYPES = [ 'COOKING', 'TUTORING' ].freeze
      HouseWorkTypes = Types::Strict::String.enum(
        *(CURRENT_HOUSE_WORK_TYPES + LEGACY_HOUSE_WORK_TYPES)
      )
      CountryCodes = Types::Strict::String.enum(
        'AF','AX','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW','AU',
        'AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT','BO','BQ',
        'BA','BW','BV','BR','IO','BN','BG','BF','BI','CV','KH','CM','CA','KY',
        'CF','TD','CL','CN','CX','CC','CO','KM','CG','CD','CK','CR','CI','HR',
        'CU','CW','CY','CZ','DK','DJ','DM','DO','EC','EG','SV','GQ','ER','EE',
        'ET','FK','FO','FJ','FI','FR','GF','PF','TF','GA','GM','GE','DE','GH',
        'GI','GR','GL','GD','GP','GU','GT','GG','GN','GW','GY','HT','HM','VA',
        'HN','HK','HU','IS','IN','ID','IR','IQ','IE','IM','IL','IT','JM','JP',
        'JE','JO','KZ','KE','KI','KP','KR','KW','KG','LA','LV','LB','LS','LR',
        'LY','LI','LT','LU','MO','MK','MG','MW','MY','MV','ML','MT','MH','MQ',
        'MR','MU','YT','MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA',
        'NR','NP','NL','NC','NZ','NI','NE','NG','NU','NF','MP','NO','OM','PK',
        'PW','PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','RE','RO',
        'RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA','SN',
        'RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','GS','SS','ES','LK',
        'SD','SR','SJ','SZ','SE','CH','SY','TW','TJ','TZ','TH','TL','TG','TK',
        'TO','TT','TN','TR','TM','TC','TV','UG','UA','AE','GB','US','UM','UY',
        'UZ','VU','VE','VN','VG','VI','WF','EH','YE','ZM','ZW'
      )
      Currencies = Types::Strict::String.enum(
        'AED','AFN','ALL','AMD','ANG','AOA','ARS','AUD','AWG','AZN','BAM','BBD',
        'BDT','BGN','BHD','BIF','BMD','BND','BOB','BOV','BRL','BSD','BTN','BWP',
        'BYR','BZD','CAD','CDF','CHE','CHF','CHW','CLF','CLP','CNY','COP','COU',
        'CRC','CUP','CVE','CZK','DJF','DKK','DOP','DZD','EGP','ERN','ETB','EUR',
        'FJD','FKP','GBP','GEL','GHS','GIP','GMD','GNF','GTQ','GYD','HKD','HNL',
        'HRK','HTG','HUF','IDR','ILS','INR','IQD','IRR','ISK','JMD','JOD','JPY',
        'KES','KGS','KHR','KUR','KMF','KPW','KRW','KWD','KYD','KZT','LAK','LBP',
        'LKR','LRD','LSL','LYD','MAD','MDL','MGA','MKD','MMK','MNT','MOP','MRO',
        'MUR','MVR','MWK','MXN','MXV','MYR','MZN','NAD','NGN','NIO','NOK','NPR',
        'NZD','OMR','PAB','PEN','PGK','PHP','PKR','PLN','PYG','QAR','RON','RSD',
        'RUB','RWF','SAR','SBD','SCR','SDG','SEK','SGD','SHP','SLL','SOS','SRD',
        'SSP','STD','SYP','SZL','THB','TJS','TMM','TND','TOP','TRY','TTD','TWD',
        'TZS','UAH','UGX','USD','USN','USS','UYU','UZS','VEF','VND','VUV','WST',
        'XAF','XAG','XAU','XBA','XBB','XBC','XBD','XCD','XDR','XFU','XOF','XPD',
        'XPF','XPT','XTS','XXX','YER','ZAR','ZMK','ZWD'
      )
      CustomerTypes = Types::Strict::String.enum(
        'PRIVATE', 'COMPANY'
      )
      VATTypes = Types::Strict::String.enum(
        'SEVAT', 'SEREVERSEDVAT', 'EUREVERSEDVAT', 'EUVAT', 'EXPORT'
      )
      DefaultDeliveryTypeValues = Types::Strict::String.enum(
        'PRINT', 'EMAIL', 'PRINTSERVICE'
      )
      ProjectStatusTypes = Types::Strict::String.enum(
        'NOTSTARTED', 'ONGOING', 'COMPLETED'
      )
    end
  end
end
