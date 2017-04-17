RSpec::Matchers.define :validate_true do |instance|
  expect_validate( instance, true )
end

RSpec::Matchers.define :validate_false do |instance|
  expect_validate( instance, false )
end

RSpec::Matchers.define :include_violation_on do |instance, attribute|
  match do
    validate( instance )
    expect( described_class.violations.inspect ).to include( attribute )
  end

  description { "include violation on #{attribute}" }

  failure_message do
    "expected \"#{described_class.violations.inspect}\" to include \"#{attribute}\""
  end
end

private

  def validate( instance )
    described_class.validate( instance )
  end

  def expect_validate( instance, expected )
    match { expect( validate( instance ) ).to eq( expected ) }

    description { "validate #{expected}" }

    failure_message { "expected validator to validate #{expected}" }
  end
