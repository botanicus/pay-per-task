require 'spec_helper'
require 'json'

require 'ppt/presenters'

describe PPT::Presenters::Story do
  let(:valid_values) {{
    service: 'pt',
    username: 'botanicus',
    id: 101,
    price: 75,
    currency: 'EUR',
    link: 'http://jira.org/a/b/c'
  }}

  describe ".new(values)" do
    it "takes only certain keys" do
      expect {
        described_class.new(valid_values)
      }.not_to raise_error

      expect {
        described_class.new(valid_values.merge(a: 'test'))
      }.to raise_error(ArgumentError)
    end

    # This is why we can't use **values from Ruby 2.0,
    # it only works with symbols, hence we can't do
    # PPT::Presenters::User.new(**JSON.parse(payload))
    it "also works with keys being strings" do
      values = valid_values.reduce(Hash.new) do |buffer, (key, value)|
        buffer.merge!(key.to_s => value)
      end

      # Just to make sure ...
      values['service'].should eql('pt')

      expect {
        described_class.new(valid_values)
      }.not_to raise_error
    end
  end

  describe "accessors" do
    subject { described_class.new(valid_values) }

    context "valid" do
      [:service, :username, :id, :price, :currency, :link].each do |property|
        it "allows you to read #{property}" do
          subject.should respond_to(property)
          subject.send(property).should eql(valid_values[property])
        end
      end
    end

    context "invalid" do
      it "raises NoMethodError if you try to read non-existing property" do
        subject.should_not respond_to(:juiciness)
        expect { subject.juiciness }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#to_json" do
    subject { described_class.new(valid_values) }

    it "converts values to JSON" do
      subject.to_json.should eql(valid_values.to_json)
    end
  end
end
