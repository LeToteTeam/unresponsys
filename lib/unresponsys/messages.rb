class Unresponsys
  class Messages
    def initialize(member)
      @member = member
    end

    def new(message, properties = {})
      Message.new(member: @member, message: message, properties: properties)
    end
  end
end
