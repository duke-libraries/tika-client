module Tika
  class Configuration

    DEFAULT_HOST = "localhost"
    DEFAULT_PORT = 9998

    attr_accessor :host
    attr_accessor :port

    def initialize
      @host = ENV["TIKA_HOST"] || DEFAULT_HOST
      @port = ENV["TIKA_PORT"] || DEFAULT_PORT
    end

  end
end
