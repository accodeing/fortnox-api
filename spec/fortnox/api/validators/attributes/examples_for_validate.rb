shared_examples_for '.validate' do |attribute, model_class, validator_class|
  using_test_classes do
    class Model < Fortnox::API::Model::Base
    end
    Model.send( :include, model_class )

    class Validator < Fortnox::API::Validator::Base
    end
    Validator.send( :include, validator_class )
  end

  describe '.validate' do
    subject{ Validator.new }

    context "with invalid #{attribute}" do
      let( :invalid_model ){ Model.new( attribute => invalid_attribute ) }

      specify{ expect(subject.validate( invalid_model )).to eql( false ) }
    end

    context "with valid #{attribute}" do
      let( :valid_model ){ Model.new( attribute => valid_attribute  ) }

      specify{ expect( subject.validate( valid_model )).to eql( true ) }
    end
  end
end
