# frozen_string_literal: true

module Fortnox
  class Label < Fortnox::Resource
    attr :id, Nullable::Integer, :read_only
    attr :description, Sized::String[25], :read_only
  end
end
