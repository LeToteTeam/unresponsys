class Unresponsys
  class Folder
    attr_reader :client, :name

    def initialize(client, name)
      @client = client
      @name   = name
    end

    def tables
      @tables ||= Tables.new(self)
    end

    class Tables
      def initialize(folder)
        @folder = folder
      end

      def find(table_name)
        Unresponsys::Table.new(@folder, table_name)
      end
    end
  end
end
