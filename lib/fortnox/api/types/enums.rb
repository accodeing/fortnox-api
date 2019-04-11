# frozen_string_literal: true

module Fortnox
  module API
    module Types # rubocop:disable Metrics/ModuleLength
      module EnumConstructors
        def self.sized(size)
          lambda do |value|
            return nil if value == ''
            value.to_s.upcase[0...size] unless value.nil?
          end
        end

        def self.default
          lambda do |value|
            return nil if value == ''
            value.to_s.upcase unless value.nil?
          end
        end
      end

      ArticleTypes = Types::Strict::String.enum(
        'SERVICE', 'STOCK'
      )
      DiscountTypes = Types::Strict::String.enum(
        'AMOUNT', 'PERCENT'
      )
      CURRENT_HOUSEWORK_TYPES = %w[
        CONSTRUCTION ELECTRICITY GLASSMETALWORK GROUNDDRAINAGEWORK
        MASONRY PAINTINGWALLPAPERING HVAC MAJORAPPLIANCEREPAIR
        MOVINGSERVICES ITSERVICES CLEANING TEXTILECLOTHING
        SNOWPLOWING GARDENING BABYSITTING OTHERCARE OTHERCOSTS
      ].freeze
      LEGACY_HOUSEWORK_TYPES = %w[COOKING TUTORING].freeze
      HouseworkTypes = Types::Strict::String.enum(
        *(CURRENT_HOUSEWORK_TYPES + LEGACY_HOUSEWORK_TYPES)
      )
      COUNTRY_NAMES_IN_ENGLISH = [
        'Afghanistan', 'Albania', 'Algeria', 'Virgin Islands U.S.', 'American Samoa', 'Andorra', 'Angola', 'Anguilla',
        'Antarctica', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Aruba', 'Australia', 'Azerbaijan', 'Bahamas',
        'Bahrain', 'Bangladesh', 'Barbados', 'Belgium', 'Belize', 'Benin', 'Bermuda', 'Bhutan',
        'Bolivia, Plurinational State of', 'Bosnia and Herzegovina', 'Botswana', 'Bouvet Island', 'Brazil',
        'Virgin Islands British', 'British Indian Ocean Territory', 'Brunei Darussalam', 'Bulgaria', 'Burkina Faso',
        'Myanmar', 'Burundi', 'Cayman Islands', 'Central African Republic', 'Chile', 'Colombia', 'Cook Islands',
        'Costa Rica', 'Cyprus', 'Denmark', 'Congo, the Democratic Republic of the', 'Djibouti', 'Dominica',
        'Dominican Republic', 'Ecuador', 'Egypt', 'Equatorial Guinea', 'El Salvador', "Côte d'Ivoire", 'Eritrea',
        'Estonia', 'Ethiopia', 'Falkland Islands (Malvinas)', 'Fiji', 'Philippines', 'Finland', 'France Metropolitan',
        'France', 'French Guiana', 'French Polynesia', 'French Southern Territories', 'Faroe Islands',
        'United Arab Emirates', 'Gabon', 'Gambia', 'Georgia', 'Ghana', 'Gibraltar', 'Greece', 'Grenada', 'Greenland',
        'Guadeloupe', 'Guam', 'Guatemala', 'Guernsey', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti',
        'Heard Island and McDonald Islands', 'Honduras', 'Hong Kong', 'India', 'Indonesia', 'Iraq',
        'Iran, Islamic Republic of', 'Ireland', 'Iceland', 'Isle of Man', 'Israel', 'Italy', 'Jamaica', 'Japan',
        'Yemen', 'Jersey', 'Jordan', 'Christmas Island', 'Cambodia', 'Cameroon', 'Canada', 'Cape Verde', 'Kazakhstan',
        'Kenya', 'China', 'Kyrgyzstan', 'Kiribati', 'Cocos (Keeling) Islands', 'Comoros', 'Congo', 'Croatia', 'Cuba',
        'Kuwait', "Lao People's Democratic Republic", 'Lesotho', 'Latvia', 'Lebanon', 'Liberia', 'Libya',
        'Liechtenstein', 'Lithuania', 'Luxembourg', 'Macao', 'Madagascar', 'Macedonia, the former Yugoslav Republic of',
        'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Morocco', 'Marshall Islands', 'Martinique', 'Mauritania',
        'Mauritius', 'Mayotte', 'Mexico', 'Micronesia, Federated States of', 'Mozambique',
        'Moldova, Republic of Monaco', 'Mongolia', 'Montenegro', 'Montserrat', 'Namibia', 'Nauru', 'Netherlands',
        'Netherlands Antilles', 'Nepal', 'Nicaragua', 'Niger', 'Nigeria', 'Niue',
        "Korea, Democratic People's Republic of", 'Northern Mariana Islands', 'Norfolk Island', 'Norway',
        'New Caledonia', 'New Zealand', 'Oman', 'Pakistan', 'Palau', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru',
        'Pitcairn', 'Poland', 'Portugal', 'Puerto Rico', 'Qatar', 'Réunion', 'Romania', 'Rwanda',
        'Russian Federation', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines',
        'Saint Barthélemy', 'Saint Pierre and Miquelon', 'Solomon Islands', 'Samoa', 'San Marino',
        'Saint Helena Ascension and Tristan da Cunha', 'Sao Tome and Principe', 'Saudi Arabia', 'Switzerland',
        'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Somalia', 'Spain',
        'Sri Lanka', 'United Kingdom', 'Sudan', 'Suriname', 'Svalbard and Jan Mayen', 'Sweden', 'Swaziland',
        'South Africa', 'Korea Republic of', 'Syrian Arab Republic', 'Tajikistan', 'Taiwan Province of China',
        'Tanzania United Republic of', 'Chad', 'Thailand', 'Czech Republic', 'Togo', 'Tokelau', 'Tonga',
        'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Turks and Caicos Islands', 'Tuvalu', 'Germany',
        'Uganda', 'Ukraine', 'Hungary', 'Uruguay', 'United States', 'United States Minor Outlying Islands',
        'Uzbekistan', 'Vanuatu', 'Holy See (Vatican City State)', 'Venezuela, Bolivarian Republic of Viet Nam',
        'Belarus', 'Western Sahara', 'Wallis and Futuna', 'Zambia', 'Zimbabwe', 'Åland Islands', 'Austria',
        'Timor-Leste'
      ].freeze
      COUNTRY_NAMES_IN_SWEDISH = [
        'Afghanistan', 'Albanien', 'Algeriet', 'Amerikanska Jungfruöarna', 'Amerikanska Samoa', 'Andorra', 'Angola',
        'Anguilla', 'Antarktis', 'Antigua och Barbuda', 'Argentina', 'Armenien', 'Aruba', 'Australien', 'Azerbajdzjan',
        'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belgien', 'Belize', 'Benin', 'Bermuda', 'Bhutan', 'Bolivia',
        'Bosnien och Hercegovina', 'Botswana', 'Bouvetön', 'Brasilien', 'Brittiska Jungfruöarna',
        'Brittiska territoriet i Indiska Oceanen', 'Brunei', 'Bulgarien', 'Burkina Faso', 'Burma', 'Burundi',
        'Caymanöarna', 'Centralafrikanska republiken', 'Chile', 'Colombia', 'Cooköarna', 'Costa Rica', 'Cypern',
        'Danmark', 'Demokratiska republiken Kongo', 'Djibouti', 'Dominica', 'Dominikanska republiken', 'Ecuador',
        'Egypten', 'Ekvatorialguinea', 'El Salvador', 'Elfenbenskusten', 'Eritrea', 'Estland', 'Etiopien',
        'Falklandsöarna', 'Fiji', 'Filippinerna', 'Finland', 'France métropolitaine (Frankrike europeiska delen)',
        'Frankrike', 'Franska Guyana', 'Franska Polynesien', 'Franska södra territorierna', 'Färöarna',
        'Förenade Arabemiraten', 'Gabon', 'Gambia', 'Georgien', 'Ghana', 'Gibraltar', 'Grekland', 'Grenada',
        'Grönland', 'Guadeloupe', 'Guam', 'Guatemala', 'Guernsey', 'Guinea', 'Guinea Bissau', 'Guyana', 'Haiti',
        'Heard- och McDonaldsöarna', 'Honduras', 'Hongkong', 'Indien', 'Indonesien', 'Irak', 'Iran', 'Irland',
        'Island', 'Isle of Man', 'Israel', 'Italien', 'Jamaica', 'Japan', 'Jemen', 'Jersey', 'Jordanien', 'Julön',
        'Kambodja', 'Kamerun', 'Kanada', 'Kap Verde', 'Kazakstan', 'Kenya', 'Kina', 'Kirgizistan', 'Kiribati',
        'Kokosöarna', 'Komorerna', 'Kongo-Brazzaville', 'Kroatien', 'Kuba', 'Kuwait', ' Laos', 'Lesotho', 'Lettland',
        'Libanon', 'Liberia', 'Libyen', 'Liechtenstein', 'Litauen', 'Luxemburg', 'Macau', 'Madagaskar', 'Makedonien',
        'Malawi', 'Malaysia', 'Maldiverna', 'Mali', 'Malta', 'Marocko', 'Marshallöarna', 'Martinique', 'Mauretanien',
        'Mauritius', 'Mayotte', 'Mexiko', 'Mikronesiska federationen', 'Moçambique', 'Moldavien', 'Monaco',
        'Mongoliet', 'Montenegro', 'Montserrat', 'Namibia', 'Nauru', 'Nederländerna', 'Nederländska Antillerna',
        'Nepal', 'Nicaragua', 'Niger', 'Nigeria', 'Niue', ' Nordkorea', 'Nordmarianerna', 'Norfolkön', 'Norge',
        'Nya Kaledonien', 'Nya Zeeland', 'Oman', 'Pakistan', 'Palau', 'Panama', 'Papua Nya Guinea', 'Paraguay', 'Peru',
        'Pitcairnöarna', 'Polen', 'Portugal', 'Puerto Rico', 'Qatar', 'Réunion', 'Rumänien', 'Rwanda', 'Ryssland',
        'Saint Kitts och Nevis', 'Saint Lucia', 'Saint Vincent och Grenadinerna', 'Saint-Barthélemy',
        'Saint-Pierre och Miquelon', 'Salomonöarna', 'Samoa', 'San Marino', 'Sankta Helena', 'São Tomé och Príncipe',
        'Saudiarabien', 'Schweiz', 'Senegal', 'Serbien', 'Seychellerna', 'Sierra Leone', 'Singapore', 'Slovakien',
        'Slovenien', 'Somalia', 'Spanien', 'Sri Lanka', 'Storbritannien', 'Sudan', 'Surinam', 'Svalbard och Jan Mayen',
        'Sverige', 'Swaziland', 'Sydafrika', 'Sydkorea', 'Syrien', 'Tadzjikistan', 'Taiwan', 'Tanzania', 'Tchad',
        'Thailand', 'Tjeckien', 'Togo', 'Tokelauöarna', 'Tonga', 'Trinidad och Tobago', 'Tunisien', 'Turkiet',
        'Turkmenistan', 'Turks- och Caicosöarna', 'Tuvalu', 'Tyskland', 'Uganda', 'Ukraina', 'Ungern', 'Uruguay',
        'USA', 'USA:s yttre öar', 'Uzbekistan', 'Vanuatu', 'Vatikanstaten', 'Venezuela', 'Vietnam', 'Vitryssland',
        'Västsahara', 'Wallis- och Futunaöarna', 'Zambia', 'Zimbabwe', 'Åland', 'Österrike', 'Östtimor'
      ].freeze
      Countries = Types::Strict::String.enum(
        *(COUNTRY_NAMES_IN_SWEDISH + COUNTRY_NAMES_IN_ENGLISH)
      )
      CountryCodes = Types::Strict::String.enum(
        'AF', 'AX', 'AL', 'DZ', 'AS', 'AD', 'AO', 'AI', 'AQ', 'AG', 'AR', 'AM',
        'AW', 'AU', 'AT', 'AZ', 'BS', 'BH', 'BD', 'BB', 'BY', 'BE', 'BZ', 'BJ',
        'BM', 'BT', 'BO', 'BQ', 'BA', 'BW', 'BV', 'BR', 'IO', 'BN', 'BG', 'BF',
        'BI', 'CV', 'KH', 'CM', 'CA', 'KY', 'CF', 'TD', 'CL', 'CN', 'CX', 'CC',
        'CO', 'KM', 'CG', 'CD', 'CK', 'CR', 'CI', 'HR', 'CU', 'CW', 'CY', 'CZ',
        'DK', 'DJ', 'DM', 'DO', 'EC', 'EG', 'SV', 'GQ', 'ER', 'EE', 'ET', 'FK',
        'FO', 'FJ', 'FI', 'FR', 'GF', 'PF', 'TF', 'GA', 'GM', 'GE', 'DE', 'GH',
        'GI', 'GR', 'GL', 'GD', 'GP', 'GU', 'GT', 'GG', 'GN', 'GW', 'GY', 'HT',
        'HM', 'VA', 'HN', 'HK', 'HU', 'IS', 'IN', 'ID', 'IR', 'IQ', 'IE', 'IM',
        'IL', 'IT', 'JM', 'JP', 'JE', 'JO', 'KZ', 'KE', 'KI', 'KP', 'KR', 'KW',
        'KG', 'LA', 'LV', 'LB', 'LS', 'LR', 'LY', 'LI', 'LT', 'LU', 'MO', 'MK',
        'MG', 'MW', 'MY', 'MV', 'ML', 'MT', 'MH', 'MQ', 'MR', 'MU', 'YT', 'MX',
        'FM', 'MD', 'MC', 'MN', 'ME', 'MS', 'MA', 'MZ', 'MM', 'NA', 'NR', 'NP',
        'NL', 'NC', 'NZ', 'NI', 'NE', 'NG', 'NU', 'NF', 'MP', 'NO', 'OM', 'PK',
        'PW', 'PS', 'PA', 'PG', 'PY', 'PE', 'PH', 'PN', 'PL', 'PT', 'PR', 'QA',
        'RE', 'RO', 'RU', 'RW', 'BL', 'SH', 'KN', 'LC', 'MF', 'PM', 'VC', 'WS',
        'SM', 'ST', 'SA', 'SN', 'RS', 'SC', 'SL', 'SG', 'SX', 'SK', 'SI', 'SB',
        'SO', 'ZA', 'GS', 'SS', 'ES', 'LK', 'SD', 'SR', 'SJ', 'SZ', 'SE', 'CH',
        'SY', 'TW', 'TJ', 'TZ', 'TH', 'TL', 'TG', 'TK', 'TO', 'TT', 'TN', 'TR',
        'TM', 'TC', 'TV', 'UG', 'UA', 'AE', 'GB', 'US', 'UM', 'UY', 'UZ', 'VU',
        'VE', 'VN', 'VG', 'VI', 'WF', 'EH', 'YE', 'ZM', 'ZW'
      )
      Currencies = Types::Strict::String.enum(
        'AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN',
        'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BMD', 'BND', 'BOB', 'BOV',
        'BRL', 'BSD', 'BTN', 'BWP', 'BYR', 'BZD', 'CAD', 'CDF', 'CHE', 'CHF',
        'CHW', 'CLF', 'CLP', 'CNY', 'COP', 'COU', 'CRC', 'CUP', 'CVE', 'CZK',
        'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'FKP',
        'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL',
        'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD',
        'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KUR', 'KMF', 'KPW', 'KRW', 'KWD',
        'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL',
        'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRO', 'MUR', 'MVR', 'MWK', 'MXN',
        'MXV', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR',
        'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD',
        'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SHP', 'SLL',
        'SOS', 'SRD', 'SSP', 'STD', 'SYP', 'SZL', 'THB', 'TJS', 'TMM', 'TND',
        'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'USN', 'USS',
        'UYU', 'UZS', 'VEF', 'VND', 'VUV', 'WST', 'XAF', 'XAG', 'XAU', 'XBA',
        'XBB', 'XBC', 'XBD', 'XCD', 'XDR', 'XFU', 'XOF', 'XPD', 'XPF', 'XPT',
        'XTS', 'XXX', 'YER', 'ZAR', 'ZMK', 'ZWD'
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
