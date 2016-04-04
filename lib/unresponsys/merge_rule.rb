class Unresponsys::MergeRule
  def to_h
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
