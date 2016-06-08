require 'httparty'
require 'net/http'
require 'uri'

class Unresponsys
  class Client
    attr_accessor :token, :endpoint

    def initialize(options = {})
      raise Unresponsys::ArgumentError unless options[:username] && options[:password]
      @username = options[:username]
      @password = options[:password]
      @token
      @endpoint
      authenticate
    end

    def get(path, options = {}, &block)
      path      = "#{@base_uri}#{path}"
      options   = @options.merge(options)
      options   = options.merge(@log_opts) if @debug
      response  = HTTParty.get(path, options, &block)
      handle_error(response)
    end

    def post(path, options = {}, &block)
      path      = "#{@base_uri}#{path}"
      options   = @options.merge(options)
      options   = options.merge(@log_opts) if @debug
      response  = HTTParty.post(path, options, &block)
      handle_error(response)
    end

    def delete(path, options = {}, &block)
      path      = "#{@base_uri}#{path}"
      options   = @options.merge(options)
      options   = options.merge(@log_opts) if @debug
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
        case response['errorCode']
        when /TOKEN_EXPIRED/
          raise Unresponsys::TokenExpired, response['detail']
        when /NOT_FOUND/
          raise Unresponsys::NotFound, response['detail']
        when /LIMIT_EXCEEDED/
          raise Unresponsys::LimitExceeded, response['detail']
        else
          raise Unresponsys::Error, "#{response['title']}: #{response['detail']}"
        end
      end
      response
    end

    def authenticate
      uri = URI.parse('https://login2.responsys.net/rest/api/v1/auth/token')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(
        'user_name' => @username,
        'password'  => @password,
        'auth_type' => 'password'
      )
      response = http.request(request)

      case response
      when Net::HTTPSuccess
        # ↓ for Net::HTTP ↓
        @token    = JSON.parse(response.body)['authToken']
        @endpoint = JSON.parse(response.body)['endPoint']
        # ↓ for HTTParty ↓
        @options  = {
          'headers' => {
            'Authorization' => @token,
            'Content-Type' => 'application/json'
            }
          }
        @base_uri = "#{@endpoint}/rest/api/v1.1"
      else
        raise Unresponsys::AuthenticationError
      end
    end
  end
end
