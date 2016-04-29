class Unresponsys
  class ExtensionTables
    def initialize(member)
      @member = member
    end

    def find(name)
      ExtensionTable.new(@member, name)
    end
  end
end
