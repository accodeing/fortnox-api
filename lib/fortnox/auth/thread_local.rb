# frozen_string_literal: true

module Fortnox
  module Auth
    # Bearer-token authentication isolated between threads, so concurrent
    # contexts (Sidekiq workers, Puma threads) can use different tokens
    # without leaking across them.
    class ThreadLocal
      THREAD_LOCAL_KEY = :fortnox_access_token

      def apply(request)
        request.headers['Authorization'] = "Bearer #{token!}"
      end

      def on_rejected(response)
        raise RestEasy::RequestError, response
      end

      private

      def token!
        Thread.current[THREAD_LOCAL_KEY] ||
          raise(Fortnox::MissingAccessToken,
                'No access token set for the current thread. Set one with: Fortnox.access_token = token')
      end
    end
  end
end
