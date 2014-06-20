#
# This is an integration test, it assumes that the consumer is up and running!
#

require 'spec_helper'

describe 'inbox.pt consumer' do
  it 'parses the payload and stores the data to Redis', amqp: true do
    # TODO
  end
end

