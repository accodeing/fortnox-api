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
end
