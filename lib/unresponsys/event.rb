class Unresponsys
  class Event

    def initialize(options = {})
      @event_name = options[:event]
      @member     = options[:member]
      @properties = options[:properties]
    end

    def save
      body = {
        customEvent: {},
        recipientData: [{
          recipient: {
            listName:     { objectName: @member.list },
            recipientId:  @member.riid,
          }
        }]
      }

      # API throws an non-descriptive error if optionalData is present but empty
      if @properties.present?
        body[:recipientData].first[:optionalData] = []
        @properties.each_pair do |key, val|
          body[:recipientData].first[:optionalData] << { name: key.to_s, value: val.to_s }
        end
      end

      r = Unresponsys::Client.post("/events/#{@event_name}", body: body.to_json)
      return false if r.first['errorMessage'].present?
      true
    end

  end
end
