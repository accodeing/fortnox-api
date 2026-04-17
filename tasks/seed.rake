# frozen_string_literal: true

desc 'Seed Fortnox test instance with data required for the test suite'
task :seed_fortnox_test_instance do
  require 'dotenv'
  Dotenv.load('.env.test.local', '.env.test')
  require 'fortnox'

  Fortnox.access_token = ENV.fetch('FORTNOX_ACCESS_TOKEN')

  puts 'Seeding Fortnox test instance...'

  seed_customer_data
  seed_article_data
  seed_invoice_data
  seed_order_data

  puts 'Done'
end

def seed_customer_data
  customer = Fortnox::Customer.stub(name: 'A customer from New York', city: 'New York')
  Fortnox::Customer.save(customer)

  customer = Fortnox::Customer.stub(name: 'Another customer from New York', city: 'New York', zip_code: '10001')
  Fortnox::Customer.save(customer)
end

def seed_article_data
  [
    { article_number: '101', description: 'Hammer' },
    { article_number: '102', description: 'Hammer' },
    { description: 'Test article' },
    { description: 'Test article' }
  ].each { |attrs| Fortnox::Article.save(Fortnox::Article.stub(**attrs)) }
end

# TODO: When we have support for actions, we should set the states for
#       Invoices required by the Invoice spec.
def seed_invoice_data
  invoice = Fortnox::Invoice.stub(customer_number: '1', your_reference: 'Gandalf the Grey')
  Fortnox::Invoice.save(invoice)

  invoice = Fortnox::Invoice.stub(customer_number: '1',
                                  your_reference: 'Gandalf the Grey',
                                  our_reference: 'Radagast the Brown')
  Fortnox::Invoice.save(invoice)
end

# TODO: When we have support for actions, we should set the states for
#       Orders required by the Order spec.
#       Also, we should create Orders needed for search tests.
def seed_order_data
  order = Fortnox::Order.stub(customer_number: '1', our_reference: 'Belladonna Took')
  Fortnox::Order.save(order)

  order = Fortnox::Order.stub(customer_number: '1',
                              our_reference: 'Belladonna Took',
                              your_reference: 'Bodo Proudfoot')
  Fortnox::Order.save(order)
end
