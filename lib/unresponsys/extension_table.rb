class Unresponsys
  class ExtensionTable
    extend Forwardable
    delegate [:client] => :list
    attr_reader :list, :name

    def initialize(member, table_name)
      @member = member
      @list = member.list
      @name = table_name
    end

    def update(fields = {})
      row = Unresponsys::Row.new(self, { 'RIID_' => @member.riid })
      fields.each_pair { |field, value| row.send("#{field}=", value) }
      row.save
    end

    def supplemental_table?
      false
    end

    def extension_table?
      true
    end
  end
end
