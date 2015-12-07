require 'spec_helper'

describe Unresponsys::Event do

  before(:each) do
    @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
    # allow(@client).to receive(:authenticate).and_return(true)

    VCR.use_cassette('get_existing_member') do
      list = @client.lists.find('TestDataList')
      @member = list.members.find('kwkimball@gmail.com')
    end
  end

  describe '#save' do
    context 'without extra params' do
      before(:each) do
        @event = @member.events.new('Sign_Up')
      end

      it 'posts to Responsys' do
        VCR.use_cassette('save_new_event') do
          expect(@client).to receive(:post).and_call_original
          @event.save
        end
      end

      it 'returns true' do
        VCR.use_cassette('save_new_event') do
          expect(@event.save).to eq(true)
        end
      end
    end

    context 'with extra params' do
      before(:each) do
        @event = @member.events.new('Sign_Up', { extra: 12345 })
      end

      it 'posts to Responsys' do
        VCR.use_cassette('save_new_event_with_params') do
          expect(@client).to receive(:post).and_call_original
          @event.save
        end
      end

      it 'returns true' do
        VCR.use_cassette('save_new_event_with_params') do
          expect(@event.save).to eq(true)
        end
      end
    end

    context 'with undefined event' do
      it 'returns an error' do
        VCR.use_cassette('save_new_event_undefined') do
          @event = @member.events.new('MyEvent')
          expect { @event.save }.to raise_error(Unresponsys::NotFoundError)
        end
      end
    end
  end

end
