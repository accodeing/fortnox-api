# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API do
  before { stub_const('Fortnox::API::TestBase', Class.new) }

  describe 'configuration defaults' do
    subject(:config_value) { described_class.config[config_key] }

    before { Fortnox::API::TestBase.new }

    describe 'base_url' do
      let(:config_key) { :base_url }

      it { is_expected.to eq 'https://api.fortnox.se/3/' }
    end

    describe 'token_url' do
      let(:config_key) { :token_url }

      it { is_expected.to eq 'https://apps.fortnox.se/oauth-v1/token' }
    end

    describe 'logger' do
      let(:config_key) { :logger }

      it { is_expected.to be_a Logger }

      describe 'level' do
        subject { config_value.level }

        it { is_expected.to be Logger::WARN }
      end
    end
  end

  describe 'readers for' do
    describe 'debugging' do
      subject(:debugging) { described_class.debugging }

      it 'is available' do
        expect(debugging).to be false
      end
    end

    describe 'logger' do
      subject(:logger) { described_class.logger }

      it 'is available' do
        expect(logger).to be_a Logger
      end
    end
  end

  describe '#access_token' do
    context 'when token is set' do
      before { described_class.access_token = 'an_access_token' }

      it 'returns the token' do
        expect(described_class.access_token).to eq('an_access_token')
      end
    end
  end
end
