require 'spec_helper'
require 'factories'

require 'ppt/db'

describe PPT::DB::User do
  let(:presenter) do
    PPT::Presenters::User.new(F[:user])
  end

  describe ".new(presenter)" do
    it "takes presenter as the first argument" do
      expect {
        described_class.new(presenter)
      }.not_to raise_error
    end
  end

  describe "#key" do
    subject { described_class.new(presenter) }

    it "sets up the key" do
      subject.key.should eql('users.botanicus')
    end
  end

  describe "#values" do
    subject { described_class.new(presenter) }

    it "should be values of the presenter" do
      subject.values.should eql(F[:user])
    end
  end

  describe "#save" do
    subject { described_class.new(presenter) }

    it "saves the object to DB under its key with given values" do
      subject.save

      F[:user].each do |property, value|
        PPT::DB.redis.hget(subject.key, property).should eql(value)
      end
    end
  end
end
