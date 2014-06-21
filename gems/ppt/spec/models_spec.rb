require 'spec_helper'

describe PPT::Presenters::User do
  let(:attrs) {{
    service: 'pt',
    username: 'ppt',
    name: 'PayPerTask Ltd',
    email: 'james@pay-per-task.com',
    accounting_email: 'accounting@pay-per-task.com'
  }}

  it 'raises an exception if service is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :service })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if username is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :username })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if name is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :name })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if email is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :email })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'returns a valid presenter if all the required arguments have been provided' do
    expect { described_class.new(attrs).validate }.to_not raise_error
  end
end

describe SimpleORM::Presenters::Developer do
  let(:attrs) {{
    company: 'ppt',
    username: 'botanicus',
    name: 'James C Russell',
    email: 'contracts@101ideas.cz'
  }}

  it 'raises an exception if company is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :company })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if username is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :username })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if name is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :name })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if email is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :email })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'returns a valid presenter if all the required arguments have been provided' do
    expect { described_class.new(attrs).validate }.to_not raise_error
  end
end

describe SimpleORM::Presenters::Story do
  let(:attrs) {{
    company: 'ppt',
    id: 957456,
    title: 'Implement login',
    price: 120,
    currency: 'GBP',
    link: 'http://www.pivotaltracker.com/story/show/60839620'
  }}

  it 'raises an exception if company is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :company })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if id is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :id })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if title is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :title })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if price is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :price })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if currency is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :currency })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'raises an exception if link is missing' do
    instance = described_class.new(attrs.reject { |key, value| key == :link })
    expect { instance.validate }.to raise_error(SimpleORM::Presenters::ValidationError)
  end

  it 'returns a valid presenter if all the required arguments have been provided' do
    expect { described_class.new(attrs).validate }.to_not raise_error
  end
end


describe SimpleORM::DB::User do
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
      expect(data).to eq({'service'          => 'pt',
                          'username'         => 'ppt',
                          'name'             => 'PayPerTask Ltd',
                          'email'            => 'james@pay-per-task.com',
                          'accounting_email' => 'accounting@pay-per-task.com',
                          'created_at'       => '1403347217'})
    end
  end
end

describe SimpleORM::DB::Developer do
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
      expect(data).to eq({'company'    => 'ppt',
                          'username'   => 'botanicus',
                          'name'       => 'James C Russell',
                          'email'      => 'contracts@101ideas.cz',
                          'created_at' => '1403347217'})
    end
  end
end

describe SimpleORM::DB::Story do
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
      expect(data).to eq({'company'    => 'ppt',
                          'id'         => '957456',
                          'price'      => '120',
                          'currency'   => 'GBP',
                          'link'       => 'http://www.pivotaltracker.com/story/show/60839620',
                          'created_at' => '1403347217'})
    end
  end
end

