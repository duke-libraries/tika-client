require "uri"
require "net/http"
require "delegate"
# require "mime-types"

module Tika
  # Executes an API method
  class Request < SimpleDelegator

    attr_reader :connection # , :endpoint, :http_request
    
    # def self.execute(*args)
    #   request = new(*args)
    #   yield request if block_given?
    #   request.execute
    # end

    def initialize(connection, endpoint)
      @connection = connection
      @endpoint = endpoint
      uri = URI::HTTP.build(host: connection.address, port: connection.port, path: endpoint.path)
      super endpoint.request_method.new(uri)
      self["Accept"] = endpoint.response_format
    end

    def execute(opts={})
      connection.start do |conn|
        if file = opts.delete(:file)
          self.body = file.read
          self.content_length = file.size
        end
        self.content_type = opts[:content_type] if opts[:content_type]
        conn.request(__getobj__)
      end
    end

  end
end
