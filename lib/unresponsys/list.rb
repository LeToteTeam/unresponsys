class Unresponsys
  class List
    # find a list. it can't actually be changed via the API
    def self.find(name)
      self.new(name)
    end

    def initialize(name)
      @name = name
    end

    # access a list's members
    def members
      @members ||= Members.new(list_name: @name)
    end

    class Members
      def initialize(options = {})
        @list_name = options[:list_name]
      end

      # find a member
      def find(email)
        options = { query: { qa: 'e', id: email, fs: 'all' } }
        r = Unresponsys::Client.get("/lists/#{@list_name}/members", options)

        fields = {}
        r['recordData']['fieldNames'].each_with_index do |field, index|
          fields[field] = r['recordData']['records'][0][index]
        end

        Unresponsys::Member.new(@list_name, fields)
      end

      # initialize a member
      def new(email)
        Unresponsys::Member.new(@list_name, { 'EMAIL_ADDRESS_' => email })
      end
    end
  end
end
