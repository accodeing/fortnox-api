require "fortnox/api/repositories/base"
require "fortnox/api/models/article"
require "fortnox/api/mappers/article"

module Fortnox
  module API
    module Repository
      class Article < Fortnox::API::Repository::Base

        MODEL = Fortnox::API::Model::Article
        MAPPER = Fortnox::API::Mapper::Article
        URI = '/articles/'.freeze
      end
    end
  end
end
