require 'httparty'

class Unresponsys
  class Client
    include HTTParty

    def initialize(options = {})
      raise Unresponsys::ArgumentError, 'Username is required' unless options[:username]
      @username = options[:username]

      raise Unresponsys::ArgumentError, 'Password is required' unless options[:password]
      @password = options[:password]

      raise Unresponsys::Error, 'Could not authenticate' unless authenticate

      self.class.debug_output($stdout) if options[:debug]
    end

    def self.get(path, options = {}, &block)
      r = perform_request Net::HTTP::Get, path, options, &block
      handle_error(r)
    end

    def self.post(path, options = {}, &block)
      r = perform_request Net::HTTP::Post, path, options, &block
      handle_error(r)
    end

    def self.delete(path, options = {}, &block)
      r = perform_request Net::HTTP::Delete, path, options, &block
      handle_error(r)
    end

    private

    def self.handle_error(response)
      if response.is_a?(Hash) && response.keys.include?('errorCode')
        raise Unresponsys::NotFoundError, response['detail'] if response['title'].include?('not found')
        raise Unresponsys::Error, "#{response['title']} - #{response['detail']}"
      end
      response
    end

    def authenticate
      self.class.headers('Content-Type' => 'application/x-www-form-urlencoded')
      body = { user_name: @username, password: @password, auth_type: 'password' }
      r = self.class.post('https://login2.responsys.net/rest/api/v1/auth/token', body: body)
      return false unless r.success?
      self.class.headers('Authorization' => r['authToken'], 'Content-Type' => 'application/json')
      self.class.base_uri("#{r['endPoint']}/rest/api/v1")
      true
    end
  end
end
