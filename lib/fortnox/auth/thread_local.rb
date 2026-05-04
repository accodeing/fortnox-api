# frozen_string_literal: true

module Fortnox
  module Auth
    # Thread-local Bearer-token authentication. The token is stored in
    # Thread.current so concurrent threads (Sidekiq workers, Puma threads)
    # can use different tokens without leaking to each other. Mirrors the
    # 0.x access_token storage model.
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
