class Unresponsys
  class Member

    DEFAULT_FIELDS = {
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

    IMMUTABLE_FIELDS = %w(
      RIID_
      EMAIL_ADDRESS_
      MOBILE_NUMBER_
      EMAIL_MD5_HASH_
      EMAIL_SHA256_HASH_
    )

    RECORD_DATA = { fieldNames: [], records: [[]], mapTemplateName: nil }

    MERGE_RULE = {
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

    # initialize a member
    def initialize(list_name, fields)
      # save these for later
      @fields     = DEFAULT_FIELDS.merge(fields)
      @list_name  = list_name
      @changed    = ['EMAIL_ADDRESS_']

      @fields.each_pair do |key, val|
        str = key.downcase.chomp('_')
        var = "@#{str}".to_sym
        val = val.to_responsys
        self.instance_variable_set(var, val)

        # getter
        self.class.send(:attr_reader, str)

        if IMMUTABLE_FIELDS.exclude?(key)
          # setter w/ change tracker
          self.class.send(:define_method, "#{str}=") do |val|
            @changed << key
            self.instance_variable_set(var, val)
          end
        end
      end
    end

    def email
      email_address
    end

    def list
      @list_name
    end

    # create or update the member
    def save
      body = { recordData: RECORD_DATA.deep_dup, mergeRule: MERGE_RULE.dup }

      @fields.each_pair do |key, val|
        # can't send unless val changed or API breaks
        next unless @changed.include?(key)

        body[:recordData][:fieldNames] << key
        var = "@#{key.downcase.chomp('_')}".to_sym
        val = self.instance_variable_get(var)
        val = val.to_responsys
        body[:recordData][:records][0] << val
      end

      r = Unresponsys::Client.post("/lists/#{@list_name}/members", body: body.to_json)
      return false if r['recordData']['records'][0][0].include?('MERGEFAILED')
      @changed = ['EMAIL_ADDRESS_']
      self.instance_variable_set(:@riid, r['recordData']['records'][0][0])
      true
    end

    # delete the member from the list
    def delete
      self.email_permission_status = 'O'
      self.save
    end

    def deleted?
      self.email_permission_status == 'O'
    end

    # access a member's events
    def events
      @events ||= Events.new(self)
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
        @changed << field_name
        self.instance_variable_set(var, val)
      else
        self.instance_variable_get(var)
      end
    end

    class Events
      def initialize(member)
        @member = member
      end

      # initialize a new event
      def new(event, properties = {})
        Event.new(member: @member, event: event, properties: properties)
      end
    end

  end
end
