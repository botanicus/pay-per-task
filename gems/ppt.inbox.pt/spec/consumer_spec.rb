#
# This is an integration test, it assumes that the consumer is up and running!
#

require 'spec_helper'
require 'redis'

describe 'ppt.inbox.pt consumer' do
  let(:redis) { Redis.new(driver: :hiredis) }

  # This is a prerequisite for the test, but in case we forget.
  it 'is up and running' do
    expect(%x(status ppt.inbox.pt)).to match(/start\/running/)
  end

  it 'parses the payload and stores the data to Redis', redis: true, amqp: true do
    data = File.read('spec/data/sample_data.json')
    @channel.topic('amq.topic').publish(data, routing_key: 'inbox.pt.ppt')

    sleep 0.1

    # Now we can either use the API models provide
    # or we can go directly to Redis. Either approach
    # is valid. I decided to go for using Redis directly,
    # because this way it's really self-explanatory,
    # so the spec fullfils its purpose as being both
    # the test and (part of) the documentation.
    dev = redis.hgetall('devs.ppt.botanicus')
    expect(dev).to eq('a')

    story = redis.hgetall('stories.ppt.60839620')
    expect(story).to eq('')

    # check if the dev was published to devs.new
    # check if the story was published to stories.new
  end

  # TODO: Copy this to ppt.inbox.backup.
  it 'ignores malformatted JSON'
end
