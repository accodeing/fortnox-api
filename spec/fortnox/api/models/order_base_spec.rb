require 'spec_helper'
require 'fortnox/api/models/context'
require 'fortnox/api/models/order_base'

describe Fortnox::API::Model::OrderBase do
  include_context 'models context'

  include_examples 'having value objects', Fortnox::API::Model::EmailInformation do
    let( :attribute ){ :email_information }
  end
end
