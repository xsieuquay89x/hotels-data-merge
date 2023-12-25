# rails_helper.rb or spec/support/redis.rb
require 'redis'
require 'mock_redis' # You can use a mock library for testing

# Use a mock Redis connection for testing
if Rails.env.test?
  REDIS_CONFIG = { url: 'redis://localhost:6379/1' }
  $redis = MockRedis.new(REDIS_CONFIG)
else
  REDIS_CONFIG = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/1' }
  $redis = Redis.new(REDIS_CONFIG)
end

# Ensure $redis is cleaned between tests
RSpec.configure do |config|
  config.before(:suite) do
    $redis.flushdb if Rails.env.test?
  end

  config.after(:each) do
    $redis.flushdb if Rails.env.test?
  end
end
