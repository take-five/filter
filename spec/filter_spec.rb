require File.expand_path('../test_helper', __FILE__)

describe Enumerable do
  it "should return Enumerator" do
    result = [1, 2, 3].filter

    result.should be_a(Enumerator)
  end

  it "should return equivalent Enumerator on null input" do
    [1, 2].filter.to_a.should == [1, 2]
  end

  it "should match regular expressions" do
    [1, 2, 3, 'ba'].filter(/ba/).to_a.should == ['ba']
  end

  it "should match against symbols" do
    [1, 2, 3].filter(:even?).to_a.should == [2]
  end

  it "should match against lambdas" do
    [1, 2, 3].filter(lambda{|n| n.even?}).to_a.should == [2]
  end

  it "should match against blocks" do
    [1, 2, 3].filter { |n| n.even? }.to_a.should == [2]
  end

  it "should support #map" do
    [1, 2, 3].filter(:even?) { |n| n + 1 }.to_a.should == [3]
  end

  it "should match against Hash" do
    [1, 2, 3, 4.2].filter(:to_i => :even?).to_a.should == [2, 4.2]
    [2, 3, 4.2].filter(:to_i => :even?, :ceil => :odd?).to_a.should == [4.2]
  end

  it "should match against Class and Module" do
    c = Class.new {}
    m = Module.new {}
    i = c.new

    [c, i, 1].filter(c).to_a.should == [c, i]
    [c, m, i, 1].filter(m).to_a.should == [m]
  end

  it "should match against Array" do
    [0, 1].filter([:even?, :zero?]).to_a.should == [0]
  end

  it "should match against true or false" do
    [0, false, 2, nil].filter(true).to_a.should == [0, 2]
    [0, false, 2, nil].filter(false).to_a.should == [false, nil]
  end
end