require 'spec_helper'
require 'ppt/presenters'

describe PPT::Presenters do
  describe PPT::Presenters::Entity do
  end

  describe PPT::Presenters::User do
    let(:attrs) {{
      service: 'pt',
      username: 'ppt',
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
  end

  describe PPT::Presenters::Story do
  end
end
