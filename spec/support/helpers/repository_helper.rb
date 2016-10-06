module Helpers
  module Repositories
    # Returns directory for VCR.
    def vcr_dir
      described_class.new.mapper.class::JSON_COLLECTION_WRAPPER.downcase
    end
  end
end
