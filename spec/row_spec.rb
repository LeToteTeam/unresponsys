require 'spec_helper'

describe Unresponsys::Row do

  before :each do
    @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
    allow(@client).to receive(:authenticate).and_return(true)
  end

  context 'when an existing row' do

  end

  context 'when a new row' do
    before :each do
      folder  = @client.folders.find('TestData')
      @table  = folder.supplemental_tables.find('TestTable')
      @row    = @table.rows.new(1)

      # at least one field must be set
      @row.title = 'My Title'
    end

    describe '#save' do
      it 'posts to Responsys' do
        VCR.use_cassette('save_new_row') do
          expect(@client).to receive(:post).and_call_original
          @row.save
        end
      end

      it 'returns true' do
        VCR.use_cassette('save_new_row') do
          expect(@row.save).to eq(true)
        end
      end
    end

    describe '#to_h' do
      it 'returns the correct hash' do
        hash = {
          'ID_' => '1',
          'TITLE' => 'My Title'
        }
        expect(@row.to_h).to include(hash)
      end
    end
  end
end
