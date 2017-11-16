module Fortnox
  module API
    module Configuration
      def self.with( default_config )
        attrs = default_config.keys

        config_class = Class.new do
          def initialize( configuration )
            configuration.each do |name, value|
              self.public_send( name, value )
            end
          end

          attrs.each do |attr|
            define_method attr do |value|
              instance_variable_set("@#{attr}", value)
            end
          end

          attr_writer *attrs

          def access_token( token )
            token_store({ default: [token] })
          end

          def access_tokens( tokens )
            token_store({ default: tokens })
          end

          def token_store( token_hash )
            @token_store ||= {}
            @token_store = format_hash( token_hash )
          end

        private

          def format_hash( unformatted_hash )
            unformatted_hash.each_with_object({}) do |(key, value), hash|
              new_key = key.to_sym
              new_value = Array( value ).map( &:to_s )
              hash[ new_key ] = new_value
            end
          end

        end

        class_methods = Module.new do
          define_method :config do
            @config ||= config_class.new( default_config )
          end

          def configure(&block)
            config.instance_eval(&block)
          end
        end

        Module.new do
          singleton_class.send :define_method, :included do |host_class|
            host_class.extend class_methods
          end
        end
      end
    end
  end
end
