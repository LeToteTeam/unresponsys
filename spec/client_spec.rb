require 'spec_helper'

describe Unresponsys::Client do
  it '#authenticate is success' do
    VCR.use_cassette('authenticate_client') do
      expect {
        @client = Unresponsys::Client.new(username: ENV['R_USER'], password: ENV['R_PASS'])
      }.not_to raise_error
      expect(@client.token).not_to be_nil
      expect(@client.endpoint).not_to be_nil
    end
  end
end
