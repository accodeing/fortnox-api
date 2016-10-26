shared_examples_for 'DocumentRow' do |valid_hash|
  # it{ is_expected.to have_account_number( :account_number, valid_hash ) }
  #
  # it{ is_expected.to have_sized_string( :article_number, 50, valid_hash ) }
  # it{ is_expected.to have_sized_string( :description, 50, valid_hash ) }
  #
  # it{ is_expected.to have_sized_float( :delivered_quantity, 0.0, 9_999_999_999_999.0, valid_hash ) }
  it{ is_expected.to have_sized_float( :price, 0.0, 99_999_999_999.0, valid_hash ) }
  #
  # it{ is_expected.to have_discount_type( :discount_type, valid_hash ) }
  #
  # it{ is_expected.to have_sized_integer( :house_work_hours_to_report, 0, 99_999, valid_hash ) }
  #
  # it{ is_expected.to have_house_work_type( :house_work_type, valid_hash ) }
end
