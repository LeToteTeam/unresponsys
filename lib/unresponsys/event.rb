class Unresponsys
  class Event
    extend Forwardable
    delegate [:client] => :member
    attr_reader :member

    def initialize(options = {})
      @event_name = options[:event]
      @member     = options[:member]
    end

    def save
      body = {
        customEvent: {},
        recipientData: [{
          recipient: { listName: { objectName: @member.list.name }, recipientId:  @member.riid }
        }]
      }

      r = client.post("/events/#{@event_name}", body: body.to_json)
      return false if r.first['errorMessage'].present?
      true
    end
  end
end
