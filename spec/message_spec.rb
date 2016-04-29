require 'spec_helper'

describe Unresponsys::Message do

  before(:each) do
    @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
    allow(@client).to receive(:authenticate).and_return(true)

    VCR.use_cassette('get_existing_member') do
      list = @client.lists.find('TestDataList')
      @member = list.members.find('kwkimball@gmail.com')
    end
  end

  describe '#save' do
    before(:each) do
      @message = @member.messages.new('KevinTest')
    end

    it 'posts to Responsys' do
      VCR.use_cassette('save_new_message') do
        expect(@client).to receive(:post).and_call_original
        @message.save
      end
    end

    it 'returns true' do
      VCR.use_cassette('save_new_message') do
        expect(@message.save).to eq(true)
      end
    end

    context 'with optional data' do
      it 'returns true' do
        VCR.use_cassette('save_new_message_optional_data') do
          @message = @member.messages.new('KevinTest', testdata: 'success')
          expect(@message.save).to eq(true)
        end
      end
    end

    context 'with undefined campaign' do
      it 'returns an error' do
        VCR.use_cassette('save_new_message_undefined') do
          @message = @member.messages.new('MyMessage')
          expect { @message.save }.to raise_error(Unresponsys::NotFound)
        end
      end
    end
  end

end
