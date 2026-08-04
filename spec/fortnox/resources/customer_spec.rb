# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Customer, order: :defined do
  let(:vcr_dir) { 'customers' }

  describe '.save' do
    let(:new_model) { described_class.stub(name: 'A value') }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") { described_class.save(new_model) }
    end

    describe 'new' do
      it 'saves with correct name' do
        expect(save_new.model.name).to eq('A value')
      end
    end

    describe 'old (update existing)' do
      let(:existing_model) do
        VCR.use_cassette("#{vcr_dir}/find_new") do
          described_class.find(save_new.model.customer_number)
        end
      end

      let(:updated_model) { existing_model.update(name: 'Updated name') }

      let(:save_old) do
        VCR.use_cassette("#{vcr_dir}/save_old") { described_class.save(updated_model) }
      end

      it 'updates with correct name' do
        expect(save_old.model.name).to eq('Updated name')
      end
    end
  end

  describe '.save with default_delivery_types.invoice set to ELECTRONICINVOICE' do
    # ELECTRONICINVOICE is only possible to set in the Fortnox UI.
    # The before_serialise hook on Customer raises so consumers fail loudly
    # rather than silently losing the value or hitting an API 400.
    # No VCR cassette is recorded for these — the Fortnox sandbox does not let us set the value,
    # and the raise happens client-side before any HTTP request.
    let(:bad_delivery_types) do
      Fortnox::Structs::DefaultDeliveryTypes.new(
        invoice: 'ELECTRONICINVOICE', order: 'PRINT', offer: 'PRINT'
      )
    end

    describe 'on a new record' do
      before { allow(described_class).to receive(:post) }

      let(:new_model) { described_class.stub(name: 'A value', default_delivery_types: bad_delivery_types) }

      it 'raises Fortnox::ConstraintError with attribute_name and value', :aggregate_failures do
        expect { described_class.save(new_model) }.to raise_error(Fortnox::ConstraintError) do |error|
          expect(error.attribute_name).to eq(:default_delivery_types)
          expect(error.value).to eq('ELECTRONICINVOICE')
        end
        expect(described_class).not_to have_received(:post)
      end
    end

    describe 'on a persisted record updated to ELECTRONICINVOICE' do
      before { allow(described_class).to receive(:put) }

      let(:updated) do
        persisted = VCR.use_cassette("#{vcr_dir}/find_by_id") { described_class.find('1') }
        persisted.update(default_delivery_types: bad_delivery_types)
      end

      it 'raises Fortnox::ConstraintError and issues no PUT', :aggregate_failures do
        expect { described_class.save(updated) }.to raise_error(Fortnox::ConstraintError) do |error|
          expect(error.attribute_name).to eq(:default_delivery_types)
          expect(error.value).to eq('ELECTRONICINVOICE')
        end
        expect(described_class).not_to have_received(:put)
      end
    end
  end

  describe '#serialise with OrganisationNumber and an active e-fakturakoppling' do
    # Fortnox refuses to edit OrganisationNumber once a customer has an active
    # e-fakturakoppling. Therefore we must drop it from the update payload.
    # Note that we can't create such a customer in the sandbox since we can't
    # create a e-fakturakoppling there.
    def persisted_customer(invoice_delivery_type:)
      described_class.parse(
        'Customer' => {
          'CustomerNumber' => '1',
          'Name' => 'Acme',
          'OrganisationNumber' => '556036-0793',
          'DefaultDeliveryTypes' => { 'Invoice' => invoice_delivery_type, 'Order' => 'PRINT', 'Offer' => 'PRINT' }
        }
      )
    end

    context 'when e-faktura is active' do
      let(:persisted) { persisted_customer(invoice_delivery_type: 'ELECTRONICINVOICE') }
      let(:updated) { persisted.update(name: 'New name', organisation_number: '556036-0793') }

      it 'drops OrganisationNumber but keeps other changed fields', :aggregate_failures do
        body = updated.serialise.fetch('Customer')

        expect(body).not_to have_key('OrganisationNumber')
        expect(body).to include('Name' => 'New name')
      end
    end

    context 'when e-faktura is not active' do
      let(:persisted) { persisted_customer(invoice_delivery_type: 'PRINT') }
      let(:updated) { persisted.update(name: 'New name', organisation_number: '556677-8899') }

      it 'keeps OrganisationNumber in the update payload' do
        body = updated.serialise.fetch('Customer')

        expect(body).to include('OrganisationNumber' => '556677-8899')
      end
    end

    context 'when the record is new and e-faktura is not active' do
      let(:new_model) { described_class.stub(name: 'Acme', organisation_number: '556677-8899') }

      it 'keeps OrganisationNumber (the drop only applies to updates)' do
        body = new_model.serialise.fetch('Customer')

        expect(body).to include('OrganisationNumber' => '556677-8899')
      end
    end

    context 'when the record is new and e-faktura is active' do # rubocop:disable RSpec/EmptyExampleGroup
      # Unreachable, documented for completeness: a new record can never have
      # an active e-fakturakoppling because ELECTRONICINVOICE can only be set
      # from the Fortnox UI.
    end
  end

  describe 'resetting comments in Fortnox' do
    # Fortnox silently ignores empty strings in update payloads — a field can
    # only be cleared with an explicit null. Clearing Customer#comments with
    # '' therefore left the old comment intact in Fortnox. Both reset
    # spellings go out as null ('' coerces to nil at the type level); the
    # cassettes prove Fortnox actually clears the value when sent null.
    # The cassettes' json_body matching also pins the outgoing PUT body.
    let(:persisted_customer) do
      VCR.use_cassette("#{vcr_dir}/save_new_with_comments") do
        described_class.save(
          described_class.stub(name: 'Customer with comment', comments: 'A comment to be reset')
        )
      end
    end

    before { persisted_customer }

    context 'when setting value to nil' do
      subject(:comments) { updated_persisted_customer.model.comments }

      let(:updated_persisted_customer) do
        VCR.use_cassette("#{vcr_dir}/save_old_with_nil_comments") do
          described_class.save(persisted_customer.update(comments: nil))
        end
      end

      it 'resets the value' do
        expect(comments).to be_nil
      end
    end

    context 'when setting value to empty string' do
      subject(:comments) { updated_persisted_customer.model.comments }

      let(:updated_persisted_customer) do
        VCR.use_cassette("#{vcr_dir}/save_old_with_empty_comments") do
          described_class.save(persisted_customer.update(comments: ''))
        end
      end

      it 'resets the value' do
        expect(comments).to be_nil
      end
    end
  end

  describe '.save with a required attribute reset to an empty string' do
    # Clearing a required field is invalid: Fortnox rejects Name:null with
    # 400 "Kundnamn kan inte vara tomt" and silently ignores Name:"" (both
    # verified against the sandbox). With '' coercing to nil, the invalid
    # operation fails loudly client-side instead of being silently ignored.
    before { allow(described_class).to receive(:put) }

    let(:updated) do
      persisted = described_class.parse('Customer' => { 'CustomerNumber' => '1', 'Name' => 'Acme' })
      persisted.update(name: '')
    end

    it 'raises Fortnox::MissingAttributeError and issues no PUT', :aggregate_failures do
      expect { described_class.save(updated) }.to raise_error(Fortnox::MissingAttributeError)
      expect(described_class).not_to have_received(:put)
    end
  end

  describe '.save with a persisted, unchanged record' do
    # A record loaded via .find is persisted (meta.new? == false) with an
    # empty change set. Saving it without calling .update must not PUT the
    # whole record back — that would re-send every untouched attribute and
    # risk clobbering changes made elsewhere since it was loaded.
    let(:persisted) do
      VCR.use_cassette("#{vcr_dir}/find_by_id") { described_class.find('1') }
    end

    it 'issues no write request', :aggregate_failures do
      allow(described_class).to receive(:put)
      allow(described_class).to receive(:post)
      described_class.save(persisted)
      expect(described_class).not_to have_received(:put)
      expect(described_class).not_to have_received(:post)
    end

    it 'returns the same instance' do
      expect(described_class.save(persisted)).to equal(persisted)
    end
  end

  describe '.save with specially named attribute' do
    let(:new_model) { described_class.stub(name: 'Test customer', email_invoice_cc: 'test@example.com') }
    let(:save_model) do
      VCR.use_cassette("#{vcr_dir}/save_with_specially_named_attribute") do
        described_class.save(new_model)
      end
    end

    it 'does not raise any errors' do
      expect { save_model }.not_to raise_error
    end

    it 'returns the correct value' do
      expect(save_model.model.email_invoice_cc).to eq('test@example.com')
    end
  end

  describe '.save with all writable attributes' do
    # NOTE: Bump customer_number when re-recording VCR cassettes — Fortnox rejects duplicates
    let(:fully_populated_customer_number) { '9009' }
    let(:writable_attributes) do
      {
        customer_number: fully_populated_customer_number,
        active: true,
        address1: 'Storgatan 1',
        address2: 'Box 100',
        city: 'Stockholm',
        comments: 'A fully populated customer',
        cost_center: '1',
        country_code: 'SE',
        currency: 'SEK',
        default_delivery_types: Fortnox::Structs::DefaultDeliveryTypes.new(
          invoice: 'PRINT', order: 'PRINT', offer: 'PRINT'
        ),
        default_templates: Fortnox::Structs::DefaultTemplates.new(
          order: 'DEFAULTTEMPLATE',
          offer: 'DEFAULTTEMPLATE',
          invoice: 'DEFAULTTEMPLATE',
          cash_invoice: 'DEFAULTTEMPLATE'
        ),
        delivery_address1: 'Leveransvägen 2',
        delivery_address2: 'Port B',
        delivery_city: 'Göteborg',
        delivery_country_code: 'SE',
        delivery_fax: '+46 8 0000000',
        delivery_name: 'Delivery Recipient',
        delivery_phone1: '+46 8 1111111',
        delivery_phone2: '+46 8 2222222',
        delivery_zip_code: '41100',
        email: 'customer@example.com',
        email_invoice: 'invoice@example.com',
        email_invoice_bcc: 'invoice-bcc@example.com',
        email_invoice_cc: 'invoice-cc@example.com',
        email_offer: 'offer@example.com',
        email_offer_bcc: 'offer-bcc@example.com',
        email_offer_cc: 'offer-cc@example.com',
        email_order: 'order@example.com',
        email_order_bcc: 'order-bcc@example.com',
        email_order_cc: 'order-cc@example.com',
        external_reference: 'EXT-001',
        fax: '+46 8 3333333',
        gln: '1234567890123',
        gln_delivery: '3210987654321',
        invoice_administration_fee: 50.0,
        invoice_discount: 10.0,
        invoice_freight: 25.0,
        invoice_remark: 'Standard invoice remark',
        name: 'Fully Populated Customer',
        organisation_number: '556677-8899',
        our_reference: 'Bilbo',
        phone1: '+46 8 4444444',
        phone2: '+46 8 5555555',
        price_list: 'A',
        project: '1',
        sales_account: 3001,
        show_price_vat_included: true,
        terms_of_delivery: 'FVL',
        terms_of_payment: '30',
        type: 'COMPANY',
        vat_number: 'SE556677889901',
        vat_type: 'SEVAT',
        visiting_address: 'Besöksgatan 3',
        visiting_city: 'Malmö',
        visiting_country_code: 'SE',
        visiting_zip_code: '21100',
        way_of_delivery: 'P',
        www: 'https://example.com',
        your_reference: 'Frodo',
        zip_code: '11122'
      }
    end
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new_fully_populated") do
        described_class.save(described_class.stub(**writable_attributes))
      end
    end

    it 'round-trips every writable attribute', :aggregate_failures do
      writable_attributes.each do |attribute, value|
        expect(save_new.model.send(attribute)).to eq(value)
      end
    end
  end

  describe '.all' do
    let(:response) do
      VCR.use_cassette("#{vcr_dir}/all") { described_class.all }
    end

    it 'returns a non-empty collection' do
      expect(response).not_to be_empty
    end

    it 'returns correct class' do
      expect(response.first).to be_a(described_class)
    end

    it 'exposes pagination metadata from MetaInformation', :aggregate_failures do
      expect(response).to be_a(Fortnox::Collection)
      expect(response.total).to be_a(Integer).and(be > 0)
      expect(response.pages).to be_a(Integer).and(be >= 1)
      expect(response.current_page).to eq(1)
    end
  end

  describe '.find' do
    describe 'by id' do
      let(:returned_object) do
        VCR.use_cassette("#{vcr_dir}/find_by_id") { described_class.find('1') }
      end

      context 'when found' do
        it 'is saved' do
          expect(returned_object.meta).to be_saved
        end

        it 'is not new' do
          expect(returned_object.meta).not_to be_new
        end

        it 'returns correct class' do
          expect(returned_object).to be_a(described_class)
        end

        it 'returns correct unique id' do
          expect(returned_object.unique_id).to eq '1'
        end
      end

      context 'when not found' do
        let(:find_with_non_existing_id) do
          VCR.use_cassette("#{vcr_dir}/find_failure") { described_class.find('123456789') }
        end

        it 'raises an error' do
          expect { find_with_non_existing_id }.to raise_error(Fortnox::RequestError)
        end
      end
    end

    describe 'by hash' do
      context 'when found' do
        context 'with single parameter' do
          let(:returned_array) do
            VCR.use_cassette("#{vcr_dir}/single_param_find_by_hash") do
              described_class.find(city: 'New York')
            end
          end

          it 'returns matching customers', :aggregate_failures do
            expect(returned_array).not_to be_empty
            expect(returned_array).to all(satisfy { |result| result.model.city == 'New York' })
          end
        end

        context 'with multiple parameters' do
          let(:returned_array) do
            VCR.use_cassette("#{vcr_dir}/multi_param_find_by_hash") do
              described_class.find(city: 'New York', zipcode: '10001')
            end
          end

          it 'returns matching customers', :aggregate_failures do
            expect(returned_array).not_to be_empty
            expect(returned_array).to all(satisfy { |result|
              result.model.city == 'New York' && result.model.zip_code == '10001'
            })
          end
        end
      end

      context 'when not found' do
        let(:find_failure) do
          VCR.use_cassette("#{vcr_dir}/find_by_hash_failure") do
            described_class.find(city: 'Not Found')
          end
        end

        it 'returns an empty collection' do
          expect(find_failure).to be_empty
        end
      end
    end
  end

  describe '.search' do
    context 'with no matches' do
      subject do
        VCR.use_cassette("#{vcr_dir}/search_miss") do
          described_class.search(name: 'nothing')
        end
      end

      it { is_expected.to be_a(Fortnox::Collection) }
      it { is_expected.to be_empty }
    end

    context 'with matches' do
      subject(:results) do
        VCR.use_cassette("#{vcr_dir}/search_by_name") do
          described_class.search(name: 'Test')
        end
      end

      it { is_expected.to be_a(Fortnox::Collection) }

      it 'returns matching customers', :aggregate_failures do
        expect(results).not_to be_empty
        expect(results).to all(satisfy { |result| result.model.name.include?('Test') })
      end
    end

    context 'with special characters' do
      let(:search_with_special_char) do
        VCR.use_cassette("#{vcr_dir}/search_with_special_char") do
          described_class.search(name: 'special char å')
        end
      end

      it 'does not raise an error' do
        expect { search_with_special_char }.not_to raise_error
      end
    end
  end

  describe 'country reference' do
    describe "with valid country code 'SE'" do
      let(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_country_code_SE") do
          described_class.save(
            described_class.stub(name: 'Customer with Swedish country code', country_code: 'SE')
          )
        end
      end

      it 'has correct country code' do
        expect(customer.model.country_code).to eq('SE')
      end

      it 'has correct country' do
        expect(customer.model.country).to eq('Sverige')
      end
    end
  end

  describe 'parsing a blank SalesAccount' do
    let(:body) { { 'CustomerNumber' => '1', 'Name' => 'X', 'SalesAccount' => '' } }

    it 'coerces "" to nil on the AccountNumber type' do
      parsed = described_class.send(:parse, 'Customer' => body)
      expect(parsed.sales_account).to be_nil
    end
  end

  describe 'parsing a blank numeric attribute' do
    let(:body) { { 'CustomerNumber' => '1', 'Name' => 'X', 'InvoiceDiscount' => '' } }

    it 'coerces "" to nil on the Sized::Float type' do
      parsed = described_class.send(:parse, 'Customer' => body)
      expect(parsed.invoice_discount).to be_nil
    end
  end

  describe 'sales account' do
    context 'when saving a Customer with a Sales Account set' do
      let(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_sales_account") do
          described_class.save(
            described_class.stub(name: 'Customer with Sales Account', sales_account: '3001')
          )
        end
      end

      context 'when fetching that Customer' do
        let(:fetched_customer) do
          VCR.use_cassette("#{vcr_dir}/find_with_sales_account") do
            described_class.find(customer.model.customer_number)
          end
        end

        it 'has correct sales account' do
          expect(fetched_customer.model.sales_account).to eq(3001)
        end
      end
    end
  end

  describe 'internationalized domain name email' do
    context 'when saving a Customer with an IDN email address' do
      let(:customer) do
        VCR.use_cassette("#{vcr_dir}/save_new_with_idn_email") do
          described_class.save(
            described_class.stub(name: 'Customer with IDN email', email: 'user@teståäö.se')
          )
        end
      end

      it 'saves the email' do
        expect(customer.model.email).to eq('user@teståäö.se')
      end
    end
  end
end
