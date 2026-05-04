# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox do
  let(:vcr_dir) { 'authentication' }

  describe '.request_access_token' do
    context 'with valid credentials' do
      let(:token) do
        VCR.use_cassette("#{vcr_dir}/valid_request") do
          described_class.request_access_token(
            client_id: ENV.fetch('FORTNOX_CLIENT_ID'),
            client_secret: ENV.fetch('FORTNOX_CLIENT_SECRET'),
            tenant_id: ENV.fetch('FORTNOX_TENANT_ID')
          )
        end
      end

      it 'returns an access token', :aggregate_failures do
        expect(token).to be_a(String)
        expect(token).not_to be_empty
      end
    end

    context 'with invalid credentials' do
      let(:request_with_invalid_credentials) do
        VCR.use_cassette("#{vcr_dir}/invalid_credentials") do
          described_class.request_access_token(
            client_id: 'invalid',
            client_secret: 'invalid',
            tenant_id: '0'
          )
        end
      end

      it 'raises an error' do
        expect { request_with_invalid_credentials }.to raise_error(Fortnox::RequestError)
      end
    end
  end

  describe '.access_token=' do
    # Set a token in thread A, then in thread B (deterministically interleaved
    # via Queues), and report each thread's own view of the access token after
    # both writes have happened.
    def observe_concurrent_token_setters # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      a_done = Queue.new
      b_done = Queue.new
      observations = Queue.new

      threads = [
        Thread.new do
          described_class.access_token = 'token_A'
          a_done << :ok
          b_done.pop
          observations << [:a, described_class.access_token]
        end,
        Thread.new do
          a_done.pop
          described_class.access_token = 'token_B'
          observations << [:b, described_class.access_token]
          b_done << :ok
        end
      ]
      threads.each(&:join)
      Array.new(2) { observations.pop }.to_h
    end

    it 'is thread-local — each thread has its own access token', :aggregate_failures do
      seen = observe_concurrent_token_setters
      expect(seen[:a]).to eq('token_A')
      expect(seen[:b]).to eq('token_B')
    end
  end
end
