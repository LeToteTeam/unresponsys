class Unresponsys
  class BatchClient
    STORED_REQUEST = Struct.new(:method, :path, :options, :block)

    def initialize(client)
      @client = client
    end

    def get(path, options = {}, &block)
      @stored_requests << STORED_REQUEST.new(:get, path, options, block)
    end

    def post(path, options = {}, &block)
      @stored_requests << STORED_REQUEST.new(:post, path, options, block)
    end

    def delete(path, options = {}, &block)
      @stored_requests << STORED_REQUEST.new(:delete, path, options, block)
    end

    def call
      # merge the stored requests
      # make the call via the client
      # handle error / compose response
    end

    private

    attr_accessor :stored_requests
    attr_reader :client
  end
end
