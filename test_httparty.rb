BASE_URL = 'https://api-acce-current.fortnox.se/3'
CLIENT_SECRET = 'P5K5vEyKun'
ACCESS_TOKEN = 'ea3862b0-189c-464a-8e23-1b9702365ea1'

require 'httparty'
require 'json'

class Fortnox
  include HTTParty

  base_uri 'https://api-acce-current.fortnox.se/3'
  headers 'Accept' => 'application/json', 'Client-Secret' => CLIENT_SECRET, 'Access-Token' => ACCESS_TOKEN

  def self.post( endpoint, body )
    options = { body: body.to_json, headers: { 'Content-Type' => 'application/json' }}
    super endpoint, options
  end

  def self.put( endpoint, body )
    options = { body: body.to_json, headers: { 'Content-Type' => 'application/json' }}
    super endpoint, options
  end
end

response = Fortnox.post( '/articles', { 'Article' => { 'Description' => 'My updated description' }} )
p response
p ''
article_number = response[ 'Article' ][ 'ArticleNumber' ]

# response = Fortnox.put( '/articles/'+article_number, { 'Article' => { 'Description' => 'My more updated description' }})
# p response
# p ''

p HTTParty.put(
  BASE_URL + '/articles/'+article_number,
  {
    body: { 'Article' => { 'Description' => 'My erwtektyouryiptuo description' }}.to_json,
    headers: {
      'Accept' => 'application/json',
      'Client-Secret' => CLIENT_SECRET,
      'Access-Token' => ACCESS_TOKEN,
      'Content-Type' => 'application/json'
    }
  }
)
p ''

p Fortnox.get( '/articles/'+article_number )
p ''

response = Fortnox.delete( '/articles/'+article_number )
p response
p ''

response = Fortnox.get( '/articles/'+article_number )
p response
p ''

