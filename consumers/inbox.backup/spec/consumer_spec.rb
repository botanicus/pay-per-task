#
# This is an integration test, it assumes that the consumer is up and running!
#

require 'spec_helper'
require 'yaml'

describe 'inbox.backup consumer' do
  let(:username) { "rand-user-#{rand(100_000)}" }

  it 'writes the payload to the data directory', amqp: true do
    pt_data = File.read('spec/data/pt.json')
    @channel.topic('amq.topic').publish(pt_data, routing_key: "inbox.pt.#{username}")

    # Let's use the same routing key just to test we can work with the documents properly.
    jira_data = data = File.read('spec/data/jira.json')
    @channel.topic('amq.topic').publish(jira_data, routing_key: "inbox.pt.#{username}")

    path = File.join(PPT.root, "data/inbox/pt/#{username}.yml")

    sleep 0.1

    backed_up_documents = YAML.load_documents(File.new(path))

    expect(backed_up_documents.length).to eq(2)
    expect(backed_up_documents[0]).to eq(JSON.parse(pt_data))
    expect(backed_up_documents[1]).to eq(JSON.parse(jira_data))
  end

  after(:each) do
    system "rm -rf #{PPT.root}/data/inbox/pt/#{username}.yml"
  end
end
