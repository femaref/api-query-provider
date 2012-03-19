require 'spec_helper'
require 'lib/test_class'

describe "ApiQueryProvider::Provider" do
  it "should save the base class" do
    real = TestClass.interface
    
    real.klass.should == TestClass
  end
end