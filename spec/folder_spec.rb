require 'spec_helper'

describe Unresponsys::Folder do

  before(:each) do
    @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
    allow(@client).to receive(:authenticate).and_return(true)
  end

  it '.find returns an instance of Folder' do
    folder = @client.folders.find('TestData')
    expect(folder).to be_an_instance_of(Unresponsys::Folder)
  end

  context do
    before :each do
      @folder = @client.folders.find('TestData')
    end

    it '#supplemental_tables.find returns an instance of SupplementalTable' do
      table = @folder.supplemental_tables.find('MyTable')
      expect(table).to be_an_instance_of(Unresponsys::SupplementalTable)
    end
  end

end
