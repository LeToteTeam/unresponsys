require 'spec_helper'

describe Unresponsys::List do

  before :each do
    @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
    allow(@client).to receive(:authenticate).and_return(true)

    list    = @client.lists.find('TestDataList')
    member  = list.members.new('kwkimball@gmail.com')
    member.save
  end

  it '.find returns an instance of List' do
    list = @client.lists.find('TestDataList')
    expect(list).to be_an_instance_of(Unresponsys::List)
  end

  context do
    before :each do
      @list = @client.lists.find('TestDataList')
    end

    it '#members.find returns an instance of Member when a member exists' do
      VCR.use_cassette('find_member_exists') do
        member = @list.members.find('kwkimball@gmail.com')
        expect(member).to be_an_instance_of(Unresponsys::Member)
      end
    end

    it '#members.find raises an error when a member doesnt exist' do
      VCR.use_cassette('find_member_doesnt_exist') do
        expect {
          @list.members.find('kwkimball+foo@gmail.com')
        }.to raise_error(Unresponsys::NotFoundError)
      end
    end

    it '#members.new returns an instance of Member' do
      member = @list.members.new('kwkimball@gmail.com')
      expect(member).to be_an_instance_of(Unresponsys::Member)
    end

    it '#extension_tables.find returns an instance of ExtensionTable' do
      table = @list.extension_tables.find('MyTable')
      expect(table).to be_an_instance_of(Unresponsys::ExtensionTable)
    end
  end

end
