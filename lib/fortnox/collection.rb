# frozen_string_literal: true

require 'forwardable'

module Fortnox
  # An iterable wrapper around a list of resource instances that also carries
  # the pagination metadata Fortnox returns alongside collection responses.
  class Collection
    include Enumerable
    include Serialisation::CollectionJSON
    extend Forwardable

    def_delegators :@items, :each, :first, :last, :size, :length, :empty?, :[], :to_a

    attr_reader :total, :pages, :current_page

    def initialize(items, total: nil, pages: nil, current_page: nil)
      @items = items
      @total = total
      @pages = pages
      @current_page = current_page
    end
  end
end
