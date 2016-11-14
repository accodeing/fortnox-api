require 'dry-types'

module Helpers
  def using_test_classes
    around( :all ) do |example|
      classes_before_examples = Object.constants

      save_dry_types_state

      yield

      classes_after_examples = Object.constants
      classes_created_by_block = classes_after_examples - classes_before_examples

      example.run

      clean_up_dry_types

      classes_created_by_block.each do |klass|
        Object.send(:remove_const, klass)
      end
    end
  end

  alias_method :using_test_class, :using_test_classes

private

  def save_dry_types_state
    @types = Dry::Types.container._container.keys
  end

  def clean_up_dry_types
    container = Dry::Types.container._container
    (container.keys - @types).each{ |key| container.delete(key) }
    Dry::Types.instance_variable_set('@type_map', Concurrent::Map.new)
  end

end
