require 'spec_helper'
require 'fortnox/api/repositories/base/json_convertion'

describe Fortnox::API::Repository::JSONConvertion do
  describe 'clean_hash' do
    subject{ described_class.clean_hash( hash ) }

    context 'when empty hash given' do
      let(:hash){ {} }

      it 'returns an empty hash' do
        is_expected.to eq( {} )
      end
    end

    context 'when no nil values present' do
      let(:hash){ { a: 'a', b: 'b', c: 'c' } }

      it 'returns equal hash' do
        is_expected.to eq( hash )
      end
    end

    context 'when nil values present' do
      let(:hash){ { a: 'a', b: nil, c: 'c' } }

      it 'returns hash without nil values' do
        is_expected.to eq( a: 'a', c: 'c' )
      end
    end

    context 'when nested hash' do
      context 'with empty hash' do
        let(:hash){ { a: {}, b: 'b', c: {} } }

        it 'returns equal hash' do
          is_expected.to eq( hash )
        end
      end

      context 'without nil values present' do
        let(:hash) do
          {
            a: 'a',
            b: { a: 'a', b: 'b' },
            c: { a: 'a' }
          }
        end

        it 'returns equal hash' do
          is_expected.to eq( hash )
        end
      end

      context 'with nil values present' do
        let(:hash) do
          {
            a: 'a',
            b: { a: 'a', b: nil, c: 'c' },
            c: { a: nil, b: 'b' }
          }
        end

        it 'returns hash without nil values' do
          is_expected.to eq(
            {
              a: 'a',
              b: { a: 'a', c: 'c' },
              c: { b: 'b' }
            }
          )
        end
      end
    end

    context 'when nested array' do
      context 'with empty array' do
        let(:hash){ { a: [], b: 'b', c: [] } }

        it 'returns equal hash' do
          is_expected.to eq( hash )
        end
      end

      context 'without nil values present' do
        let(:hash) do
          {
            a: 'a',
            b: [{ a: 'a' }, { b: 'b' }],
            c: [{ a: 'a' }]
          }
        end

        it 'returns equal hash' do
          is_expected.to eq( hash )
        end
      end
      context 'with nil values present' do
        let(:hash) do
          {
            '1' => '1a',
            '2' => [{ a: '2a' }, { b: nil }, '2c'],
            '3' => [{ a: nil }, { b: '3b' }],
            '4' => [{ a: nil }, { b: nil }]
          }
        end

        it 'returns hash without nil values' do
          is_expected.to eq(
            {
              '1' => '1a',
              '2' => [{ a: '2a' }, {}, '2c'],
              '3' => [{}, { b: '3b' }],
              '4' => [{}, {}]
            }
          )
        end
      end
    end
  end

  describe 'convert_hash_keys_to_json_format' do
    let(:admin_fee) { '22' }
    let(:comments) { 'A comments' }
    let(:customer_number) { '1' }
    let(:edi_info) { 'Some EDI info' }
    let(:ocr) { '9834782497884123'}
    let(:order_row_1_price) { '10' }
    let(:order_row_2_price) { '30' }
    let(:order_row_1_vat) { '2.5' }
    let(:order_row_2_vat) { '150' }
    let(:hash) do
      {
        administration_fee_vat: admin_fee,
        comments: comments,
        customer_number: customer_number,
        edi_information: edi_info,
        invoice_rows: [
          { price: order_row_1_price, vat: order_row_1_vat },
          { price: order_row_2_price, vat: order_row_2_vat }
        ],
        ocr: ocr
      }
    end

    let(:admin_fee_json_key) { "AdministrationFeeVAT" }
    let(:edi_info_json_key) { "EDIInformation" }
    let(:ocr_json_key) { "OCR" }
    let(:vat_json_key) { 'VAT' }
    let(:key_map) do
      {
        administration_fee_vat: admin_fee_json_key,
        edi_information: edi_info_json_key,
        ocr: ocr_json_key,
        order_rows: { vat: vat_json_key }
        # TODO: edi_information: { "EDIGlobalLocationNumber" }
      }
    end

    let(:entity_json_hash) do
      described_class.convert_hash_keys_to_json_format( hash, key_map )
    end

    subject{ entity_json_hash }

    it{ is_expected.to include( admin_fee_json_key => admin_fee ) }
    it{ is_expected.to include( "Comments" => comments ) }
    it{ is_expected.to include( "CustomerNumber" => customer_number ) }
    it{ is_expected.to include( edi_info_json_key => edi_info ) }
    it{ is_expected.to include( ocr_json_key => ocr ) }

    describe 'nested models' do
      subject{ entity_json_hash["InvoiceRows"] }
      it do
        row_1 = { 'Price' => order_row_1_price, vat_json_key => order_row_1_vat }
        row_2 = { 'Price' => order_row_2_price, vat_json_key => order_row_2_vat }
        is_expected.to include( [ row_1, row_2 ] )
      end
    end
  end
end
