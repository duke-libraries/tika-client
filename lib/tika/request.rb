require "uri"
require "delegate"

module Tika
  class Request < SimpleDelegator

    class << self
      attr_accessor :http_method, :path

      def headers
        {}
      end
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
      response = connection.start { |conn| conn.request(__getobj__) }
      handle_response(response)
    end

    def uri
      @uri ||= URI::HTTP.build(host: connection.address, port: connection.port, path: self.class.path)
    end

    def handle_response(response)
      response.body
    end

    private

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
      @headers ||= self.class.headers.merge options.fetch(:headers, {})
    end

    def add_headers
      headers.each { |header, value| self[header] = value }
    end

    # Subclass hook
    def post_initialize; end

    def build_request
      self.class.http_method.new(uri)
    end

  end
end
