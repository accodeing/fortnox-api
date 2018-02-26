# frozen_string_literal: true

module Helpers
  def when_performing(&block)
    block.to_proc
  end
end
