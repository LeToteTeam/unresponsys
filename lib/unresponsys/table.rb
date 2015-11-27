class Unresponsys
  class Table
    attr_reader :folder, :name

    def initialize(folder, table_name)
      @folder = folder
      @name   = table_name
    end

    def rows
      @rows ||= Rows.new(self)
    end

    class Rows
      def initialize(table)
        @table = table
      end

      def find(primary_key)
        options = { query: { qa: 'ID_', id: primary_key.to_responsys, fs: 'all' } }
        r = Unresponsys::Client.get("/folders/#{@table.folder.name}/suppData/#{@table.name}/members", options)

        fields = {}
        r['recordData']['fieldNames'].each_with_index do |field, index|
          fields[field] = r['recordData']['records'][0][index]
        end

        Unresponsys::Row.new(@table, fields)
      end

      def new(primary_key)
        Unresponsys::Row.new(@table, { 'ID_' => primary_key })
      end
    end
  end
end
