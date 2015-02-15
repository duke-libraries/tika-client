require "net/http"
require_relative "configuration"
require_relative "requests"
require_relative "response"

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
      response = GetTextRequest.execute(connection, opts)
      response.text
    end

    def get_metadata(opts={})
      response = GetMetadataRequest.execute(connection, opts)
      response.metadata
    end

    def get_version
      response = GetVersionRequest.execute(connection)
      response.version
    end

    def get_mime_types
      response = GetMimeTypesRequest.execute(connection)
      response.mime_types
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
