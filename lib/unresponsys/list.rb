class Unresponsys
  class List
    attr_reader :name

    def self.find(name)
      self.new(name)
    end

    def initialize(name)
      @name = name
    end

    def members
      @members ||= Members.new(self)
    end

    class Members
      def initialize(list)
        @list = list
      end

      def find(email)
        options = { query: { qa: 'e', id: email.to_responsys, fs: 'all' } }
        r = Unresponsys::Client.get("/lists/#{@list.name}/members", options)

        fields = {}
        r['recordData']['fieldNames'].each_with_index do |field, index|
          fields[field] = r['recordData']['records'][0][index]
        end

        Unresponsys::Member.new(@list, fields)
      end

      def new(email)
        Unresponsys::Member.new(@list, { 'EMAIL_ADDRESS_' => email })
      end
    end
  end
end
