module Matchers
  module Type
    class AttributeMatcher
      def initialize( attribute, valid_hash, attribute_type )
        @attribute = attribute
        @valid_hash = valid_hash.dup
        @attribute_type = attribute_type
        @errors = ''
      end

      def matches? ( klass )
        @klass = klass
      end

      def description
        "have #{ @attribute_type } attribute #{ @attribute.inspect }"
      end

      def failure_message
        "Expected class to have attribute #{ @attribute.inspect } defined as #{ @attribute_type }, "\
        "but got following errors:
        #{ @errors }"
      end

      protected

        def expect_error(msg)
          yield

          @errors << msg
          false # Fail test since expected error not thrown
        rescue Dry::Struct::Error
          # TODO: check if error message is correct
          true
        end

    end
  end
end
