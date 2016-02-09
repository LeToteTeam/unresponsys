class Unresponsys
  class Row
    extend Forwardable
    delegate [:client] => :table
    attr_reader :table

    def initialize(table, fields)
      @table  = table
      @fields = fields

      @fields.each_pair do |key, val|
        str = key.downcase.chomp('_')
        var = "@#{str}".to_sym
        val = val.to_ruby
        self.instance_variable_set(var, val)

        if key == 'ID_' || key == 'RIID_'
          self.class.send(:attr_reader, str)
        else
          self.class.send(:define_method, "#{str}=") do |val|
            val = val.to_ruby
            self.instance_variable_set(var, val)
          end
        end
      end
    end

    def save
      record_data = { fieldNames: [], records: [{ fieldValues: [] }], mapTemplateName: nil }

      @fields.each_pair do |key, val|
        record_data[:fieldNames] << key
        var = "@#{key.downcase.chomp('_')}".to_sym
        val = self.instance_variable_get(var)
        val = val.to_responsys
        record_data[:records][0][:fieldValues] << val
      end

      options = {
        body: {
          recordData: record_data,
          insertOnNoMatch: true,
          updateOnMatch: 'REPLACE_ALL',
        }
      }

      if @table.class == Unresponsys::SupplementalTable
        url = "/folders/#{@table.folder.name}/suppData/#{@table.name}"
      else
        options[:body][:matchColumn] = 'RIID'
        url = "/lists/#{@table.list.name}/listExtensions/#{@table.name}"
      end

      options[:body] = options[:body].to_json
      r = client.post(url, options)

      if @table.class == Unresponsys::SupplementalTable
        r['errorMessage'].blank?
      else
        r[0]['errorMessage'].blank?
      end
    end

    # allow to access custom fields on new record
    def method_missing(sym, *args, &block)
      setter  = sym.to_s.include?('=')
      str     = sym.to_s.chomp('=')
      var     = "@#{str}".to_sym
      val     = args.first

      if setter
        field_name = str.upcase
        @fields[field_name] = ''
        val = val.to_ruby
        self.instance_variable_set(var, val)
      else
        self.instance_variable_get(var)
      end
    end
  end
end
