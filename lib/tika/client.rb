require_relative "configuration"
require_relative "api"
require_relative "request"
require "forwardable"

module Tika
  class Client
    extend Forwardable

    class << self
      def config
        @config ||= Configuration.new
      end

      def configure
        yield config
      end
    end

    attr_accessor :host, :port, :api
    def_delegators :api, :endpoint, :has_endpoint?

    def initialize(opts={})
      @host = opts.fetch(:host, config.host)
      @port = opts.fetch(:port, config.port)
      @api = Api.new
    end

    def config
      self.class.config
    end

    def connection
      @connection ||= Net::HTTP.new(host, port)
    end

    def execute(name, opts={})
      request = Request.new(connection, endpoint(name))
      request.execute(opts)
    end

    def method_missing(name, *args)
      return execute(name, *args) if has_endpoint?(name)
      super
    end

  end
end
