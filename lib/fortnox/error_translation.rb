# frozen_string_literal: true

module Fortnox
  # Translates rest-easy errors at the gem boundary so callers only see
  # Fortnox-namespaced exceptions. Mixed into Fortnox::Resource both ways —
  # `include` for the instance methods, `extend` for the class-level ones.
  module ErrorTranslation
    private

    def with_translated_errors
      yield
    rescue RestEasy::ConstraintError => e
      raise Fortnox::ConstraintError.new(e.attribute_name, e.value, e.message)
    rescue RestEasy::MissingAttributeError => e
      raise Fortnox::MissingAttributeError, e.attribute_name
    rescue RestEasy::AttributeError => e
      raise Fortnox::AttributeError, e.message
    rescue RestEasy::RequestError => e
      raise Fortnox::RequestError, e.response || e.message
    end
  end
end
