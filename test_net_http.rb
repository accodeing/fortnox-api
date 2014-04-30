BASE_URL = 'https://api-acce-current.fortnox.se/3'
CLIENT_SECRET = 'P5K5vEyKun'
ACCESS_TOKEN = 'ea3862b0-189c-464a-8e23-1b9702365ea1'

require 'uri'
require 'net/https'
require 'json'

def execute_request( endpoint, body = nil )
  uri = URI.parse( BASE_URL + endpoint )
  http = Net::HTTP.new( uri.host, uri.port )
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = yield( uri )

  request[ 'Accept' ] = 'application/json'
  request[ 'Client-Secret' ] = CLIENT_SECRET
  request[ 'Access-Token' ] = ACCESS_TOKEN

  if( body )
    request[ 'Content-Type' ] = 'application/json'
    request.body = body.to_json
  end

  response = http.request( request )

  JSON.parse( response.body ) if response.body
end

def get( endpoint )
  execute_request( endpoint ) do |uri|
    Net::HTTP::Get.new( uri.request_uri )
  end
end

def post( endpoint, data )
  execute_request( endpoint, data ) do |uri|
    Net::HTTP::Post.new( uri.request_uri )
  end
end

def put( endpoint, data )
  execute_request( endpoint, data ) do |uri|
    Net::HTTP::Put.new( uri.request_uri )
  end
end

def delete( endpoint )
  execute_request( endpoint ) do |uri|
    Net::HTTP::Delete.new( uri.request_uri )
  end
end

response = delete( '/articles/2014' )

response = post( '/articles', { 'Article' => { 'Description' => 'My description' }} )
p response
p ''
article_number = response[ 'Article' ][ 'ArticleNumber' ]
p article_number
p ''

response = put( '/articles/'+article_number, { 'Article' => { 'Description' => 'My updated description' }} )
p response
p ''

response = delete( '/articles/'+article_number )
p response
p ''

response = get( '/articles/'+article_number )
p response
p ''
