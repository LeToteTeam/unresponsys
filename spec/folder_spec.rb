require 'spec_helper'

describe Unresponsys::Folder do

  it '.find returns an instance of Folder' do
    folder = Unresponsys::Folder.find('TestData')
    expect(folder).to be_an_instance_of(Unresponsys::Folder)
  end

end
