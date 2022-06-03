# frozen_string_literal: true

require 'rspec/core/rake_task'
require_relative 'lib/fortnox/api'
require 'dotenv'

Dotenv.load('.env.test')

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Remove all VCR cassettes so we can rerecord them'
task :throw_vcr_cassettes do
  FileUtils.rm_rf(Dir.glob('spec/vcr_cassettes/**'))
end

desc 'Seed Fortnox test instane with data required for the test suite'
task :seed_fortnox_test_instance do
  Fortnox::API.configure do |config|
    config.client_id = ENV.fetch('FORTNOX_API_CLIENT_ID')
    config.client_secret = ENV.fetch('FORTNOX_API_CLIENT_SECRET')
    config.storage = Class.new do
      def access_token
        ENV.fetch('FORTNOX_API_ACCESS_TOKEN')
      end

      def refresh_token; end

      def access_token=(token); end

      def refresh_token=(token); end
    end.new
  end

  puts 'Seeting Fortnox test instance account with data required for testing...'

  seed_customer_data
  seed_article_data
  seed_invoice_data
  seed_order_data

  puts 'Done'
end

def seed_customer_data
  customer_repository = Fortnox::API::Repository::Customer.new

  customer_repository.save(
    Fortnox::API::Model::Customer.new(
      name: 'A customer from New York',
      city: 'New York'
    )
  )
  customer_repository.save(
    Fortnox::API::Model::Customer.new(
      name: 'Another customer from New York',
      city: 'New York',
      zip_code: '10001'
    )
  )
end

def seed_article_data
  article_repository = Fortnox::API::Repository::Article.new

  article_repository.save(
    Fortnox::API::Model::Article.new(
      article_number: 101,
      description: 'Hammer'
    )
  )

  article_repository.save(
    Fortnox::API::Model::Article.new(
      article_number: 102,
      description: 'Hammer'
    )
  )

  article_repository.save(
    Fortnox::API::Model::Article.new(
      description: 'Test article'
    )
  )

  article_repository.save(
    Fortnox::API::Model::Article.new(
      description: 'Test article'
    )
  )
end

# TODO: When we have support for actions, we should set the states for
#       Invoices required by the Invoice Repository spec.
def seed_invoice_data
  invoice_repository = Fortnox::API::Repository::Invoice.new

  invoice_repository.save(
    Fortnox::API::Model::Invoice.new(
      customer_number: '1',
      your_reference: 'Gandalf the Grey'
    )
  )

  invoice_repository.save(
    Fortnox::API::Model::Invoice.new(
      customer_number: '1',
      your_reference: 'Gandalf the Grey',
      our_reference: 'Radagast the Brown'
    )
  )
end

# TODO: When we have support for actions, we should set the states for
#       Order required by the Order Repository spec.
#       Also, we should create Orders needed for search tests.
def seed_order_data
  order_repository = Fortnox::API::Repository::Order.new

  order_repository.save(
    Fortnox::API::Model::Order.new(
      customer_number: '1',
      our_reference: 'Belladonna Took'
    )
  )

  order_repository.save(
    Fortnox::API::Model::Order.new(
      customer_number: '1',
      our_reference: 'Belladonna Took',
      your_reference: 'Bodo Proudfoot'
    )
  )
end
