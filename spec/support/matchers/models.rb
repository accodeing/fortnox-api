RSpec::Matchers.define :upcase_lower_case_for do |attribute, value|
  match do
    subject = new_model( attribute, value )
    expect( subject.send( attribute ) ).to eql( value.upcase )
  end

  failure_message do
    "expected #{subject.class} to upcase #{value} case for :#{attribute}"
  end
end

RSpec::Matchers.define :return_nil_for_invalid_types do |attribute, value|
  match do
    subject = new_model( attribute, value )
    expect( subject.send( attribute ) ).to eql( nil )
  end

  failure_message do
    "expected #{subject.class} to return nil when :#{attribute} is set to #{value}"
  end
end

  private

    def new_model( attribute, value )
      described_class.new( attribute => value )
    end
