require 'spec_helper'
require './processor'

require 'json'
require 'redis'

describe PPT::PT::Processor do
  subject do
    described_class.new(Object.new)
  end

  let(:redis) do
    Redis.new(driver: :hiredis)
  end

  let(:payload) do
    JSON.parse(File.read('spec/data/sample_data.json'))
  end

  describe '#ensure_developer_exists' do
    it 'creates a developer if there is none of given username within a company' do
      subject.ensure_developer_exists('ppt', payload)
    end

    it 'does not create another developer if one of given username already exists within a company' do
      expect {
        subject.ensure_developer_exists('ppt', payload)
      }.not_to change { redis.keys('devs.*').count }
    end
  end

  describe '#ensure_story_exists' do
  end
end
