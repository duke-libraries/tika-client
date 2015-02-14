module Tika
  class Api

    PUT = Net::HTTP::Put
    GET = Net::HTTP::Get

    JSON = "application/json"
    TEXT = "text/plain"
    
    Endpoint = Struct.new(:request_method, :path, :response_format)

    ENDPOINTS = {
      get_metadata: Endpoint.new(PUT, "/meta", JSON),
      get_text:     Endpoint.new(PUT, "/tika", TEXT)
    }

    def endpoint(name)
      ENDPOINTS.fetch(name)
    end

    def has_endpoint?(name)
      ENDPOINTS.include?(name)
    end

  end
end
