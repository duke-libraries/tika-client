module Tika
  class Options

    attr_reader :options

    def initialize(options={})
      @options = options
    end

    def method_missing(name, *args)
      options[name]
    end

  end
end
