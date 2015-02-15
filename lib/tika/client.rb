require "net/http"
require_relative "configuration"
require_relative "requests"

module Tika
  class Client

    include Requests

    class << self
      def config
        @config ||= Configuration.new
      end

      def configure
        yield config
      end
    end

    attr_reader :host, :port

    def initialize(opts={})
      @host = opts.fetch(:host, config.host)
      @port = opts.fetch(:port, config.port)
    end

    def get_text(opts={})
      GetTextRequest.execute(connection, opts)
    end

    def get_metadata(opts={})
      GetMetadataRequest.execute(connection, opts)
    end

    def get_version
      GetVersionRequest.execute(connection)
    end

    def get_mime_types
      GetMimeTypesRequest.execute(connection)
    end

    def get_parsers
      GetParsersRequest.execute(connection)
    end

    def get_parsers_details
      GetParsersDetailsRequest.execute(connection)
    end

    private

    def execute(request)
      http_response = connection.start { |conn| conn.request(request) }
      Response.new http_response
    end
    
    def config
      self.class.config
    end

    def connection
      @connection ||= Net::HTTP.new(host, port)
    end

  end
end
