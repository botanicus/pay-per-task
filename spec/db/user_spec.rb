require 'spec_helper'
require 'factories'

require 'ppt/db'

describe PPT::DB::User do
  let(:values) { F[:user] }

  describe ".new(values)" do
    it "takes presenter values as the first argument" do
      expect {
        described_class.new(values)
      }.not_to raise_error
    end
  end

  describe "#key" do
    subject { described_class.new(values) }

    it "sets up the key" do
      subject.key.should eql('users.botanicus')
    end
  end

  describe "#values" do
    subject { described_class.new(values) }

    it "should be values of the presenter" do
      subject.values.should eql(subject.presenter.values)
    end
  end

  describe "#presenter" do
    subject { described_class.new(values) }

    it "is an instance of corresponding presenter class" do
      subject.presenter.should be_kind_of(PPT::Presenters::User)
    end
  end

  describe "#save" do
    subject { described_class.new(values) }

    it "saves the object to DB under its key with given values" do
      subject.save

      values.each do |property, value|
        PPT::DB.redis.hget(subject.key, property).should eql(value)
      end
    end
  end
end
