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

          klass.name.split('::').last.downcase.to_sym
        end
      end
    end
  end
end
