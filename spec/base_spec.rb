require 'spec_helper'
require 'lib/auto_generate_test_class'
require 'lib/parameterless_auto_generate_test_class'

describe ApiQueryProvider::Base do
  it "should raise an exception being instanciated directly" do
    lambda { real = ApiQueryProvider::Base.new({}) }.should raise_error(Exception, "this class should never be instanciated directly")
  end
  
  it "should not be manipulated if a deriving class is manipulated" do
    AutoGenerateTestClass.new({:foo => :bar})
    
    ApiQueryProvider::Base.instance_methods.include?(:foo).should == false
  end
  
  describe "extend" do
    it "should raise on missing symbol" do
      real = AutoGenerateTestClass.new({})
      
      lambda { real.extend }.should raise_error(Exception, "not all needed values are present")
    end
    
    it "should allow parameterless api calls" do
      HTTParty.stub(:get) { double(:body => %q({ "id" : "1", "name": "test" })) }
    
      real = ParameterlessAutoGenerateTestClass.new({})
      
      lambda { real.extend }.should_not raise_error
    end
  end
  
  describe "extend!" do
    it "should copy additional fields to the current object" do
      HTTParty.stub(:get) { double(:body => %q({ "id" : "1", "name": "test" })) }
      
      real = AutoGenerateTestClass.new({:id => 1})
      
      real.extend!
      
      real.name.should == "test"
    end
  end
end