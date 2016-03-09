shared_context 'validator context' do
  shared_examples_for 'behaves like valid' do |attribute, value|
    let( :updated_model ){ valid_model.update( attribute => value ) }

    it{ is_expected.to be_valid( updated_model ) }
  end

  shared_examples_for 'behaves like invalid' do |attribute, value, error_type|
    let( :updated_model ){ valid_model.update( attribute => value ) }

    it{ is_expected.to be_invalid( updated_model ) }
    it{ is_expected.to include_error_for( updated_model, attribute, error_type ) }
  end
  shared_examples_for 'invalid' do |attribute, values, error_type|
    values.each do |value|
      context "when #{attribute} set to #{value}" do
        include_examples 'behaves like invalid', attribute, value, error_type
      end
    end
  end

  shared_examples_for 'valid' do |attribute, values|
    values.each do |value|
      context "when #{attribute} set to #{value}" do
        include_examples 'behaves like valid', attribute, value
      end
    end
  end

  shared_examples_for 'validates length of string' do |attribute, length|
    context "with #{attribute} set to string with" do
      context "length 0 (empty string)" do
        include_examples 'behaves like valid', attribute, ''
      end

      context "length 1" do
        include_examples 'behaves like valid', attribute, 'a'
      end
      context "max length (#{length} chars)" do
        include_examples 'behaves like valid', attribute, 'a' * length
      end

      context "max length + 1 (#{length + 1})" do
        include_examples 'behaves like invalid', attribute, 'a' * (length + 1), :length
      end
    end
  end

  shared_examples_for 'validates inclusion of number' do |attribute, min_value, max_value|
    context "with #{attribute} set to" do
      context "minimum value (#{min_value})" do
        include_examples 'behaves like valid', attribute, min_value
      end

      context "maximum value (#{max_value})" do
        include_examples 'behaves like valid', attribute, max_value
      end

      context "too small value (#{min_value - 1})" do
        include_examples 'behaves like invalid', attribute, min_value - 1, :inclusion
      end

      context "too big value (#{max_value + 1})" do
        include_examples 'behaves like invalid', attribute, max_value + 1, :inclusion
      end
    end
  end

  shared_examples_for 'validates inclusion of string' do |attribute, valid_strings|
    context "with #{attribute} set to" do
      valid_strings.each do |valid_string|
        context "\"#{valid_string}\"" do
          include_examples 'behaves like valid', attribute, valid_string
        end
      end

      context 'a nonsense string' do
        # Try first valid string and append nonsense
        include_examples 'behaves like invalid',
                         attribute,
                         valid_strings.first + '123nonsense123',
                         :inclusion
      end
    end
  end

  shared_examples_for 'required attributes' do |model_class|
    context 'with required attributes' do
      it{ is_expected.to be_valid( valid_model ) }
    end

    context 'without required attributes' do
      it{ is_expected.to_not be_valid( model_class.new ) }
    end
  end
end
