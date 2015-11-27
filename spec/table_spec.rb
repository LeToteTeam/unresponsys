require 'spec_helper'

describe Unresponsys::Table do

  before(:each) do
    # setup connection
    Unresponsys::Client.new(
      username: ENV['R_USER'],
      password: ENV['R_PASS'],
      debug:    false
    )
    allow_any_instance_of(Unresponsys::Client).to receive(:authenticate).and_return(true)

    folder  = Unresponsys::Folder.find('TestData')
    @table  = folder.tables.find('TestTable')
  end

  # it '#rows.find returns an instance of Row when a row exists' do
  #   VCR.use_cassette('find_row_exists') do
  #     row = @table.rows.find(1)
  #     expect(row).to be_an_instance_of(Unresponsys::Row)
  #   end
  # end

  it '#rows.find raises an error when a row does not exist' do
    VCR.use_cassette('find_row_doesnt_exist') do
      expect {
        @table.rows.find(2)
      }.to raise_error(Unresponsys::NotFoundError)
    end
  end

  it '#rows.new returns an instance of Row' do
    row = @table.rows.new(2)
    expect(row).to be_an_instance_of(Unresponsys::Row)
  end

end
