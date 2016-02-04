class Unresponsys
  class ExtensionTable
    extend Forwardable
    delegate [:client] => :list
    attr_reader :list, :name

    def initialize(list, table_name)
      @list = list
      @name = table_name
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
        r       = @list.client.get("lists/#{@list.name}/listExtensions/#{@table.name}")

        fields = {}
        r['recordData']['fieldNames'].each_with_index do |field, index|
          fields[field] = r['recordData']['records'][0][index]
        end

        Unresponsys::ExtensionRow.new(@table, fields)
      end

      def new(primary_key)
        Unresponsys::ExtensionRow.new(@table, { 'ID_' => primary_key })
      end
    end
  end
end
