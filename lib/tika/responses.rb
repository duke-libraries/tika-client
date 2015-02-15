require "json"
require_relative "response"

module Tika
  module Responses

    class GetTextResponse < Response
      def text
        content
      end
    end

    class GetMetadataResponse < Response
      def metadata
        JSON.load(content)
      end
    end

    class GetVersionResponse < Response
      def version
        content
      end
    end

    class GetMimeTypesResponse < Response
      def mime_types
        JSON.load(content)
      end
    end

  end
end
