require 'spec_helper'

describe Unresponsys::ExtensionTable do

  before :each do
    @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
    allow(@client).to receive(:authenticate).and_return(true)

    VCR.use_cassette('get_existing_member') do
      list = @client.lists.find('TestDataList')
      @member = list.members.find('kwkimball@gmail.com')
    end

    @table = @member.extension_tables.find('TestExtensionTable')
  end

  describe '#update' do
    context 'existing record' do
      it 'posts to Responsys' do
        VCR.use_cassette('update_existing_extension_row') do
          expect(@client).to receive(:post).and_call_original
          @table.update(title: 'My New Title')
        end
      end

      it 'returns true' do
        VCR.use_cassette('update_existing_extension_row') do
          expect(@table.update(title: 'My New Title')).to eq(true)
        end
      end
    end

    context 'new record' do

    end
  end

end
