require_relative "endpoints"
require_relative "responses"
require_relative "request"

module Tika
  module Requests

    class GetTextRequest < Request
      self.endpoint = Endpoints::GetTextEndpoint
      self.headers = {"Accept" => "text/plain"}
      self.response = Responses::GetTextResponse
    end

    class GetMetadataRequest < Request
      self.endpoint = Endpoints::GetMetadataEndpoint
      self.headers = {"Accept" => "application/json"}
      self.response = Responses::GetMetadataResponse
    end

    class GetVersionRequest < Request
      self.endpoint = Endpoints::GetVersionEndpoint
      self.response = Responses::GetVersionResponse
    end

  end
end
