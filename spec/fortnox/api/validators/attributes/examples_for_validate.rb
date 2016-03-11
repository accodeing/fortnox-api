shared_examples_for '.validate' do |attribute|
  using_test_classes do
    const_name = attribute.to_s.split('_').map(&:capitalize).join

    class Model < Fortnox::API::Model::Base
    end
    Model.send( :include, Fortnox::API::Model::Attribute. const_get( const_name ) )

    class Validator < Fortnox::API::Validator::Base
    end
    Validator.send( :include, Fortnox::API::Validator::Attribute. const_get( const_name ) )
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
