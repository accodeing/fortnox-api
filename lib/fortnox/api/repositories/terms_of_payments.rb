require "fortnox/api/repositories/base"
require "fortnox/api/models/terms_of_payments"
require "fortnox/api/mappers/terms_of_payments"

module Fortnox
  module API
    module Repository
      class TermsOfPayments < Base
        MODEL = Model::TermsOfPayments
        MAPPER = Mapper::TermsOfPayments
        URI = '/termsofpayments/'.freeze
      end
    end
  end
end
