# frozen_string_literal: true

module Fortnox
  module API
    module Mapper
      module CanonicalNameSym
        def canonical_name_sym(*values)
          klass = if values.empty?
                    self
                  elsif values.first.is_a? Class
                    values.first
                  else
                    values.first.class
                  end

          if RUBY_VERSION >= '2.4'
            # Ruby 2.4 unifies Fixnum and Bignum into Integer
            # Stringify to avoid warnings on newer Ruby versions
            klass = Integer if %w[Bignum Fixnum].include?(klass.to_s)
          end

          klass.name.split('::').last.downcase.to_sym
        end
      end
    end
  end
end
