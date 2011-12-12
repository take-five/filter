require File.expand_path('../test_helper', __FILE__)

describe Enumerable do
  it "should return Enumerable" do
    result = [1, 2, 3].filter

    result.should be_a(Enumerable)
  end

  it "should return equivalent Enumerator on null input" do
    [1, 2].filter.should == [1, 2]
  end

  it "should match regular expressions" do
    [1, 2, 3, 'ba'].filter(/ba/).should == ['ba']
  end

  it "should match against symbols" do
    [1, 2, 3].filter(:even?).should == [2]
  end

  it "should match against lambdas" do
    [1, 2, 3].filter(lambda{|n| n.even?}).should == [2]
  end

  it "should match against blocks" do
    [1, 2, 3].filter { |n| n.even? }.should == [2]
  end

  it "should support #map" do
    [1, 2, 3].filter(:even?) { |n| n + 1 }.should == [3]
  end

  it "should match against Hash" do
    [1, 2, 3, 4.2].filter(:to_i => :even?).should == [2, 4.2]
    [2, 3, 4.2].filter(:to_i => :even?, :ceil => :odd?).should == [4.2]
  end

  it "should match against Class and Module" do
    c = Class.new {}
    m = Module.new {}
    i = c.new

    [c, i, 1].filter(c).should == [c, i]
    [c, m, i, 1].filter(m).should == [m]
  end

  it "should match against Array" do
    [0, 1].filter([:even?, :zero?]).should == [0]
  end

  it "should match against true or false" do
    [0, false, 2, nil].filter(true).should == [0, 2]
    [0, false, 2, nil].filter(false).should == [false, nil]
  end

  it "should match using OR operator" do
    [0, 2, 3, 4].filter(:zero?, :odd?).should == [0, 3]
  end

  it "should be flexible" do
    conditions = Filter.match(:even?) | :odd? | :zero?

    [0, 1, 2].filter(conditions).should == [0, 1, 2]

    # 0 and negative
    conditions = Filter.and(:zero?, :even?) | proc { |n| n < 0 }
    [-1, 0, 1].filter(conditions).should == [-1, 0]

    [1, 2, 3].filter(Filter.not(:odd?)).should == [2]
  end
end