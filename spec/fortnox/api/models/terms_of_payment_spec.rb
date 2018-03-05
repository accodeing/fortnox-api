# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/models/terms_of_payment'
require 'fortnox/api/models/examples/model'

describe Fortnox::API::Model::TermsOfPayment, type: :model do
  it_behaves_like 'a model', '1'
end
