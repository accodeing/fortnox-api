module Helpers
  module Repositories
    # Returns directory for VCR.
    def vcr_dir
      described_class.new.options.json_collection_wrapper.downcase
    end
  end
end
