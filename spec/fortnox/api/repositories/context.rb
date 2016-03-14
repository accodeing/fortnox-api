require 'fortnox/api/repositories/examples'

shared_context 'repository context' do
  before(:each){
    ENV['FORTNOX_API_BASE_URL'] = 'http://api.fortnox.se/3'
    ENV['FORTNOX_API_CLIENT_SECRET'] = '9aBA8ZgsvR'
    ENV['FORTNOX_API_ACCESS_TOKEN'] = 'ccaef817-d5d8-4b1c-a316-54f3e55c5c54'
  }
end
