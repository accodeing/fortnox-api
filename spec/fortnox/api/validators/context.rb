shared_context 'validator context' do
  shared_examples_for 'invalid' do |attribute, values, error_type|
    values.each do |value|
      context "when #{attribute} set to #{value}" do
        let( :updated_model ){ valid_model.update( attribute => value ) }

        it{ is_expected.to be_invalid( updated_model ) }
        it{ is_expected.to include_error_for( updated_model, attribute, error_type ) }
      end
    end
  end

  shared_examples_for 'valid' do |attribute, values|
    values.each do |value|
      context "when #{attribute} set to #{value}" do
        let( :updated_model ){ valid_model.update( attribute => value ) }

        it{ is_expected.to be_valid( updated_model ) }
      end
    end
  end

  shared_examples_for 'validates length of string' do |attribute, length|
    context "with #{attribute} set to string with" do
      context "length 0 (empty string)" do
        let( :updated_model ){ valid_model.update( attribute => '' ) }

        it{ is_expected.to be_valid( updated_model ) }
      end

      context "length 1" do
        let( :updated_model ){ valid_model.update( attribute => 'a' ) }

        it{ is_expected.to be_valid( updated_model ) }
      end
      context "max length (#{length} chars)" do
        let( :updated_model ){ valid_model.update( attribute => 'a' * length ) }

        it{ is_expected.to be_valid( updated_model ) }
      end

      context "max length + 1 (#{length + 1})" do
        let( :updated_model ){ valid_model.update( attribute => 'a' * (length + 1) ) }

        it{ is_expected.to be_invalid( updated_model ) }
        it{ is_expected.to include_error_for( updated_model, attribute, :length ) }
      end
    end
  end
end
