require "json"
require_relative "endpoints"
require_relative "request"

module Tika
  module Requests

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
      self.endpoint = Endpoints::GetTextEndpoint
    end

    class GetMetadataRequest < JSONRequest
      self.endpoint = Endpoints::GetMetadataEndpoint
    end

    class GetVersionRequest < Request
      self.endpoint = Endpoints::GetVersionEndpoint
    end

    class GetMimeTypesRequest < JSONRequest
      self.endpoint = Endpoints::GetMimeTypesEndpoint
    end

    class GetParsersRequest < JSONRequest
      self.endpoint = Endpoints::GetParsersEndpoint
    end

  end
end
