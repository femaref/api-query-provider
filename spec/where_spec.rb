require 'spec_helper'
require 'lib/test_class'
require 'lib/optional_where_test_class'

describe "Where" do
  it "should merge the where_constraint hash" do
    real = TestClass.where(:id => 1).where(:name => "foo")
    
    real.where_constraints.should == ({ :id => 1, :name => "foo" })
  end
  
  it "should replace only symbols" do
    real = TestClass.where(:id => 1)
    
    real.replace_path.should == "/foo/1/id"
  end
  
  it "should not add non-defined symbol values" do
    real = TestClass.where(:id => 1, :name => "something")
    
    real.replace_path.should == "/foo/1/id"
  end
end

describe OptionalWhereTestClass do
  it "should replace optional :where symbol" do
    real = OptionalWhereTestClass.where(:ref_id => 1, :ref_type => 2)
    
    real.replace_path.should == "/foo/?ref_id=1&ref_type=2"
  end
end

