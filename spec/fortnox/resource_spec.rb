# frozen_string_literal: true

require 'spec_helper'

class TestResource < Fortnox::Resource
  configure do
    path 'things'
    instance_wrapper 'Thing'
    collection_wrapper 'Things'
  end

  attr :name, Fortnox::Types::Coercible::String.optional, :key
  attr :comment, Fortnox::Types::Coercible::String.optional
  attr :count, Fortnox::Types::Coercible::Integer.optional
end

RSpec.describe Fortnox::Resource do
  describe '#serialise' do
    context 'with a new record' do
      subject(:serialised) { instance.serialise }

      let(:instance) { TestResource.stub(name: 'test', comment: 'hello') }

      it 'wraps in instance wrapper' do
        expect(serialised).to have_key('Thing')
      end

      it 'includes set attributes' do
        expect(serialised['Thing']).to include('Name' => 'test', 'Comment' => 'hello')
      end

      it 'strips nil attributes' do
        expect(serialised['Thing']).not_to have_key('Count')
      end
    end

    context 'with a saved record with changes' do
      subject(:serialised) { updated.serialise }

      let(:saved) do
        TestResource.send(:parse, { 'Thing' => { 'Name' => 'test', 'Comment' => 'hello', 'Count' => 5 } })
      end
      let(:updated) { saved.update(comment: 'changed') }

      it 'wraps in instance wrapper' do
        expect(serialised).to have_key('Thing')
      end

      it 'only includes changed attributes' do
        expect(serialised['Thing']).to eq('Comment' => 'changed')
      end
    end

    context 'with a saved record setting a value to nil' do
      subject(:serialised) { updated.serialise }

      let(:saved) do
        TestResource.send(:parse, { 'Thing' => { 'Name' => 'test', 'Comment' => 'hello', 'Count' => 5 } })
      end
      let(:updated) { saved.update(comment: nil) }

      it 'preserves the nil value' do
        expect(serialised['Thing']).to eq('Comment' => nil)
      end
    end

    context 'with a saved record with no changes' do
      subject(:serialised) { saved.serialise }

      let(:saved) do
        TestResource.send(:parse, { 'Thing' => { 'Name' => 'test', 'Comment' => 'hello', 'Count' => 5 } })
      end

      it 'includes all attributes' do
        expect(serialised['Thing']).to include('Name' => 'test', 'Comment' => 'hello', 'Count' => 5)
      end
    end
  end
end
