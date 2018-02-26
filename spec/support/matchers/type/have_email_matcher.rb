# frozen_string_literal: true

module Matchers
  module Type
    def have_email(attribute, valid_hash = {})
      HaveEmailMatcher.new(attribute, valid_hash)
    end

    class HaveEmailMatcher < TypeMatcher
      def initialize(attribute, valid_hash)
        super(attribute, valid_hash, 'email', 'valid@email.com', 'invalid@email_without_top_domain')
        @expected_error = "Exception missing for invalid value #{@invalid_value.inspect}"
        @expected_type = Fortnox::API::Types::Email
      end

      private

      def expected_type?
        @actual_type = @klass.schema[@attribute]
        @actual_type == Fortnox::API::Types::Email
      end
    end
  end
end
