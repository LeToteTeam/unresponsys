class Unresponsys
  class ArgumentError < StandardError
    def initialize(msg="Wrong number of arguments")
      super
    end
  end

  class AuthenticationError < StandardError
    def initialize(msg="Authentication error occurred")
      super
    end
  end

  class Error < StandardError; end
  class NotFound < StandardError; end
  class LimitExceeded < StandardError; end
  class TokenExpired < StandardError; end
end
