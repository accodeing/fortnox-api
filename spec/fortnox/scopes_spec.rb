# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox do
  describe '.scopes' do
    subject(:scopes) { described_class.scopes }

    it 'groups resources sharing a scope' do
      expect(scopes['settings']).to eq([Fortnox::Label, Fortnox::TermsOfPayment, Fortnox::Unit])
    end

    it 'lists every gem-supported scope' do
      expect(scopes.keys).to contain_exactly('article', 'customer', 'invoice', 'order', 'project', 'settings')
    end

    it 'excludes the abstract Document class' do
      expect(scopes.values.flatten).not_to include(Fortnox::Document)
    end
  end

  describe 'declared resource scopes' do
    {
      Fortnox::Article => 'article',
      Fortnox::Customer => 'customer',
      Fortnox::Invoice => 'invoice',
      Fortnox::Order => 'order',
      Fortnox::Project => 'project',
      Fortnox::Label => 'settings',
      Fortnox::TermsOfPayment => 'settings',
      Fortnox::Unit => 'settings'
    }.each do |resource_class, expected_scope|
      it "#{resource_class} declares scope #{expected_scope.inspect}" do
        expect(resource_class.scope).to eq(expected_scope)
      end
    end
  end
end
