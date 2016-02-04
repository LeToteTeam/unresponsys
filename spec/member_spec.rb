require 'spec_helper'

describe Unresponsys::Member do

  before :each do
    @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
    allow(@client).to receive(:authenticate).and_return(true)
  end

  context 'when an existing member' do
    before :each do
      VCR.use_cassette('get_existing_member') do
        @list = @client.lists.find('TestDataList')
        @member = @list.members.find('kwkimball@gmail.com')
      end
    end

    it 'Responsys attributes can be changed' do
      @member.city = 'San Francisco'
      expect(@member.city).to eq('San Francisco')
    end

    it 'custom attributes can be changed' do
      @member.first_name = 'Kevin'
      expect(@member.first_name).to eq('Kevin')
    end

    describe '#save' do
      it 'posts to Responsys' do
        VCR.use_cassette('save_existing_member') do
          expect(@client).to receive(:post).and_call_original
          @member.save
        end
      end

      it 'returns true' do
        VCR.use_cassette('save_existing_member') do
          expect(@member.save).to eq(true)
        end
      end

      it 'custom text attributes can be saved' do
        VCR.use_cassette('save_existing_member_with_text') do
          @member.last_name = 'Kimball'
          @member.save
          @member = @list.members.find('kwkimball@gmail.com')
          expect(@member.last_name).to eq('Kimball')
        end
      end

      it 'custom number attributes can be saved' do
        VCR.use_cassette('save_existing_member_with_number') do
          @member.total_revenue = 101.23
          @member.save
          @member = @list.members.find('kwkimball@gmail.com')
          expect(@member.total_revenue).to eq(101.23)
        end
      end

      it 'custom integer attributes can be saved' do
        VCR.use_cassette('save_existing_member_with_integer') do
          @member.age = 30
          @member.save
          @member = @list.members.find('kwkimball@gmail.com')
          expect(@member.age).to eq(30)
        end
      end

      it 'custom timestamp attributes can be saved' do
        VCR.use_cassette('save_existing_member_with_timestamp') do
          time = Time.new(2015, 10, 7, 5, 00, 00, '-07:00')
          @member.last_purchase = time
          @member.save
          @member = @list.members.find('kwkimball@gmail.com')
          expect(@member.last_purchase).to eq(time)
        end
      end

      it 'custom boolean attributes can be saved' do
        VCR.use_cassette('save_existing_member_with_boolean') do
          @member.mom = false
          @member.save
          @member = @list.members.find('kwkimball@gmail.com')
          expect(@member.mom).to eq(false)
        end
      end
    end

    it '#events.new returns an instance of Event' do
      expect(@member.events.new('MyEvent')).to be_an_instance_of(Unresponsys::Event)
    end
  end

  context 'when a new member' do
    before :each do
      list = @client.lists.find('TestDataList')
      @member = list.members.new('kwkimball+bar@gmail.com')
    end

    it 'Responsys attributes can be changed' do
      @member.city = 'San Francisco'
      expect(@member.city).to eq('San Francisco')
    end

    it 'custom attributes can be changed' do
      @member.first_name = 'Kevin'
      expect(@member.first_name).to eq('Kevin')
    end

    describe '#save' do
      it 'posts to Responsys' do
        VCR.use_cassette('save_new_member') do
          expect(@client).to receive(:post).and_call_original
          @member.save
        end
      end

      it 'returns true' do
        VCR.use_cassette('save_new_member') do
          expect(@member.save).to eq(true)
        end
      end
    end
  end

end
