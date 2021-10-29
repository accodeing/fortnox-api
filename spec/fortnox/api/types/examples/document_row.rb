# frozen_string_literal: true

shared_examples_for 'DocumentRow' do |valid_hash|
  it { is_expected.to have_account_number(:account_number, valid_hash) }

  it { is_expected.to have_sized_string(:article_number, 50, valid_hash) }
  it { is_expected.to have_sized_string(:description, 50, valid_hash) }

  it { is_expected.to have_discount_type(:discount_type, valid_hash) }

  it { is_expected.to have_sized_integer(:housework_hours_to_report, 0, 99_999, valid_hash) }

  it { is_expected.to have_housework_type(:housework_type, valid_hash) }

  it { is_expected.to have_sized_float(:price, -9_999_999_999, 99_999_999_999.9, valid_hash) }

  it do # rubocop:disable RSpec/ExampleLength
    is_expected.to have_sized_float(
      :delivered_quantity,
      -9_999_999_999_999.9,
      9_999_999_999_999.9,
      valid_hash
    )
  end
end
