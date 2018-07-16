class Unresponsys
  class SupplementalTable
    extend Forwardable
    delegate [:client] => :folder
    attr_reader :folder, :name

    def initialize(folder, table_name)
      @folder = folder
      @name   = table_name
    end

    def rows
      @rows ||= Rows.new(self)
    end

    def supplemental_table?
      true
    end

    def extension_table?
      false
    end

    class Rows
      def initialize(table)
        @table = table
      end

      def find(primary_keys)
        params = { fs: 'all', qa: primary_keys.keys, id: primary_keys.values }
        query = "?"
        params.each do |key, value|
          query += "&"
          query += [value].flatten.map { |value| "#{key}=#{value}" }.join('&')
        end
        options = { query: query }
        r       = @table.client.get("/folders/#{@table.folder.name}/suppData/#{@table.name}/members", options)

        fields = {}
        r['recordData']['fieldNames'].each_with_index do |field, index|
          fields[field] = r['recordData']['records'][0][index]
        end

        Unresponsys::Row.new(@table, fields)
      end

      def new(primary_keys = {})
        options = {}
        primary_keys.each do |key, value|
          options[key] = value unless value.nil?
        end

        Unresponsys::Row.new(@table, options)
      end
    end
  end
end
