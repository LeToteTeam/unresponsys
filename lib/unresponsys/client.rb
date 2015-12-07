require 'httparty'

class Unresponsys
  class Client
    def initialize(options = {})
      raise Unresponsys::ArgumentError unless options[:username] && options[:password]
      @username = options[:username]
      @password = options[:password]
      authenticate
    end

    def get(path, options = {}, &block)
      path      = "#{@base_uri}#{path}"
      options   = @options.merge(options)
      response  = HTTParty.get(path, options, &block)
      handle_error(response)
    end

    def post(path, options = {}, &block)
      path      = "#{@base_uri}#{path}"
      options   = @options.merge(options)
      response  = HTTParty.post(path, options, &block)
      handle_error(response)
    end

    def delete(path, options = {}, &block)
      path      = "#{@base_uri}#{path}"
      options   = @options.merge(options)
      response  = HTTParty.delete(path, options, &block)
      handle_error(response)
    end

    def folders
      @folders ||= Folders.new(self)
    end

    def lists
      @lists ||= Lists.new(self)
    end

    class Folders
      def initialize(client)
        @client = client
      end

      def find(folder_name)
        Folder.new(@client, folder_name)
      end
    end

    class Lists
      def initialize(client)
        @client = client
      end

      def find(list_name)
        List.new(@client, list_name)
      end
    end

    private

    def handle_error(response)
      if response.is_a?(Hash) && response.keys.include?('errorCode')
        raise Unresponsys::TokenExpired if response['title'].include?('token expired')
        raise Unresponsys::NotFoundError, response['detail'] if response['title'].include?('not found')
        raise Unresponsys::Error, "#{response['title']} - #{response['detail']}"
      end
      response
    end

    def authenticate
      headers   = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      body      = { user_name: @username, password: @password, auth_type: 'password' }
      response  = HTTParty.post('https://login2.responsys.net/rest/api/v1/auth/token', headers: headers, body: body)

      raise Unresponsys::AuthenticationError unless response.success?

      @options  = { headers: { 'Authorization' => response['authToken'], 'Content-Type' => 'application/json' } }
      @base_uri = "#{response['endPoint']}/rest/api/v1"
    end
  end
end
