class Unresponsys
  class Folder
    attr_reader :client, :name

    def initialize(client, name)
      @client = client
      @name   = name
    end

    def supplemental_tables
      @supplemental_tables ||= SupplementalTables.new(self)
    end

    class SupplementalTables
      def initialize(folder)
        @folder = folder
      end

      def find(table_name)
        Unresponsys::SupplementalTable.new(@folder, table_name)
      end
    end
  end
end
