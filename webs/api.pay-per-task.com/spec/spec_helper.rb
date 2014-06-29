require 'ppt/spec_helper'
require 'rspec-sane-http'

PPT::SpecHelper.enforce_vagrant

RSpec.configure do |config|
  config.extend(HttpApi::Extensions)

  config.add_setting(:base_url)
  config.base_url = 'http://api.pay-per-task.dev'

  require 'redis'

  config.before(:all) do
    redis = Redis.new(driver: :hiredis)

    redis.flushdb
    redis.hmset('users.ppt',
      'auth_key', 'Wb9CdGTqEr7msEcPBrHPinsxRxJdM',
      'pt.api_key', '78525a130a030829876309975267aa6a',
      'email', 'james@101ideas.cz',
      'created_at', '2014-06-29T15:13:37+02:00')
  end
end
