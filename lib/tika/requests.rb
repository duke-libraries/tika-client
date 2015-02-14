require_relative "request"
require_relative "endpoints"

module Tika
  module Requests

    include Endpoints

    def self.request_class(endpoint)
      klass = Class.new(Request)
      klass.endpoint = endpoint
      klass
    end

    GetTextRequest     = request_class GetTextEndpoint
    GetMetadataRequest = request_class GetMetadataEndpoint

  end
end
