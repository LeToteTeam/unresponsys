class Unresponsys
  class Member
    extend Forwardable
    delegate [:client] => :list
    attr_reader :list

    def initialize(list, fields)
      fields    = default_fields.merge(fields)
      @list     = list
      @changed  = []

      fields.each_pair do |key, val|
        str = key.downcase.chomp('_')
        var = "@#{str}".to_sym
        val = val.to_ruby
        self.instance_variable_set(var, val)

        # getter
        self.class.send(:attr_reader, str)

        # setter
        next if immutable_fields.include?(key)
        @changed << key
        self.class.send(:define_method, "#{str}=") do |val|
          @changed << key
          val = val.to_ruby
          self.instance_variable_set(var, val)
        end
      end
    end

    def save
      record_data = { fieldNames: [], records: [[]], mapTemplateName: nil }
      @changed.uniq.each do |key|
        record_data[:fieldNames] << key
        var = "@#{key.downcase.chomp('_')}".to_sym
        val = self.instance_variable_get(var)
        val = val.to_responsys
        record_data[:records][0] << val
      end

      options = { body: { recordData: record_data, mergeRule: merge_rule }.to_json }
      r = client.post("/lists/#{@list.name}/members", options)
      return false if r['recordData']['records'][0][0].include?('MERGEFAILED')

      @changed = ['EMAIL_ADDRESS_']
      self.instance_variable_set(:@riid, r['recordData']['records'][0][0])
      true
    end

    # allow to access custom fields on new record
    def method_missing(sym, *args, &block)
      setter  = sym.to_s.include?('=')
      str     = sym.to_s.chomp('=')
      var     = "@#{str}".to_sym
      val     = args.first

      if setter
        field_name = str.upcase
        @changed << field_name
        val = val.to_ruby
        self.instance_variable_set(var, val)
      else
        self.instance_variable_get(var)
      end
    end

    def events
      @events ||= Events.new(self)
    end

    class Events
      def initialize(member)
        @member = member
      end

      def new(event, properties = {})
        Event.new(member: @member, event: event, properties: properties)
      end
    end

    private

    def default_fields
      {
        'RIID_'                     => '',
        'EMAIL_ADDRESS_'            => '',
        'MOBILE_NUMBER_'            => '',
        'CUSTOMER_ID_'              => '',
        'EMAIL_PERMISSION_STATUS_'  => '',
        'EMAIL_PERMISSION_REASON_'  => '',
        'POSTAL_STREET_1_'          => '',
        'POSTAL_STREET_2_'          => '',
        'CITY_'                     => '',
        'STATE_'                    => '',
        'POSTAL_CODE_'              => '',
        'COUNTRY_'                  => '',
        'EMAIL_MD5_HASH_'           => '',
        'EMAIL_SHA256_HASH_'        => ''
      }
    end

    def immutable_fields
      %w(
        RIID_
        EMAIL_MD5_HASH_
        EMAIL_SHA256_HASH_
        EMAIL_PERMISSION_REASON_
        CREATED_SOURCE_IP_
        EMAIL_DOMAIN_
        EMAIL_ISP_
        EMAIL_DELIVERABILITY_STATUS_
        MOBILE_DELIVERABILITY_STATUS_
        MOBILE_PERMISSION_REASON_
        POSTAL_DELIVERABILITY_STATUS_
        POSTAL_PERMISSION_REASON_
        CREATED_DATE_
        MODIFIED_DATE_
      )
    end

    def merge_rule
      {
        insertOnNoMatch:            true,
        updateOnMatch:              'REPLACE_ALL',
        matchColumnName1:           'EMAIL_ADDRESS_',
        matchColumnName2:           nil,
        matchOperator:              nil,
        optinValue:                 'I',
        optoutValue:                'O',
        defaultPermissionStatus:    'OPTIN',
        htmlValue:                  'H',
        textValue:                  'T',
        rejectRecordIfChannelEmpty: nil,
      }
    end
  end
end
