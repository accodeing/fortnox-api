# frozen_string_literal: true

require_relative 'base'
require_relative '../models/article'
require_relative '../mappers/article'

module Fortnox
  module API
    module Repository
      class Article < Base
        MODEL = Model::Article
        MAPPER = Mapper::Article
        URI = '/articles/'
      end
    end
  end
end
