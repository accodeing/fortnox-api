require 'spec_helper'
require 'fortnox/api/repositories/base/json_convertion'

describe Fortnox::API::Repository::JSONConvertion do
  describe 'remove_nil_values' do
    subject{ described_class.remove_nil_values( hash ) }

    context 'when empty hash given' do
      let(:hash){ {} }

      it 'returns an empty hash' do
        is_expected.to eq( {} )
      end
    end

    context 'when no nil values present' do
      let(:hash){ { a: 'a', b: 'b', c: 'c'} }

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
              b: { a: 'a', c: 'c'},
              c: { b: 'b' }
            }
          )
        end
      end
    end
  end
end
