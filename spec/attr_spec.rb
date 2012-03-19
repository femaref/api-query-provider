require 'spec_helper'
require 'lib/test_class'
require 'lib/github_commits'

describe "ApiQueryProvider::Provider" do
  it "should not replace api_url and api_path of two classes" do
    TestClass.api_url.should == "example.com"
    TestClass.api_path.should == "/foo/:id/id"
    
    GithubCommits.api_url.should == "http://github.com/api/v2/json/"
    GithubCommits.api_path.should == "commits/list/:user_id/:repository/:branch"
  end
end