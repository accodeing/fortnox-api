# frozen_string_literal: true

module Fortnox
  class TermsOfPayment < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path 'termsofpayments'
      instance_wrapper 'TermsOfPayment'
      collection_wrapper 'TermsOfPayments'
      scope 'settings'
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', Coercible::String.optional, :read_only

    # Code The code of the term of payment.
    key :code, Sized::String[25], :required

    # Description The description of the term of payment.
    attr :description, Strict::String, :required
  end
end
