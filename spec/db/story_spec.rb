require 'spec_helper'
require 'factories'

require 'ppt/db'

describe PPT::DB::Story do
  let(:presenter) do
    PPT::Presenters::Story.new(F[:story])
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
      subject.key.should eql('stories.pt.botanicus.101')
    end
  end

  describe "#values" do
    subject { described_class.new(presenter) }

    it "should be values of the presenter" do
      subject.values.should eql(F[:story])
    end
  end

  describe "#save" do
    subject { described_class.new(presenter) }

    it "saves the object to DB under its key with given values" do
      subject.save

      F[:story].each do |property, value|
        PPT::DB.redis.hget(subject.key, property).should eql(value.to_s)
      end
    end
  end
end
