require 'spec_helper'

require 'ppt/extensions'

describe PPT do
  describe ".symbolise_keys(hash)" do
    it "converts hash with string keys to a hash with symbol keys" do
      PPT.symbolise_keys('a' => 1, :b => 2).should eql({a: 1, b: 2})
    end
  end
end