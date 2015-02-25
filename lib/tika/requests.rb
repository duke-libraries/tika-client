require "json"
require "net/http"
require_relative "request"

module Tika
  module Requests

    PUT = Net::HTTP::Put
    GET = Net::HTTP::Get

    class TextRequest < Request
      def self.headers
        {"Accept" => "text/plain"}
      end
    end

    class JSONRequest < Request
      def self.headers
        {"Accept" => "application/json"}
      end

      def handle_response(response)
        JSON.load(response.body)
      end
    end

    class GetTextRequest < TextRequest
      self.http_method = PUT
      self.path        = "/tika"
    end

    class GetMetadataRequest < JSONRequest
      self.http_method = PUT
      self.path        = "/meta"
    end

    class GetVersionRequest < Request
      self.http_method = GET
      self.path        = "/version"
    end

    class GetMimeTypesRequest < JSONRequest
      self.http_method = GET
      self.path        = "/mime-types"
    end

    class GetParsersRequest < JSONRequest
      self.http_method = GET
      self.path        = "/parsers"
    end

    class GetParsersDetailsRequest < JSONRequest
      self.http_method = GET
      self.path        = "/parsers/details"
    end

    class GetDetectorsRequest < JSONRequest
      self.http_method = GET
      self.path        = "/detectors"
    end

    class DetectRequest < Request
      self.http_method = PUT
      self.path        = "/detect/stream"
    end

  end
end
