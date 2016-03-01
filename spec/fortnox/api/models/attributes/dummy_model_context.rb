shared_context 'create dummy Model that includes described_class' do
  using_test_class do
    class Model
      include Virtus.model
    end

    Model.send(:include, described_class)
  end
end
