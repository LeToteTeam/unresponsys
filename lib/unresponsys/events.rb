class Unresponsys
  class Events
    def initialize(member)
      @member = member
    end

    def new(event, properties = {})
      Event.new(member: @member, event: event, properties: properties)
    end
  end
end
