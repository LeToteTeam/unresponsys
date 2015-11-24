require 'spec_helper'

describe Unresponsys::List do

  before(:each) do
    # setup connection
    Unresponsys::Client.new(
      username: ENV['R_USER'],
      password: ENV['R_PASS'],
      debug:    false
    )
    allow(Unresponsys::Client).to receive(:authenticate).and_return(true)

    # make sure record exists
    list = Unresponsys::List.find('TestDataList')
    member = list.members.new('kwkimball@gmail.com')
    member.save
  end

  it '.find returns an instance of List' do
    list = Unresponsys::List.find('TestDataList')
    expect(list).to be_an_instance_of(Unresponsys::List)
  end

  context do
    before(:each) do
      @list = Unresponsys::List.find('TestDataList')
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
  end

end
