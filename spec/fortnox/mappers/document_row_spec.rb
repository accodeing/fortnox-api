# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Mappers::DocumentRow do
  describe '.parse' do
    it 'maps HouseWork-prefixed API keys to housework attributes', :aggregate_failures do
      result = described_class.parse('HouseWork' => true, 'HouseWorkHoursToReport' => 5, 'HouseWorkType' => 'CLEANING')
      expect(result.housework).to be(true)
      expect(result.housework_hours_to_report).to eq(5)
      expect(result.housework_type).to eq('CLEANING')
    end
  end

  describe '.serialise' do
    let(:struct) do
      Fortnox::Structs::DocumentRow.new(housework: true, housework_hours_to_report: 5, housework_type: 'CLEANING')
    end

    it 'maps housework attributes back to HouseWork-prefixed API keys' do
      expect(described_class.serialise(struct)).to include('HouseWork' => true,
                                                           'HouseWorkHoursToReport' => 5,
                                                           'HouseWorkType' => 'CLEANING')
    end

    it 'excludes read-only attributes' do
      read_only = Fortnox::Structs::DocumentRow.new(article_number: '101', contribution_percent: 10.0,
                                                    contribution_value: 5.0, total: 99.0)
      expect(described_class.serialise(read_only).keys).to eq(['ArticleNumber'])
    end
  end
end
