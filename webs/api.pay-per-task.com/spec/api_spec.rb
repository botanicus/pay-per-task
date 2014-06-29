require 'spec_helper'
require 'json'

describe 'GET /onboarding/pt/78525a130a030829876309975267aa6a/me' do
  let(:data) do
    JSON.parse(response.body.readpartial)
  end

  # TODO: This absolutely needs VCR, it can easily change.
  it 'returns name, email and list of projects of the user' do
    expect(response.status).to eq(200)

    expect(data['name']).to eq('Jakub Stastny')
    expect(data['email']).to eq('stastny@101ideas.cz')

    expect(data['projects'].length).to be(1)
    expect(data['projects'].first['id']).to be(957456)
    expect(data['projects'].first['name']).to eq('Pay per task thingy')
  end
end
