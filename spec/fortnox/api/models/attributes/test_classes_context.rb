shared_context 'test classes' do
  using_test_class do
    class Model
      include Virtus.model
    end

    Model.send(:include, described_class)
  end
end
