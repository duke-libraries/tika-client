require "uri"
require "net/http"
require "delegate"

module Tika
  class Request < SimpleDelegator

    class << self
      attr_accessor :endpoint
    end

    attr_reader :connection
    
    def self.execute(connection, opts={})
      request = new(connection)
      yield request if block_given?
      request.execute(opts)
    end

    def initialize(connection)
      @connection = connection
      super build_request
      set_defaults
      post_initialize
    end

    def execute(opts={})
      connection.start do |conn|
        if file = opts.delete(:file)
          self.body = file.read
          self.content_length = file.size
        end
        self.content_type = opts[:content_type] if opts[:content_type]
        yield self if block_given?
        conn.request(__getobj__)
      end
    end

    def endpoint
      self.class.endpoint
    end

    def uri
      @uri ||= URI::HTTP.build(host: connection.address, port: connection.port, path: endpoint.path)
    end

    private

    def post_initialize; end

    def build_request
      endpoint.request_method.new(uri)
    end

    def set_defaults
      self["Accept"] = endpoint.response_format
    end

  end
end
