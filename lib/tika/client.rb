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

    private

    def config
      self.class.config
    end

    def connection
      @connection ||= Net::HTTP.new(host, port)
    end

  end
end
