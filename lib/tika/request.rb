require "uri"
require "delegate"
require_relative "options"

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
      @options = Options.new(options)
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
      add_content
      set_content_type
      add_headers
    end

    def set_content_type
      self.content_type = options.content_type if options.content_type
    end

    def add_content
      if options.file
        add_file
      elsif options.blob
        add_blob
      end
    end

    def add_file
      self.body = options.file.read
      self.content_length = options.file.size
      self["Content-Disposition"] = "attachment; filename=#{File.basename(options.file.path)}"
    end

    def add_blob
      self.body = options.blob
      self.content_length = options.blob.size
    end

    def headers
      @headers ||= self.class.headers.merge(options.headers || {})
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
