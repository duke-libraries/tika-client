require "uri"
require "delegate"

module Tika
  class Request < SimpleDelegator

    class << self
      attr_accessor :endpoint, :headers, :response
    end

    attr_reader :connection, :options
    
    def self.execute(connection, options={})
      request = new(connection, options)
      request.execute
    end

    def initialize(connection, options={})
      @connection = connection
      @options = options
      super build_request
      handle_options
      post_initialize
    end

    def execute
      self.class.response.new _execute
    end

    def endpoint
      self.class.endpoint
    end

    def uri
      @uri ||= URI::HTTP.build(host: connection.address, port: connection.port, path: endpoint.path)
    end

    private

    def _execute
      connection.start { |conn| conn.request(__getobj__) }
    end

    def handle_options
      add_file if file
      set_content_type
      add_headers
    end

    def set_content_type
      self.content_type = options[:content_type] if options[:content_type]
    end

    def add_file
      self.body = file.read
      self.content_length = file.size
    end

    def file
      options[:file]
    end

    def headers
      @headers ||= (self.class.headers || {}).merge(options[:headers] || {})
    end

    def add_headers
      headers.each { |header, value| self[header] = value }
    end

    # Subclass hook
    def post_initialize; end

    def build_request
      endpoint.request_method.new(uri)
    end

  end
end
