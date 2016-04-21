require 'fortnox/api'

shared_context 'environment' do
  before(:each) do
    ENV['FORTNOX_API_BASE_URL'] = 'https://api.fortnox.se/3'
    ENV['FORTNOX_API_CLIENT_SECRET'] = '9aBA8ZgsvR'
    ENV['FORTNOX_API_ACCESS_TOKEN'] = 'ccaef817-d5d8-4b1c-a316-54f3e55c5c54'
  end
end
