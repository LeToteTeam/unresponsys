$:.push File.expand_path("../lib", __FILE__)
require 'unresponsys/version'

Gem::Specification.new do |s|
  s.name                  = 'unresponsys'
  s.version               = Unresponsys::VERSION
  s.authors               = ['Kevin Kimball']
  s.email                 = ['kevin@letote.com']
  s.summary               = 'an opinionated Ruby wrapper for Responsys REST API'
  s.files                 = Dir["{lib}/**/*"]
  s.test_files            = Dir["{spec}/**/*"]
  s.post_install_message  = 'responsys sucks :('

  s.add_runtime_dependency 'httparty', '~> 0.13', '>= 0.13.5'

  s.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  s.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.0'
  s.add_development_dependency 'webmock', '~> 1.22', '>= 1.22.3'
  s.add_development_dependency 'dotenv', '~> 2.0', '>= 2.0.2'
  s.add_development_dependency 'byebug', '~> 8.0', '>= 8.0.1'
end
