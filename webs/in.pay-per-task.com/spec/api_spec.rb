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

describe 'POST /pt/botanicus/:auth_key', auth_key: 'Wb9CdGTqEr7msEcPBrHPinsxRxJdM' do
  it 'registers the request' do
    expect(response.code).to eql(201)
  end
end
