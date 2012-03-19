require 'spec_helper'
require 'lib/auto_generate_test_class'
require 'lib/test_class'

describe AutoGenerateTestClass do
  it "should auto generate fields" do
    real = AutoGenerateTestClass.new({:foo => :bar})
    
    real.respond_to?(:foo).should == true
    real.respond_to?(:bar).should == false
  end
end

describe TestClass do
  it "should raise exception encountering a non existant field" do
    lambda { real = TestClass.new({:foo => :bar}) }.should raise_error 
  end
end