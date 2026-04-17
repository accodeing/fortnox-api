# frozen_string_literal: true

RSpec.describe Fortnox::Parsers::CountryCode do
  describe '.parse' do
    context 'with nil or empty string' do
      it 'returns empty string for nil' do
        expect(described_class.parse(nil)).to eq('')
      end

      it 'returns empty string for empty string' do
        expect(described_class.parse('')).to eq('')
      end
    end

    context 'with Sweden variants' do
      it "returns SE for 'Sverige'" do
        expect(described_class.parse('Sverige')).to eq('SE')
      end

      it "returns SE for 'Sweden'" do
        expect(described_class.parse('Sweden')).to eq('SE')
      end

      it "returns SE for 'SE'" do
        expect(described_class.parse('SE')).to eq('SE')
      end

      it 'is case-insensitive', :aggregate_failures do
        expect(described_class.parse('sverige')).to eq('SE')
        expect(described_class.parse('SVERIGE')).to eq('SE')
        expect(described_class.parse('se')).to eq('SE')
      end
    end

    context 'with ISO alpha2 code' do
      it 'returns the alpha2 code for a valid code' do
        expect(described_class.parse('NO')).to eq('NO')
      end

      it 'returns the alpha2 code for another country' do
        expect(described_class.parse('DE')).to eq('DE')
      end
    end

    context 'with country name' do
      it 'finds by English name' do
        expect(described_class.parse('Norway')).to eq('NO')
      end

      it 'finds by translated name' do
        expect(described_class.parse('Norge')).to eq('NO')
      end
    end

    context 'with invalid input' do
      it 'raises AttributeError for unrecognised country' do
        expect do
          described_class.parse('Neverland')
        end.to raise_error(Fortnox::AttributeError)
      end
    end
  end

  describe '.serialise' do
    context 'with nil or empty string' do
      it 'returns empty string for nil' do
        expect(described_class.serialise(nil)).to eq('')
      end

      it 'returns empty string for empty string' do
        expect(described_class.serialise('')).to eq('')
      end
    end

    context 'with SE' do
      it 'returns Sverige' do
        expect(described_class.serialise('SE')).to eq('Sverige')
      end
    end

    context 'with other country codes' do
      it 'returns the English name for NO' do
        expect(described_class.serialise('NO')).to eq('Norway')
      end

      it 'returns the English name for DE' do
        expect(described_class.serialise('DE')).to eq('Germany')
      end
    end
  end

  describe 'round-trip' do
    it 'parse then serialise returns the original for Sverige' do
      code = described_class.parse('Sverige')
      expect(described_class.serialise(code)).to eq('Sverige')
    end

    it 'parse then serialise returns the English name for others' do
      code = described_class.parse('Norway')
      expect(described_class.serialise(code)).to eq('Norway')
    end
  end
end
