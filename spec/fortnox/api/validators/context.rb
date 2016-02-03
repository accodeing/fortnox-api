shared_context 'validator context' do
  shared_examples_for 'invalid' do |attribute, values, error_type|
    values.each do |value|
      context "when #{attribute} set to #{value}" do
        let( :model ){ model_class.new( attribute => value ) }

        it{ is_expected.to be_invalid( model ) }
        it{ is_expected.to include_error_for( model, attribute, error_type ) }
      end
    end
  end

  shared_examples_for 'valid' do |attribute, values|
    values.each do |value|
      context "when #{attribute} set to #{value}" do
        let( :model ){ model_class.new( attribute => value ) }

        it{ is_expected.to be_valid( model ) }
      end
    end
  end
end
