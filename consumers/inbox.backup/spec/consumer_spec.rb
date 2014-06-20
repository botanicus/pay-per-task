#
# This is an integration test, it assumes that the consumer is up and running!
#

require 'spec_helper'

describe 'inbox.backup consumer' do
  it 'writes the payload to the data directory', amqp: true do
    username = "rand-user-#{rand(100_000)}"

    @channel.topic('amq.topic').publish('blob', routing_key: "inbox.pt.#{username}")
    path = File.join(PPT.root, "data/inbox/pt/#{username}")

    sleep 0.1
    backed_up_content = File.read(Dir.glob("#{path}/*.json").first)
    expect(backed_up_content).to eq("blob\n")
  end

  after(:each) do
    system "rm -rf #{File.join(PPT.root, 'data')}"
  end
end
