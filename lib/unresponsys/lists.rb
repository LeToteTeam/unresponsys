class Unresponsys
  class Lists
    def initialize(client)
      @client = client
    end

    def find(list_name)
      List.new(@client, list_name)
    end
  end
end
