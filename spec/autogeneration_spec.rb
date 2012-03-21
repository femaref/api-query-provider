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
  
  # TODO move to own test
  it "should return :id as required symbol" do
    TestClass.required_symbols.should == [ :id ]
  end
  
  # TODO move to own test
  it "should raise on non-replaced mandatory field" do
    lambda { TestClass.where().replace_path }.should raise_error(Exception, "you didn't replace all fields in the api_path")
  end
  
end