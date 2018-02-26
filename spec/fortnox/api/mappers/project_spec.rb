# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/project'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Project do
  it_behaves_like 'mapper', {}, 'Project', 'Projects' do
    let(:mapper) { described_class.new }
  end
end
