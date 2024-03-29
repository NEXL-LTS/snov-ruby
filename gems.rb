source "https://rubygems.org"

# Specify your gem's dependencies in snov.gemspec
gemspec

gem "byebug"
gem 'mock_redis'
gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem "rubocop"
gem "rubocop-rspec"
gem "simplecov"
gem "webmock"

if ENV['GEM_VERSIONS'] == 'min'
  gem 'activemodel', '~> 4.1.0'
  gem 'activesupport', '~> 4.1.0'
  gem 'camel_snake_struct', '~> 0.1.0'
  gem 'faraday', '~> 0.10.0'
  gem 'multi_json', '~> 1.4.0'
end
