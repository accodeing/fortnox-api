# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API do
  before do
    module Fortnox
      module API
        class TestBase
        end
      end
    end
  end

  describe 'configuration defaults' do
    subject(:config_value) { described_class.config[config_key] }

    before { Fortnox::API::TestBase.new }

    describe 'base_url' do
      let(:config_key) { :base_url }

      it { is_expected.to eq 'https://api.fortnox.se/3/' }
    end

    describe 'client_id' do
      let(:config_key) { :client_id }

      it { is_expected.to be_nil }
    end

    describe 'client_secret' do
      let(:config_key) { :client_secret }

      it { is_expected.to be_nil }
    end

    describe 'token_url' do
      let(:config_key) { :token_url }

      it { is_expected.to eq 'https://apps.fortnox.se/oauth-v1/token' }
    end

    describe 'token_stores' do
      let(:config_key) { :token_stores }

      it { is_expected.to be_nil }
    end

    describe 'debugging' do
      let(:config_key) { :debugging }

      it { is_expected.to be false }
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
      subject { described_class.debugging }

      it 'is available' do
        is_expected.to be false
      end
    end

    describe 'logger' do
      subject { described_class.logger }

      it 'is available' do
        is_expected.to be_a Logger
      end
    end
  end
end
