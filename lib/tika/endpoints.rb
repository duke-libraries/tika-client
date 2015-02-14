require "net/http"

module Tika
  module Endpoints

    PUT = Net::HTTP::Put
    GET = Net::HTTP::Get

    JSON = "application/json"
    TEXT = "text/plain"
    
    Endpoint = Struct.new(:request_method, :path, :response_format)

    GetTextEndpoint     = Endpoint.new(PUT, "/tika", TEXT)
    GetMetadataEndpoint = Endpoint.new(PUT, "/meta", JSON)

  end
end
