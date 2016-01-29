RSpec::Matchers.define :be_valid do
  expect_validate( true )
end

RSpec::Matchers.define :be_invalid do
  expect_validate( false )
end

RSpec::Matchers.define :include_error_for do |attribute, errors|
  match do
    subject.valid?
    expect( subject.errors.for( attribute ).length ).to eql( errors )
  end

  description{ "include error for #{attribute}" }

  failure_message do
    "expected \"#{subject.errors.inspect}\" to include #{errors} error(s) for \"#{attribute}\""
  end
end

private

  def expect_validate( expected )
    match{ expect( subject.valid? ).to eq( expected ) }

    description{ "validate #{expected}" }

    failure_message{ "expected validator to validate #{expected}" }
  end
