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
      @host = opts.fetch(:host, self.class.config.host)
      @port = opts.fetch(:port, self.class.config.port)
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

    def get_detectors
      GetDetectorsRequest.execute(connection)
    end

    private
    
    def connection
      @connection ||= Net::HTTP.new(host, port)
    end

  end
end
