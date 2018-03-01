# frozen_string_literal: true

require 'fortnox/api/repositories/base'
require 'fortnox/api/models/terms_of_payment'
require 'fortnox/api/mappers/terms_of_payment'

module Fortnox
  module API
    module Repository
      class TermsOfPayment < Base
        MODEL = Model::TermsOfPayment
        MAPPER = Mapper::TermsOfPayment
        URI = '/termsofpayments/'
      end
    end
  end
end
