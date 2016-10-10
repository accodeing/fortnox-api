module Helpers
  def clear_registry
  registry_klass = Fortnox::API::Registry.class
  const = 'Registry'
  Fortnox::API.send(:remove_const, const) if Fortnox::API.const_defined?(const)
  Fortnox::API.const_set(const, registry_klass.new)
  end
end
