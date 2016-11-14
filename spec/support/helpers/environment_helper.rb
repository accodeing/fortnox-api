module Helpers
  module Environment
    def stub_environment( hash )
      stub_const( 'ENV', ENV.to_hash.merge( hash ))
    end
  end
end
