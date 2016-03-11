shared_examples_for '.validate' do |attribute|
  describe '.validate' do
    subject{ validator_class.new }

    context "with invalid #{attribute}" do
      let( :invalid_model ){ model_class.new( attribute => invalid_attribute ) }

      specify{ expect(subject.validate( invalid_model )).to eql( false ) }
    end

    context "with valid #{attribute}" do
      let( :valid_model ){ model_class.new( attribute => valid_attribute  ) }

      specify{ expect( subject.validate( valid_model )).to eql( true ) }
    end
  end
end
