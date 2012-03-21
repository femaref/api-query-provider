require 'spec_helper'
require 'lib/auto_generate_test_class'

# uses the auto generation test class as interface

describe AutoGenerateTestClass do
  it "should not modify @api_path" do
    HTTParty.stub(:get) { double(:body => %q({ "id" : "1", "name": "test" })) }
    
    real = AutoGenerateTestClass.api_path.dup
    
    AutoGenerateTestClass.where(:id => 1).execute
    
    AutoGenerateTestClass.api_path.should == real
  end
end