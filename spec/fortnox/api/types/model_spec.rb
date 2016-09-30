require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/types/model'

RSpec.describe Fortnox::API::Types::Model do
  using_test_class do
    module Types
      include Dry::Types.module

      Email = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      Age = Int.constrained(gt: 18)
    end

    class FailureUser < Fortnox::API::Types::Model
      attribute :age, Types::Age
      attribute :email, Types::Email
    end

    class SuccessUser < Dry::Struct
      attribute :age, Types::Age
      attribute :email, Types::Email
    end
  end

  it do
    puts FailureUser.new(age: 19, email: 'hej') # Should raise Dry::Struct::Error!
    puts SuccessUser.new(age: 19, email: 'hej')
    fail
  end
end
