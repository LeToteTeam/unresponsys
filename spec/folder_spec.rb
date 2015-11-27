require 'spec_helper'

describe Unresponsys::Folder do

  it '.find returns an instance of Folder' do
    folder = Unresponsys::Folder.find('TestData')
    expect(folder).to be_an_instance_of(Unresponsys::Folder)
  end

  context do
    before :each do
      @folder = Unresponsys::Folder.find('TestData')
    end

    it '#tables.find returns an instance of Table' do
      table = @folder.tables.find('MyTable')
      expect(table).to be_an_instance_of(Unresponsys::Table)
    end
  end

end
