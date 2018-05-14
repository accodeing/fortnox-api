# frozen_string_literal: true

module Fortnox
  module API
    module Repository
      module Pagination
        def last_page?
          current_page == total_pages
        end

        def next_page
          current_page + 1
        end

        def current_page
          metadata&.current_page || 0
        end

        def total_pages
          metadata&.total_pages || 0
        end
      end
    end
  end
end
