# frozen_string_literal: true

module Fortnox
  class TermsOfPayment < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path "termsofpayments"
      instance_wrapper "TermsOfPayment"
      collection_wrapper "TermsOfPayments"
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', Nullable::String, :read_only

    # Code The code of the term of payment.
    key :code, Strict::String

    # Description The description of the term of payment.
    attr :description, Strict::String, :required
  end
end
