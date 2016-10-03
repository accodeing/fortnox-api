require 'fortnox/api/models/context'

shared_examples_for 'DocumentBase Model' do |row_class, row_attribute, valid_hash|
  it{ is_expected.to require_attribute( :customer_number, valid_hash ) }

  it{ is_expected.to have_sized_string( :address1, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :address2, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :city, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :comments, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :customer_name, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_address1, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_address2, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_city, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_name, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :delivery_zip_code, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :external_invoice_reference1, 80, valid_hash ) }
  it{ is_expected.to have_sized_string( :external_invoice_reference2, 80, valid_hash ) }
  it{ is_expected.to have_sized_string( :external_invoice_reference2, 80, valid_hash ) }
  it{ is_expected.to have_sized_string( :our_reference, 50, valid_hash ) }
  it{ is_expected.to have_sized_string( :phone1, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :phone2, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :remarks, 1024, valid_hash ) }
  it{ is_expected.to have_sized_string( :your_order_number, 30, valid_hash ) }
  it{ is_expected.to have_sized_string( :your_reference, 50, valid_hash ) }
  it{ is_expected.to have_sized_string( :zip_code, 1024, valid_hash ) }

  it{ is_expected.to have_sized_float( :freight, 0.0, 99_999_999_999.0, valid_hash ) }

  it{ is_expected.to have_country_code( :country, valid_hash ) }
  it{ is_expected.to have_country_code( :delivery_country, valid_hash ) }

  it{ is_expected.to have_currency( :currency, valid_hash ) }

  context "when having a(n) #{row_class}" do
    it 'returns the correct object' do
      row = row_class.new
      document_base = described_class.new( customer_number: '123', row_attribute => [row] )
      expect(document_base.send(row_attribute)).to eq([row])
    end
  end

  include_context 'models context'

  include_examples 'having value objects', Fortnox::API::Model::EmailInformation do
    let( :attribute ){ :email_information }
  end
end
