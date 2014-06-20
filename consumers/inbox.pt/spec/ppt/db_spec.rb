require 'spec_helper'
require 'ppt/db'

describe PPT::DB do
  let(:redis) { Redis.new(driver: :hiredis) }

  before(:each) { redis.flushdb }

  describe PPT::DB::Entity do
    let(:subclass) do
      Class.new(described_class) do |klass|
        klass::EXPECTED_KEYS = [:id, :username]
      end
    end
  end

  describe PPT::DB::User do
    subject { described_class.new(attrs) }

    let(:attrs) {{
      service: 'pt',
      username: 'ppt',
      name: 'PayPerTask Ltd',
      email: 'james@pay-per-task.com',
      accounting_email: 'accounting@pay-per-task.com'
    }}

    describe '#key' do
      it 'is users.username' do
        expect(subject.key).to eq('users.ppt')
      end
    end

    describe '#save' do
      it 'saves data of its presenter as a Redis hash' do
        subject.save
        data = redis.hgetall(subject.key)
        expect(data).to eq({'service' => 'pt',
                            'username'=> 'ppt',
                            'name'    => 'PayPerTask Ltd',
                            'email'   => 'james@pay-per-task.com',
                            'accounting_email' => 'accounting@pay-per-task.com'})
      end
    end
  end

  describe PPT::DB::Developer do
    subject { described_class.new(attrs) }

    let(:attrs) {{
      company: 'ppt',
      username: 'botanicus',
      name: 'James C Russell',
      email: 'contracts@101ideas.cz'
    }}

    describe '#key' do
      it 'is devs.company.username' do
        expect(subject.key).to eq('devs.ppt.botanicus')
      end
    end

    describe '#save' do
      it 'saves data of its presenter as a Redis hash' do
        subject.save
        data = redis.hgetall(subject.key)
        expect(data).to eq({'company'  => 'ppt',
                            'username' => 'botanicus',
                            'name'     => 'James C Russell',
                            'email'    => 'contracts@101ideas.cz'})
      end
    end
  end

  describe PPT::DB::Story do
    subject { described_class.new(attrs) }

    let(:attrs) {{
      company: 'ppt',
      id: 957456,
      price: 120,
      currency: 'GBP',
      link: 'http://www.pivotaltracker.com/story/show/60839620'
    }}

    describe '#key' do
      it 'is stories.company.id' do
        expect(subject.key).to eq('stories.ppt.957456')
      end
    end

    describe '#save' do
      it 'saves data of its presenter as a Redis hash' do
        subject.save
        data = redis.hgetall(subject.key)
        expect(data).to eq({'company'  => 'ppt',
                            'id'       => '957456',
                            'price'    => '120',
                            'currency' => 'GBP',
                            'link'     => 'http://www.pivotaltracker.com/story/show/60839620'})
      end
    end
  end
end

