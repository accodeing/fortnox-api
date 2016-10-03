module Matchers
  module Model
    def have_email( attribute, valid_hash )
      HaveEmailMatcher.new( attribute, valid_hash )
    end

    class HaveEmailMatcher < AttributeMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'email' )
      end

      def matches?( klass )
        super

        correct_type? && rejects_invalid_value? && accepts_valid_value?
      end

      private

        def correct_type?
          actual_type = @klass.schema[@attribute]
          if actual_type == Fortnox::API::Types::Email
            return true
          else
            @errors << "Attribute #{@attribute.inspect} was expected to be of type #{@attribute_type}, but was #{actual_type}"
            return false
          end

        end

        def rejects_invalid_value?
          invalid_value = 'invalid@email_without_top_domain'
          expect_error("Exception missing for invalid value #{invalid_value.inspect}") do
            @klass.new( @valid_hash.merge( @attribute => invalid_value ) )
          end
        end

        def accepts_valid_value?
          @klass.new( @valid_hash.merge( @attribute => 'valid@email.com' ) )
        end
    end
  end
end
