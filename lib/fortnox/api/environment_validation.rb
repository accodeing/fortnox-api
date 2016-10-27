require 'forwardable'

module Fortnox
  module API
    module EnvironmentValidation

      class MissingEnvironmentVariable < ArgumentError
      end

      class CircularQueue
        extend Forwardable

        def initialize *items
          @queue = [ *items ]
          @@next_index = random_start_index
        end

        # support some general Array methods that fit Queues well
        def_delegators :@queue, :new, :[], :size

        def next
          value = @queue[ @@next_index ]
          if @@next_index == size - 1
            @@next_index = 0
          else
            @@next_index += 1
          end
          return value
        end

        private

          def random_start_index
            Random.rand(@queue.size)
          end
      end

      private

        def get_base_url
          base_url = ENV['FORTNOX_API_BASE_URL']
          fail MissingEnvironmentVariable, 'You have to provide a base url.' unless base_url
          base_url
        end

        def get_client_secret
          client_secret = ENV['FORTNOX_API_CLIENT_SECRET']
          fail MissingEnvironmentVariable, 'You have to provide your client secret.' unless client_secret
          client_secret
        end

        def get_access_token
          @access_tokens ||= load_access_tokens
          @access_tokens.next
        end

        def get_authorization_code
          authorization_code = ENV['FORTNOX_API_AUTHORIZATION_CODE']
          fail MissingEnvironmentVariable, 'You have to provide your authorization code.' unless authorization_code
          authorization_code
        end

        def load_access_tokens
          check_access_tokens!
          access_token_string = ENV['FORTNOX_API_ACCESS_TOKEN']
          access_tokens = access_token_string.split(",").map(&:strip)
          CircularQueue.new( *access_tokens )
        end

        def check_access_tokens!
          unless ENV['FORTNOX_API_ACCESS_TOKEN']
            fail MissingEnvironmentVariable, 'You have to provide your access token.'
          end
        end

    end
  end
end
