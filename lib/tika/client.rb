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
      execute GetTextRequest, opts
    end

    def get_metadata(opts={})
      execute GetMetadataRequest, opts
    end

    def get_version
      execute GetVersionRequest
    end

    def get_mime_types
      execute GetMimeTypesRequest
    end

    def get_parsers
      execute GetParsersRequest
    end

    def get_parsers_details
      execute GetParsersDetailsRequest
    end

    def get_detectors
      execute GetDetectorsRequest
    end

    def detect(opts={})
      execute DetectRequest, opts
    end

    private
    
    def connection
      @connection ||= Net::HTTP.new(host, port)
    end

    def execute(request, opts={})
      request.execute(connection, opts)
    end

  end
end
