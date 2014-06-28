#
# This is an integration test, it assumes that the consumer is up and running!
#

require 'spec_helper'

describe 'ppt.inbox.pt consumer' do
  let(:username) { "rand-user-#{rand(100_000)}" }

  it 'parses the payload and stores the data to Redis', amqp: true do
    data = File.read('spec/data/sample_data.json')
    @channel.topic('amq.topic').publish(data, routing_key: "inbox.pt.#{username}")

    sleep 0.1
  end

  after(:each) do
    # This happens only if ppt.inbox.backup is running.
    system "rm -rf #{PPT.root}/data/inbox/pt/#{username}.yml"
  end
end
