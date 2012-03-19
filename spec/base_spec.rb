require 'spec_helper'

describe ApiQueryProvider::Base do
  it "should raise an exception being instanciated directly" do
    lambda { real = ApiQueryProvider::Base({}) }.should raise_error
  end
end