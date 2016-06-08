require 'spec_helper'

describe Unresponsys::Client do
  context 'with valid username and password' do
    it 'sets token and endpoint' do
      VCR.use_cassette('authenticate_client') do
        expect {
          @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
        }.not_to raise_error
        expect(@client.token).not_to be_nil
        expect(@client.endpoint).not_to be_nil
      end
    end
  end

  context 'without username and password' do
    it 'raises an error' do
      VCR.use_cassette('authenticate_client_invalid') do
        expect {
          @client = Unresponsys::Client.new
        }.to raise_error
      end
    end
  end
end
