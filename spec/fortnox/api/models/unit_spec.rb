# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/models/unit'

module Fortnox
  module API
    # Shhh Rubocop, we don't need a comment here ... Really
    module Model
      describe Unit, type: :model do
        context 'when created from empty hash' do
          it {
            expect do
              described_class.new
            end.to raise_error(Fortnox::API::MissingAttributeError, /Missing attribute.*:code/)
          }
        end

        context 'when created from stub' do
          subject { described_class.stub }

          it { is_expected.to have_attributes(code: '', description: nil) }
        end

        context 'when created with all attributes' do
          subject { described_class.new(code: 'lbs', description: 'Pounds') }

          it { is_expected.to have_attributes(code: 'lbs', description: 'Pounds') }
        end
      end
    end
  end
end
