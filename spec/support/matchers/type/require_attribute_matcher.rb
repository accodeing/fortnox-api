module Matchers
  module Type
    def require_attribute( attribute, attr_type )
      RequireAttributeMatcher.new( attribute, attr_type )
    end

    class RequireAttributeMatcher < Matchers::Shared::RequireAttributeMatcher

      def initialize( attribute, attr_type )
        super( attribute )

        @attr_type = attr_type
        @exception = Dry::Struct::Error
      end

      private

        def raise_error
          @klass.new({})

          false # Fail test since expected error is not thrown
        rescue @exception
          true
        end


        def includes_error_message
          @klass.new({})
        rescue @exception => error
          if error.message == expected_error_message
            return true
          else
            @wrong_error_message = error.message
            return false
          end
        end

        def expected_error_message
          "[#{ @klass }.new] #{ @attribute.inspect } is missing in Hash input"
        end
    end
  end
end
