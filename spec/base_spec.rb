require 'spec_helper'
require 'lib/auto_generate_test_class'

describe ApiQueryProvider::Base do
  it "should raise an exception being instanciated directly" do
    lambda { real = ApiQueryProvider::Base({}) }.should raise_error
  end
  
  it "should not be manipulated if a deriving class is manipulated" do
    AutoGenerateTestClass.new({:foo => :bar})
    
    ApiQueryProvider::Base.instance_methods.include?(:foo).should == false
  end
end