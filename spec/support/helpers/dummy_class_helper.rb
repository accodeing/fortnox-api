module Helpers
  def using_test_classes
    around( :all ) do |example|
      classes_before_examples = Object.constants

      yield

      classes_after_examples = Object.constants
      classes_created_by_block = classes_after_examples - classes_before_examples

      example.run

      classes_created_by_block.each do |klass|
        Object.send(:remove_const, klass)
      end
    end
  end

  alias_method :using_test_class, :using_test_classes
end
