# frozen_string_literal: true

require_relative 'base'
require_relative '../models/terms_of_payment'
require_relative '../mappers/terms_of_payment'

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
