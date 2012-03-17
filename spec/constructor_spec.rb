require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/test_class')

describe "ApiQueryProvider::Provider" do
  it "should save the base class" do
    real = TestClass.interface
    
    real.klass.should == TestClass
  end
end
