shared_context 'repository context' do
  before(:all){
    ENV['FORTNOX_API_BASE_URL'] = ''
    ENV['FORTNOX_API_CLIENT_SECRET'] = ''
    ENV['FORTNOX_API_ACCESS_TOKEN'] = ''
  }

  after(:all){
    ENV['FORTNOX_API_BASE_URL'] = nil
    ENV['FORTNOX_API_CLIENT_SECRET'] = nil
    ENV['FORTNOX_API_ACCESS_TOKEN'] = nil
  }
end
