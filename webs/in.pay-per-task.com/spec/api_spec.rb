require 'bunny'
require 'spec_helper'

describe 'GET /' do
  it 'says that the service is running' do
    expect(response.code).to eql(200)
  end
end

describe 'POST /pt/botanicus/:auth_key', auth_key: 'invalid' do
  it 'says that the user is unauthorised' do
    expect(response.code).to eql(401)
  end
end

describe 'POST /pt/botanicus/:auth_key',
            auth_key: 'Wb9CdGTqEr7msEcPBrHPinsxRxJdM',
            data: 'blob of data from PT' do

  it 'registers the request' do
    message_received = false

    @queue.subscribe do |delivery_info, metadata, payload|
      message_received = true
      expect(payload).to eq('blob of data from PT')
      expect(delivery_info.routing_key).to eq('inbox.pt.botanicus')
    end

    expect(response.code).to eql(201)

    sleep 0.1
    expect(message_received).to eq(true)
  end
end

# This is tested mainly to make sure it doesn't crash.
context '404' do
  shared_examples_for :unknown_resource do
    it 'returns 404' do
      expect(response.code).to eq(404)
    end
  end

  describe('GET /x') { it_behaves_like :unknown_resource }
  describe('GET /x/y') { it_behaves_like :unknown_resource }
  describe('GET /x/y/z') { it_behaves_like :unknown_resource }
  describe('PUT /x/y/z', data: '') { it_behaves_like :unknown_resource }
end

context '400' do
  describe 'POST /x/y/z', data: '' do
    it 'says the service is not supported' do
      expect(response.code).to eq(400)
      expect(response.body.readpartial).to match('Invalid reqest: service "x" isn\'t supported')
    end
  end
end
