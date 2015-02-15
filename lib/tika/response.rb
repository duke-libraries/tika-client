require "delegate"

module Tika
  # Wraps a Net::HTTPResponse object
  class Response < SimpleDelegator

    def content
      body
    end

  end
end
