class Unresponsys
  class ArgumentError < StandardError; end
  class AuthenticationError < StandardError; end
  class Error < StandardError; end
  class NotFound < StandardError; end
  class LimitExceeded < StandardError; end
  class TokenExpired < StandardError; end
end
