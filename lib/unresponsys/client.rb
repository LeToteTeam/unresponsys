require 'httparty'

class Unresponsys
  class Client
    def initialize(options = {})
      raise Unresponsys::ArgumentError unless options[:username] && options[:password]
      @username = options[:username]
      @password = options[:password]
      @interact = options.fetch(:interact, 2)
      @debug    = options[:debug]
      @logger   = Logger.new(STDOUT) if @debug
      @log_opts = { logger: @logger, log_level: :debug, log_format: :curl }
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
      headers   = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      body      = { user_name: @username, password: @password, auth_type: 'password' }
      host      = "login#{@interact}.responsys.net"
      response  = HTTParty.post("https://#{host}/rest/api/v1/auth/token", headers: headers, body: body)

      raise Unresponsys::AuthenticationError unless response.success?

      @options  = { headers: { 'Authorization' => response['authToken'], 'Content-Type' => 'application/json' } }
      @base_uri = "#{response['endPoint']}/rest/api/v1.1"
    end
  end
end
