require 'spec_helper'
require 'ppt/presenters'

describe PPT::Presenters do
  describe PPT::Presenters::Entity do
    let(:subclass) do
      Class.new(described_class) do |klass|
        klass::EXPECTED_KEYS = [:id, :username]
      end
    end

    describe '#initialize' do
      it 'throws an error if whatever has been specified in EXPECTED_KEYS is missing' do
        expect { subclass.new }.to raise_error(ArgumentError)
        expect { subclass.new(Hash.new) }.to raise_error(ArgumentError)
        expect { subclass.new(username: 'botanicus') }.to raise_error(ArgumentError)
      end

      it 'throws an error if there are any extra arguments' do
        expect { subclass.new(id: 1, username: 'botanicus', extra: 'x') }.to raise_error(ArgumentError)
      end

      it 'succeeds if just the right arguments have been provided' do
        expect { subclass.new(id: 1, username: 'botanicus') }.not_to raise_error
      end
    end

    describe '#values' do
      it 'returns values as a hash' do
        instance = subclass.new(id: 1, username: 'botanicus')
        expect(instance.values[:id]).to eq(1)
        expect(instance.values[:username]).to eq('botanicus')
      end
    end

    describe 'accessors' do
      it 'provides accessors for all the EXPECTED_KEYS' do
        instance = subclass.new(id: 1, username: 'botanicus')
        expect(instance.id).to eq(1)
        expect(instance.username).to eq('botanicus')

        expect(instance.respond_to?(:username)).to be(true)
      end
    end

    describe '#to_json' do
      it 'converts #values to JSON' do
        instance = subclass.new(id: 1, username: 'botanicus')
        expect(instance.to_json).to eq('{"id":1,"username":"botanicus"}')
      end
    end
  end

  describe PPT::Presenters::User do
    let(:attrs) {{
      service: 'pt',
      username: 'ppt',
      name: 'PayPerTask Ltd',
      email: 'james@pay-per-task.com',
      accounting_email: 'accounting@pay-per-task.com'
    }}

    it 'raises an exception if service is missing' do
      attrs.delete(:service)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if username is missing' do
      attrs.delete(:username)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if name is missing' do
      attrs.delete(:name)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if email is missing' do
      attrs.delete(:email)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if accounting_email is missing' do
      attrs.delete(:accounting_email)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'returns a valid presenter if all the required arguments have been provided' do
      expect { described_class.new(attrs) }.to_not raise_error
    end
  end

  describe PPT::Presenters::Developer do
    let(:attrs) {{
      company: 'ppt',
      username: 'botanicus',
      name: 'James C Russell',
      email: 'contracts@101ideas.cz'
    }}

    it 'raises an exception if company is missing' do
      attrs.delete(:company)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if username is missing' do
      attrs.delete(:username)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if name is missing' do
      attrs.delete(:name)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if email is missing' do
      attrs.delete(:email)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'returns a valid presenter if all the required arguments have been provided' do
      expect { described_class.new(attrs) }.to_not raise_error
    end
  end

  describe PPT::Presenters::Story do
    let(:attrs) {{
      company: 'ppt',
      id: 957456,
      price: 120,
      currency: 'GBP',
      link: 'http://www.pivotaltracker.com/story/show/60839620'
    }}

    it 'raises an exception if company is missing' do
      attrs.delete(:company)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if id is missing' do
      attrs.delete(:id)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if price is missing' do
      attrs.delete(:price)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if currency is missing' do
      attrs.delete(:currency)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'raises an exception if link is missing' do
      attrs.delete(:link)
      expect { described_class.new(attrs) }.to raise_error(ArgumentError)
    end

    it 'returns a valid presenter if all the required arguments have been provided' do
      expect { described_class.new(attrs) }.to_not raise_error
    end
  end
end
