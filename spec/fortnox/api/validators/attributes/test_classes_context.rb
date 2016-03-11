shared_context 'Model and Validator classes' do |model_class, validator_class|
  using_test_classes do
    class Model < Fortnox::API::Model::Base
    end
    Model.send( :include, model_class )

    class Validator < Fortnox::API::Validator::Base
    end
    Validator.send( :include, validator_class )
  end
end
