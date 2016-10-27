module Matchers
  module Type
    def have_nullable( attribute, valid_value, invalid_value, default_value )
      HaveNullableMatcher.new( attribute, valid_value, invalid_value, default_value )
    end

    class HaveNullableMatcher
      def initialize( attribute, valid_value, invalid_value, default_value )
        @attribute = attribute
        @valid_value = valid_value
        @invalid_value = invalid_value
        @default_value = default_value
        @failure_description = ''
      end

      def matches?( klass )
        @klass = klass

        accepts_nil? && accepts_valid_value? && defaults_invalid_value?
      end

      def description
        "have nullable attribute #{ @attribute.inspect }"
      end

      def failure_message
        "Expected class to have nullable attribute #{ @attribute.inspect }" << @failure_description
      end

      private

        def accepts_nil?
          @klass.new(@attribute => nil)
        end

        def accepts_valid_value?
          model = @klass.new(@attribute => @valid_value)
          model.send(@attribute) == @valid_value
        end

        def defaults_invalid_value?
          model = @klass.new(@attribute => @invalid_value)
          value = model.send(@attribute)
          return true if value == @default_value

          @failure_description << " (Expected #{ @invalid_value.inspect } to default to "\
                                  "#{ @default_value.inspect }), but got #{ value.inspect }"
          false
        end
    end
  end
end
