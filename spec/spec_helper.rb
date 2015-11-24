require 'bundler/setup'
require 'dotenv'
require 'unresponsys'
require 'rspec'
require 'vcr'
require 'webmock'
require 'byebug'

Dotenv.load

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end
