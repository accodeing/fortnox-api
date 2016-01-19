require 'json'

filename = 'account.json'
modelname = filename.split('.').first.capitalize

json = File.read( 'json/account.json' )
hash = JSON.parse( json )

header = <<-RB
require "fortnox/api/entities/base"

module Fortnox
  module API
    module Entities
      module {{ model_name }}
        class Entity < Fortnox::API::Entities::Base

RB

footer = <<-RB
        end
      end
    end
  end
end

RB

attribute = <<-RB
          # {{ description }}
          attribute :{{ name }}, {{ type }}

RB

generated_class = header.gsub( '{{ model_name }}', modelname )

hash.each do |name, attributes|
  generated_class << attribute.gsub( '{{ description }}', attributes.fetch( 'description' ) ).gsub( '{{ name }}', name ).gsub( '{{ type }}', attributes.fetch( 'type' ).capitalize )
end

generated_class << footer

File.write( "#{ modelname.downcase }.rb", generated_class )